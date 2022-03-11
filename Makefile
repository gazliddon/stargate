TMP_DIR := tmp
OUT_DIR := roms
DEPS_DIR := deps
SRC_DIR := src
REF_ROMS_DIR := stargate

SRCS := stargate.src
SYMS := $(SRCS:%.src=$(TMP_DIR)/%.sym)
DEPS := $(SRCS:%.src=$(DEPS_DIR)/%.d)

GAZM_DIR = ../gazm/target/debug
ASM := @$(GAZM_DIR)/gazm --star-comments --max-errors 50 --mem-size 94208 --trailing-comments\
	   -vvvv \
		--set OUT_DIR $(OUT_DIR) \
		--set TMP_DIR $(TMP_DIR) \
		--set REF_ROMS_DIR $(REF_ROMS_DIR)

all: dirs $(SYMS)
	@echo All Done!

$(TMP_DIR)/%.sym : $(SRC_DIR)/%.src
	file $<
	@echo Assembling $< to $@
	$(ASM) -s $@ --deps $(DEPS_DIR)/$*.d $<

dirs:
	@mkdir -p $(TMP_DIR) $(OUT_DIR) $(DEPS_DIR)
	@echo Made dirs

-include $(DEPS)

clean:
	-@rm -rf $(TMP_DIR) $(OUT_DIR) $(DEPS_DIR)
	@echo cleaned outputs

