PROJECT_QUAD := ABCD
PROJECT_NAME := packetdump

# set include directory
CURDIR := $(dir $(realpath $(firstword $(MAKEFILE_LIST))))
TOPDIR := $(CURDIR)
PROJECT_INCLUDES := $(TOPDIR)src/include

# configure top-level files here
PROJECT_SOURCES := engine.c
PROJECT_SOURCES := $(addprefix $(CURDIR)src/, $(PROJECT_SOURCES))

# project configuration variables
PROJECT_ARGS := $(foreach v, $(filter $(PROJECT_QUAD)_%, $(.VARIABLES)), $(v)=$($(v)))

$(info TOPDIR $(TOPDIR))

# get all modules
$(foreach m, $(wildcard $(TOPDIR)src/**/module.mk), $(eval \
		$(eval MODULE_SOURCE_FILES := ) \
		$(eval CURDIR := $(dir $(realpath $m))) \
		$(eval include $m) \
		$(eval PROJECT_SOURCES += $(addprefix $(CURDIR), $(MODULE_SOURCE_FILES))) \
		$(eval PROJECT_INCLUDES += $(CURDIR)) \
	) \
)

$(info Build Configuration ------------------------------------------------)
$(info Build: $(BUILD)$(WORKSPACE))
$(info Configuration Variables: $(PROJECT_ARGS))
$(info Modules: $(ALL_MODULES))
$(info --------------------------------------------------------------------)

CURDIR=$(TOPDIR)

PROJECT_INCLUDES := $(addprefix -I, $(PROJECT_INCLUDES))
PROJECT_ARGS := $(addprefix -D, $(PROJECT_ARGS))
PROJECT_SOURCES := $(patsubst %.c,%.o, $(PROJECT_SOURCES))
PROJECT_OBJS := $(patsubst $(WORKSPACE)%,/build%, $(PROJECT_SOURCES))
PROJECT_B_OBJS := $(addprefix $(BUILD), $(PROJECT_OBJS))

$(info SOURCES: $(PROJECT_B_OBJS))

$(PROJECT_NAME): $(PROJECT_B_OBJS)
	@echo "#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>#"
	@echo "#>>> Building $@"
	@echo "#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>#"
	$(CC) -Wall -Wextra -Wpedantic -o $(BUILD)/$@ $(PROJECT_INCLUDES) $(PROJECT_ARGS) $(ALL_CFLAGS) $(filter %.o, $^)

$(BUILD)/build%.o: $(WORKSPACE)%.c
	@echo "#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>#"
	@echo "#>>> Building  Object File for $@"
	@echo "#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>#"
	-mkdir -p $(@D)
	$(CC) -Wall -Wextra -Wpedantic -o $@ -c $(ALL_LDFLAGS) $(PROJECT_INCLUDES) $(PROJECT_ARGS) $(ALL_CFLAGS) $<
