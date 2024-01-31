TMP_DIR := tmp
OUT_DIR := roms
DEPS_DIR := deps
SRC_DIR := src
REF_ROMS_DIR := stargate

SRCS := stargate.gazm
SYMS := $(SRCS:%.gazm=$(TMP_DIR)/%.sym)
DEPS := $(SRCS:%.gazm=$(DEPS_DIR)/%.d)

ifeq ($(OS),Windows_NT)     # is Windows_NT on XP, 2000, 7, Vista, 10...
    OS = Windows
else
    OS = $(shell uname -s)
	ARCH = $(shell uname -m)
endif

RUSTFLAGS_Darwin_arm64 := RUSTFLAGS="-C target-cpu=apple-m1"
RUSTFLAGS_Darwin_x86_64 := RUSTFLAGS="-C target-cpu-native"

ASM := gazm build

all: dirs stargate.toml $(SYMS)
	@echo All Done!

$(TMP_DIR)/%.sym : $(SRC_DIR)/%.gazm
	@echo Assembling $< to $@
	@$(ASM) stargate.toml

dirs:
	@mkdir -p $(TMP_DIR) $(OUT_DIR) $(DEPS_DIR)
	@echo Made dirs

-include $(DEPS)

clean:
	-@rm -rf $(TMP_DIR) $(OUT_DIR) $(DEPS_DIR)
	@echo cleaned outputs

