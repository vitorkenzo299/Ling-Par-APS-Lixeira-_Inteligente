#!/usr/bin/env bash
set -e
ROOT="$(cd "$(dirname "$0")" && pwd)"
EXDIR="$ROOT/exemplos"
ANAL="$ROOT/analisador"
VM="python3 vm.py"

echo "Compilando..."
make clean
make

shopt -s nullglob
for lix in "$EXDIR"/*.lix; do
  base=$(basename "$lix" .lix)
  echo
  echo "==== Test: $base ===="
  echo "-- Source --"
  sed -n '1,200p' "$lix"
  echo
  echo "-- Running analisador --"
  if ! "$ANAL" < "$lix" ; then
    echo "analisador failed for $base"
    continue
  fi
  echo "-- program.asm --"
  sed -n '1,200p' program.asm
  echo
  for tip in 1 0; do
    outfile="$EXDIR/${base}_t${tip}.out"
    expected="$EXDIR/${base}_t${tip}.expected"
    echo "-- Running VM (tipolixo=$tip) --"
    $VM program.asm --caprec 20 --caporg 15 --tipolixo $tip | tee "$outfile"
    if [ -f "$expected" ]; then
      if diff -u "$expected" "$outfile" > "$EXDIR/${base}_t${tip}.diff"; then
        echo "  => OK for tipolixo=$tip"
        rm -f "$EXDIR/${base}_t${tip}.diff"
      else
        echo "  => FAIL for tipolixo=$tip (diff saved to ${base}_t${tip}.diff)"
        sed -n '1,200p' "$EXDIR/${base}_t${tip}.diff"
      fi
    else
      echo "  => WARNING: expected file missing: $expected"
    fi
  done
done
shopt -u nullglob
