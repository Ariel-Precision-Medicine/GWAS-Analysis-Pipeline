# Generate 10 PCAs from a genetic relatedness matrix using gcta (available here: https://cnsgenomics.com/software/gcta/#Download)
#cd /data/casecontrol_data/
#cd /data/matched_data/
#cd /data/cp_data/
#cd /data/ap_data/
#cd /data/case_control_6x/
cd /data/hail_12x

#gcta64 --grm ukb_cases --pca 10 --out ukb_cases
#gcta64 --grm ukb_matched --pca 10 --out ukb_matched
#gcta64 --grm cp_only --pca 10 --out cp_only
#gcta64 --grm hail_12x --pca 10 --out hail_12x
gcta64 --grm hail_12x --pca 10 --thread-num 7 --out hail_12x
