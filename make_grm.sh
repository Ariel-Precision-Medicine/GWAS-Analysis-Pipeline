# Generate a genetic relatedness matrix from .bim, .bed, and .fam files using gcta (available here: https://cnsgenomics.com/software/gcta/#Download)

cd /data/casecontrol_data/
gcta64 --mbfile test.list --autosome --make-grm --out ukb_cases
