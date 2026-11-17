#!/usr/bin/env bash
# moon-cross Linux 端到端验证 | moon-cross end-to-end validation on Linux
# 链路：CLI 脚手架 → MoonBit 静态库 → C 宿主调用 → 断言 | chain: scaffold -> static library -> C host call -> assertions
set -euo pipefail

cd "$(dirname "$0")/.."
MOON_HOME="${MOON_HOME:-$HOME/.moon}"
WORK="target/e2e-work"

echo "== [1/5] building moon-cross CLI (native release) =="
moon build --target native --release
CLI_EXE="$(find _build/native/release/build/tools/cli -maxdepth 1 -type f \( -name 'cli.exe' -o -name 'cli' \) | head -1)"
test -n "$CLI_EXE" || { echo "FAIL: cli binary not found"; exit 1; }
echo "CLI: $CLI_EXE"

echo "== [2/5] scaffolding example project =="
rm -rf "$WORK"
"$CLI_EXE" init --name mylib --output "$WORK"
test -f "$WORK/moon.mod" || { echo "FAIL: moon.mod not generated"; exit 1; }
test -f "$WORK/src/lib.mbt" || { echo "FAIL: src/lib.mbt not generated"; exit 1; }

echo "== [3/5] building example as native static library =="
(cd "$WORK" && moon build --target native --release)
LIB="$(find "$WORK/_build/native/release/build" -name 'src.a' -o -name 'src.lib' | head -1)"
test -n "$LIB" || { echo "FAIL: static library not found"; exit 1; }
echo "Library: $LIB"

echo "== [4/5] compiling C host against exported symbols =="
cat > "$WORK/host.c" <<'EOF'
#include "moonbit.h"
#include <stdio.h>
extern int32_t mylib_add(int32_t a, int32_t b);
extern int32_t mylib_lib_init(void);
int main(void) {
  moonbit_init();
  int32_t r = mylib_add(40, 2);
  int32_t i = mylib_lib_init();
  printf("mylib_add(40,2)=%d lib_init=%d\n", r, i);
  if (r == 42 && i == 42) {
    printf("E2E PASS\n");
    return 0;
  }
  printf("E2E FAIL\n");
  return 1;
}
EOF
cc -I "$MOON_HOME/include" "$WORK/host.c" "$LIB" -lm -o "$WORK/host"

echo "== [5/5] running FFI assertions =="
"$WORK/host"
