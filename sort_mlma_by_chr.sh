#!/bin/sh
cd /data/casecontrol_data

for CHR in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 X Y

do

awk -v CHR="$CHR" '$1==${CHR} ukb_pancreatitis_vs_control_out.mlma | sort -k9 -n > results/chr{$CHR}_sorted.mlma

done
