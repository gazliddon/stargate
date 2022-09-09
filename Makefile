TMP_DIR := tmp
OUT_DIR := roms
DEPS_DIR := deps
SRC_DIR := src
REF_ROMS_DIR := stargate

SRCS := stargate.src
SYMS := $(SRCS:%.src=$(TMP_DIR)/%.sym)
DEPS := $(SRCS:%.src=$(DEPS_DIR)/%.d)

GAZM_DIR := ~/development/gazm/gazm
GAZM := cargo +nightly run --release --manifest-path $(GAZM_DIR)/Cargo.toml --

ASM := @$(GAZM) asm --star-comments --max-errors 50 --mem-size 94208 --trailing-comments\
	   -v \
		--set OUT_DIR $(OUT_DIR) \
		--set TMP_DIR $(TMP_DIR) \
		--set REF_ROMS_DIR $(REF_ROMS_DIR)

all: dirs $(SYMS)
	@echo All Done!

$(TMP_DIR)/%.sym : $(SRC_DIR)/%.src
	file $<
	@echo Assembling $< to $@
	$(ASM) -s $@ --deps $(DEPS_DIR)/$*.d $< -l $(TMP_DIR)/$(basename $(notdir $@)).lst

dirs:
	@mkdir -p $(TMP_DIR) $(OUT_DIR) $(DEPS_DIR)
	@echo Made dirs

-include $(DEPS)

clean:
	-@rm -rf $(TMP_DIR) $(OUT_DIR) $(DEPS_DIR)
	@echo cleaned outputs

cmp: 
	@echo CSUMing ROMS
	@./checksumroms \
4fe4209ccaa0fff9bbd0ece0e677803ce1087d4961c7d1c6b685e2baa56265e7  $(OUT_DIR)/01 \
c97c1c32e2c131f02001a8b4cf72ad1349f085b974a44f2fe01b5844186d42c8  $(OUT_DIR)/02 \
1b8471c75b1e26ed78d5f92acb3e7cbc3e30f01b4229e28cdee9ea5af5ae807f  $(OUT_DIR)/03 \
4f2b2e31fd40da34c220bdab5292a173eb5931f9f6285ae61093162224cc5b75  $(OUT_DIR)/04 \
7c635368627678b757a4fa1270d845e89038d8bf5d32e8e4b16f2aaa14d7868e  $(OUT_DIR)/05 \
e3802b3341028c91eaff3e8fc3e3bd01b4a991d4aafee9940f3cc171b9ca4812  $(OUT_DIR)/06 \
2890051288bda38e12c63abad3f4ed411e3d3b0bb5ae250f0371c0ee20927cb9  $(OUT_DIR)/07 \
915e9bd31a249b7f6bdeee961bd414e31a99a108f41561768eda9ff5e8af37ae  $(OUT_DIR)/08 \
a92c7237dd324ffc1210fce9c9295699ba7dcfd1910e98f5d43c80b9f2d8da44  $(OUT_DIR)/09 \
7c1d69e88dc7950a9f0471a855baff426c01523ab8e3f490a8cfd529b1f035d4  $(OUT_DIR)/10 \
bb51fbaf4d85a328da32139dcff474feb7ee3d47f656a10b842a92f7dc9b99e8  $(OUT_DIR)/11 \
07aa49195f6dc36dde9daf06ecdc13378bf06181d1e25f3b093b2e75c14d4cc0  $(OUT_DIR)/12
	@echo testing done

