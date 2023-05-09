TMP_DIR := tmp
OUT_DIR := roms
DEPS_DIR := deps
SRC_DIR := src
REF_ROMS_DIR := stargate

SRCS := stargate.src
SYMS := $(SRCS:%.src=$(TMP_DIR)/%.sym)
DEPS := $(SRCS:%.src=$(DEPS_DIR)/%.d)

GAZM_DIR := ~/development/gazm/gazm

ifeq ($(OS),Windows_NT)     # is Windows_NT on XP, 2000, 7, Vista, 10...
    OS = Windows
else
    OS = $(shell uname -s)
	ARCH = $(shell uname -m)
endif

RUSTFLAGS_Darwin_arm64 := RUSTFLAGS="-C target-cpu=apple-m1"
RUSTFLAGS_Darwin_x86_64 := RUSTFLAGS="-C target-cpu-native"

PFX := $(RUSTFLAGS_$(OS)_$(ARCH))
ASM := $(PFX) cargo run --manifest-path $(GAZM_DIR)/Cargo.toml -- build

all: dirs gazm.toml $(SYMS)
	@echo All Done!

$(TMP_DIR)/%.sym : $(SRC_DIR)/%.src
	@echo Assembling $< to $@
	$(ASM) gazm.toml

dirs:
	@mkdir -p $(TMP_DIR) $(OUT_DIR) $(DEPS_DIR)
	@echo Made dirs

-include $(DEPS)

clean:
	-@rm -rf $(TMP_DIR) $(OUT_DIR) $(DEPS_DIR)
	@echo cleaned outputs

