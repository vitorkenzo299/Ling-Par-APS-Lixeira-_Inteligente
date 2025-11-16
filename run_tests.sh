#!/usr/bin/env bash
set -e
make clean
make

for lix in exemplos/*.lix; do
  base=$(basename "$lix" .lix)
  echo "=== Test: $base ==="
  ./analisador < "$lix"
  for tip in 1 0; do
    out="exemplos/${base}_t${tip}.out"
    exp="exemplos/${base}_t${tip}.expected"
    python3 vm.py program.asm --caprec 20 --caporg 15 --tipolixo $tip > "$out"
    if [ -f "$exp" ]; then
      if diff -u "$exp" "$out" > "exemplos/${base}_t${tip}.diff"; then
        echo "OK $base t=$tip"
        rm -f "exemplos/${base}_t${tip}.diff"
      else
        echo "FAIL $base t=$tip (diff saved)"
      fi
    else
      echo "MISSING expected: $exp"
    fi
  done
done
