#GWAS run using gcta64 (available here: https://cnsgenomics.com/software/gcta/#Download)

# Input files:
# pancreatitis_vs_control_phenotypes.txt - fid, iid, and phenotype
# pancreatitis_vs_control_discrete_covars.txt - fid, iid, sex, and smoking
# pancreatitis_vs_control_quantitative_covars.txt - fid, iid, age, current bmi and PCAs 1-10 (generated by gcta6)4
# NAPS2.grm generated by gcta64 from .bed, .bim, and .fam
# Individuals to exclude from analysis are in the file exclude.txt
cd /data/case_control_6x/

gcta64 --mlma \
--mbfile test.list \
--grm ukb_6x \
--pheno pancreatitis_vs_control_phenotypes_6x.txt \
--covar pancreatitis_vs_control_discrete_covars_6x_nq.txt \
--qcovar pancreatitis_vs_control_quantitative_covars_6x.txt \
--out ukb_6x \
--thread-num 10 \
--maf 0.01 \
--autosome
# \--remove exclude.txt
