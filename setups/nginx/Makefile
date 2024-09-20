UK_ROOT ?= $(PWD)/repos/unikraft
UK_BUILD ?= $(PWD)/out
LIBS = $(PWD)/repos/libs
UK_LIBS ?= $(LIBS)/musl:$(LIBS)/nginx:$(LIBS)/lwip
UK_APP ?= $(PWD)

.PHONY: all defconfig

all:
	@$(MAKE) -C $(UK_ROOT) A=$(UK_APP) L=$(UK_LIBS) O=$(UK_BUILD)

$(MAKECMDGOALS):
	@$(MAKE) -C $(UK_ROOT) A=$(UK_APP) L=$(UK_LIBS) O=$(UK_BUILD) $(MAKECMDGOALS)
