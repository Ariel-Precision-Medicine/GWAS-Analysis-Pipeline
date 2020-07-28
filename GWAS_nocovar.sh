#GWAS run using gcta64 (available here: https://cnsgenomics.com/software/gcta/#Download)

# Input files:
# pancreatitis_vs_control_phenotypes.txt - fid, iid, and phenotype
# pancreatitis_vs_control_discrete_covars.txt - fid, iid, sex, and smoking
# pancreatitis_vs_control_quantitative_covars.txt - fid, iid, age, current bmi and PCAs 1-10 (generated by gcta6)4
# NAPS2.grm generated by gcta64 from .bed, .bim, and .fam
# Individuals to exclude from analysis are in the file exclude.txt
cd /data/matched_data/

gcta64 --mlma \
--mbfile test.list \
--grm ukb_matched \
--pheno pancreatitis_vs_control_phenotypes_matched.txt \
--out ukb_matched_nocovar \
--thread-num 10 \
--maf 0.01 \
--autosome
