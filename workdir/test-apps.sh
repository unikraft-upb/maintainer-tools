#!/bin/bash

kill_vm()
{
    echo "$1" | grep "-qemu-" > /dev/null 2>&1
    if test $? -eq 0; then
        sudo kill -KILL $(pgrep -f "qemu-system.*$2") > /dev/null 2>&1
    fi

    echo "$1" | grep "-fc-" > /dev/null 2>&1
    if test $? -eq 0; then
        sudo kill -KILL $(pgrep -f "firecracker.*$2") > /dev/null 2>&1
    fi
}

test_no_output()
{
    eval "$1" > "$2" 2>&1 &

    sleep 5
    kill_vm "$1" "$3"

    grep "CRIT" < "$2" > /dev/null 2>&1
    if test $? -eq 0; then
        echo "FAILED with CRIT errors."
        return
    fi

    grep "Powered by" < "$2" > /dev/null 2>&1
    if test $? -ne 0; then
        echo "FAILED to boot"
        return
    fi

    echo "PASSED"
}

test_helloworld()
{
    eval "$1" > "$2" 2>&1 &
    sleep 5

    grep -E "^Hello world" < "$2" > /dev/null 2>&1 && echo "PASSED" || echo "FAILED"
    kill_vm "$1" "$3"
}

test_lua()
{
    eval "$1" > "$2" 2>&1 &
    sleep 5

    grep -E "^hello world from initrd" < "$2" > /dev/null 2>&1 && echo "PASSED" || echo "FAILED"
    kill_vm "$1" "$3"
}

test_helloworld_cpp()
{
    eval "$1" > "$2" 2>&1 &
    sleep 5

    grep -E "^Hello World" < "$2" > /dev/null 2>&1 && echo "PASSED" || echo "FAILED"
    kill_vm "$1" "$3"
}

test_httpreply()
{
    eval sudo "$1" > "$2" 2>&1 &
    sleep 3

    curl --connect-timeout 10 -s 172.44.0.2:8123 2> /dev/null | grep "It works!" > /dev/null 2>&1 && echo "PASSED" || echo "FAILED"
    kill_vm "$1" "$3"
}

test_redis()
{
    eval sudo "$1" > "$2" 2>&1 &
    sleep 3

    echo "PING" | timeout 10 redis-cli -h 172.44.0.2 -p 6379 2> /dev/null | grep "PONG" > /dev/null 2>&1 && echo "PASSED" || echo "FAILED"
    kill_vm "$1" "$3"
}

test_nginx()
{
    eval sudo "$1" > "$2" 2>&1 &
    sleep 3

    curl --connect-timeout 10 172.44.0.2 > /dev/null 2>&1 && echo "PASSED" || echo "FAILED"
    kill_vm "$1" "$3"
}

test_sqlite()
{
    # HACK: Clearly not the best way to do this.
    # Find a way to capture the output of an application when ran using the
    # run scripts.
    (sleep 4; echo -e '.open chinook.db\nselect * from Album;\n.exit') | eval sudo "$1" > "$2" 2>&1 &
    sleep 10

    grep -E "^346\|Mozart: Chamber Music\|274" < "$2" > /dev/null 2>&1 && echo "PASSED" || echo "FAILED"
    kill_vm "$1" "$3"
}

test_python3()
{
    # HACK: Clearly not the best way to do this.
    # Find a way to capture the output of an application when ran using the
    # run scripts.
    (sleep 4; echo 'print("Hello World")') | eval sudo "$1" > "$2" 2>&1 &
    sleep 10

    grep -E "^Hello World" < "$2" > /dev/null 2>&1 && echo "PASSED" || echo "FAILED"
    kill_vm "$1" "$3"
}

source test-list.sh

build_logs_dir="$(pwd)/logs/builds"
run_logs_dir="$(pwd)/logs/runs"

mkdir -p "${build_logs_dir}" > /dev/null 2>&1
mkdir -p "${run_logs_dir}" > /dev/null 2>&1

apps=()
if test "$#" -ge 1; then
    for app in "$@"; do
            apps+=("apps/${app}")
    done
else
    apps=(apps/*/)
fi

for a in "${apps[@]}"; do
    echo "Testing builds for ${a}:"
    mkdir "${build_logs_dir}/$(basename "${a}")" > /dev/null 2>&1
    mkdir "${run_logs_dir}/$(basename "${a}")" > /dev/null 2>&1
    pushd "$a" > /dev/null 2>&1 || exit 1

    for build_script in ./clang-* ./gcc-*; do
        skip=0
        printf "%-70s" "building with ${build_script}"

        build_log_file="${build_logs_dir}/$(basename "${a}")/$(basename "${build_script}" .sh)"
        run_log_file="${run_logs_dir}/$(basename "${a}")/$(basename "${build_script}" .sh)"

        for regex in "${test_include_list[@]}"; do
            echo "${build_script}" | grep -E "${regex}" &> /dev/null

            if test "$?" -ne 0; then
                    skip=1
                    break
            fi
        done

        for regex in "${test_exclude_list[@]}"; do
            echo "${build_script}" | grep -E "${regex}" &> /dev/null

            if test "$?" -eq 0; then
                    skip=1
                    break
            fi
        done

        test "${skip}" -ne 0 && echo "SKIPPED" && continue

        eval "${build_script}" > "${build_log_file}" 2>&1 < /dev/null

        if test $? -ne 0; then
        echo "FAILED"
        continue
        else
        echo "PASSED"
        fi

        plat=$(< "${build_log_file}" head -5 | grep "plat: " | cut -d" " -f2)
        arch=$(< "${build_log_file}" head -5 | grep "arch: " | cut -d" " -f2)
        fs=$(< "${build_log_file}" head -5 | grep "fs: " | cut -d" " -f2)
        run_script="./run-"

        if test -n "${plat}"; then
            run_script="${run_script}${plat}"
        fi

        if test -n "${arch}"; then
            run_script="${run_script}-${arch}"
        fi

        if test -n "${fs}"; then
            run_script="${run_script}-${fs}"
        fi

        run_script="${run_script}.sh"
        printf "%-70s" "Running ${a} on ${plat} ${arch} ${fs}"

        for regex in "${run_test_include_list[@]}"; do
            echo "${build_script}" | grep -E "${regex}" &> /dev/null

            if test "$?" -ne 0; then
                    skip=1
                    break
            fi
        done

        for regex in "${run_test_exclude_list[@]}"; do
            echo "${build_script}" | grep -E "${regex}" &> /dev/null

            if test "$?" -eq 0; then
                    skip=1
                    break
            fi
        done

        test "${skip}" -ne 0 && echo "SKIPPED" && continue

        app_base=$(echo "${a}" | cut -d"/" -f2)
        if test "$(type -t "test_${app_base}")" = "function"; then
            test_"${app_base}" "${run_script}" "${run_log_file}" "${app_base}"
        else
            test_no_output "${run_script}" "${run_log_file}" "${app_base}"
        fi
    done

    popd > /dev/null 2>&1 || exit 1
done
