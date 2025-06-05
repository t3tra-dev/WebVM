# ---------- paths ----------
CLANG   ?= clang
LLD     ?= wasm-ld
WITBIND ?= wit-bindgen
NINJA   ?= ninja
BUILD   ?= build
TSC     ?= npx tsc

# ---------- flags ----------
CFLAGS  = -O2 -nostdlib -target wasm32-unknown-unknown \
          -fno-builtin -matomics -mbulk-memory
LDFLAGS = -z stack-size=1048576 --export=_start --allow-undefined \
          --import-memory --shared-memory --max-memory=67108864

# ---------- ninja ----------
default: ninja

ninja: $(BUILD)/build.ninja
	$(NINJA) -f $<

$(BUILD)/build.ninja: Makefile
	@mkdir -p $(BUILD)
	@echo '# auto-generated' > $@
	@echo 'rule CC' >> $@
	@echo '  command = $(CLANG) $(CFLAGS) -c $$in -o $$out' >> $@
	@echo 'rule LD' >> $@
	@echo '  command = $(LLD) $(LDFLAGS) $$in -o $$out' >> $@
	@echo 'rule COPY' >> $@
	@echo '  command = cp $$in $$out' >> $@
	@echo 'rule TSC' >> $@
	@echo '  command = $(TSC) --outDir $(BUILD)' >> $@
	@echo '' >> $@
	@echo 'build build/kernel/hello.o: CC kernel/hello.c' >> $@
	@echo 'build build/kernel.wasm: LD build/kernel/hello.o' >> $@
	@echo 'build build/gui/index.html: COPY gui/index.html' >> $@
	@echo 'build build/syslib/index.js: TSC syslib/index.ts' >> $@
	@echo '' >> $@
	@echo 'default build/kernel.wasm build/gui/index.html build/syslib/index.js' >> $@

.PHONY: clean
clean:
	@if [ -f ./.ninja_log ]; then rm ./.ninja_log; fi
	rm -rf $(BUILD)
