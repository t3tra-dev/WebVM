# ---------- paths ----------
CLANG   ?= clang
LLD     ?= wasm-ld
WITBIND ?= wit-bindgen
NINJA   ?= ninja
BUILD   ?= build

# ---------- flags ----------
CFLAGS  = -O2 -nostdlib -target wasm32-unknown-unknown \
          -fno-builtin -matomics -mbulk-memory
LDFLAGS = -z stack-size=1048576 --export=_start --allow-undefined \
          --import-memory --shared-memory --max-memory=67108864

# ---------- ninja ----------
default: ninja

ninja: build.ninja
	$(NINJA) -f $<

.PHONY: clean
clean:
	@if [ -f ./.ninja_log ]; then rm ./.ninja_log; fi
	rm -rf $(BUILD)
