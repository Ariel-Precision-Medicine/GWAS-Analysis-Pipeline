#!/bin/sh
#for CHR in {1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,X,Y}
for CHR in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 X Y

do

#plink --bfile ukb_cal_chr${CHR}_v2 --keep case_control_ids.txt --make-bed --out ukb_chr${CHR}_cases 
plink --bfile ukb_cal_chr${CHR}_v2 --keep case_control_ids_matched.txt --make-bed --out ukb_chr${CHR}_matched 

done
