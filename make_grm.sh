# Generate a genetic relatedness matrix from .bim, .bed, and .fam files using gcta (available here: https://cnsgenomics.com/software/gcta/#Download)

#cd /data/casecontrol_data/
#cd /data/matched_data/
#cd /data/cp_data/
#cd /data/ap_data/
cd /data/case_control_6x/

#gcta64 --mbfile test.list --autosome --make-grm --out ukb_cases
#gcta64 --mbfile test.list --autosome --make-grm --out cp_only
#gcta64 --mbfile test.list --autosome --make-grm --out ukb_aponly
gcta64 --mbfile test.list --autosome --make-grm --out ukb_6x
