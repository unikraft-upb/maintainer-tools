# List of regex that will match the tests you want to run
# The regex will match the build script (e.g. `clang-10-build-qemu-x86_64-9pfs.sh`)
# NOTE: This includes both build and run tests
# e.g. test_include_list=("gcc-.*-initrd-pie-.*" "clang-.*-initrd.sh|9pfs.sh")
test_include_list=()

# List of regex that will match the tests that should be skipped
# The regex will match the build script (e.g. `clang-10-build-qemu-x86_64-9pfs.sh`)
# NOTE: This includes both build and run tests
# e.g. test_exclude_list=("clang-.*-pie.*" ".*-fc-aarch64.*")
test_exclude_list=()

# List of regex that will match the tests you want to run
# The regex will match the build script (e.g. `clang-10-build-qemu-x86_64-9pfs.sh`)
# NOTE: This includes ONLY run tests. The build is not influenced by this list.
# e.g. run_test_include_list=(".*x86_64-initrd.*" ".*-fc-aarch64.*")
run_test_include_list=()

# List of regex that will match the tests that should be skipped
# The regex will match the build script (e.g. `clang-10-build-qemu-x86_64-9pfs.sh`)
# NOTE: This includes ONLY run tests. The build is not influenced by this list.
# e.g. run_test_exclude_list=("clang-.*-pie.*" ".*-fc-aarch64.*")
run_test_exclude_list=()
