# Generate 10 PCAs from a genetic relatedness matrix using gcta (available here: https://cnsgenomics.com/software/gcta/#Download)
#cd /data/casecontrol_data/
cd /data/matched_data/

#gcta64 --grm ukb_cases --pca 10 --out ukb_cases
gcta64 --grm ukb_matched --pca 10 --out ukb_matched
