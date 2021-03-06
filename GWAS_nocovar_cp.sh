#GWAS run using gcta64 (available here: https://cnsgenomics.com/software/gcta/#Download)

# Input files:
# pancreatitis_vs_control_phenotypes.txt - fid, iid, and phenotype
# pancreatitis_vs_control_discrete_covars.txt - fid, iid, sex, and smoking
# pancreatitis_vs_control_quantitative_covars.txt - fid, iid, age, current bmi and PCAs 1-10 (generated by gcta6)4
# NAPS2.grm generated by gcta64 from .bed, .bim, and .fam
# Individuals to exclude from analysis are in the file exclude.txt

cd /data/cp_data/

gcta64 --mlma \
--mbfile test.list \
--grm cp_only \
--pheno pancreatitis_vs_control_phenotypes_cp_only.txt \
--out ukb_cponly_nocovar_out \
--thread-num 10 \
--maf 0.01 \
--autosome

