# GWAS-Analysis-Pipeline
The analysis pipeline for a complex trait GWAS

## To Do ##
- wrap entire workflow into single automated script

## GWAS Workflow ##

1. Create covariate files using *gwas_prep_matched.Rmd* on UKB Application 48065
```
case_control_ids_matched.txt
pancreatitis_vs_control_discrete_covars_matched.txt
pancreatitis_vs_control_quantitative_covars_bmiOnly_matched.txt
```
Note: may need to remove quotations around discrete variables using *remove_quotes.sh*

2. Create new data directory for analysis - case/control input files and results. Make sure /data/ mounted drive permissions are r/w.
```
cd /data
mkdir matched_data
chmod -R 777 /data/
```

3. Run extract_gwas_patients.sh script out of data directory with full "ukbgene cal" output files to extract cases & controls from genetic (BED, BIM, FAM) files via PLINK
```
cd ../whole_data/
cp /home/ubuntu/case_control_ids_matched.txt .
./extract_gwas_patients.sh
```

3. Move extracted data into proper directory, and create list of files for downstream analysis
```
mv *_matched.{bed,bim,fam} ../matched_data/
cd ../matched_data/
ls *.bed | sed 's/.\{4\}$//' > test.list
cp /home/ubuntu/pancreatitis_vs_control_discrete_covars_matched.txt /home/ubuntu/pancreatitis_vs_control_quantitative_covars_bmiOnly_matched.txt /home/ubuntu/pancreatitis_vs_control_phenotypes_matched.txt /home/ubuntu/case_control_ids_matched.txt .
```

4. Make Genetic Relatedness Matrix
```
cd /home/ubuntu/GWAS-Analysis-Pipeline/
./make_grm.sh
```

5. Run Principal Component Analysis
```
./make_pca.sh 
```

6. Merge in PCs to the quantitative covariate file using *gwas_prep_matched.Rmd*
```
cp /data/matched_data/ukb_matched.eigenvec /home/ubuntu/docker
pancreatitis_vs_control_quantitative_covars_matched.txt
```

7. Run GWAS
```
GWAS_script.sh
```

8. Examine output file using *gwas_results.Rmd*
```
ukb_pancreatitis_vs_control_matched_out.mlma
```

## UKB Cohort ##

"UK Biobank was established by the Wellcome Trust medical charity, Medical Research Council, Department of Health, Scottish Government and the Northwest Regional Development Agency. It has also had funding from the Welsh Government, British Heart Foundation, Cancer Research UK and Diabetes UK. UK Biobank is supported by the National Health Service (NHS). UK Biobank is open to bona fide researchers anywhere in the world, including those funded by academia and industry.  The medical research project is a non-profit charity which had initial funding of about £62 million."

## Inclusion criteria ##

All patients with ICD-10-designated AP or CP, as referenced using UDI 41270, were included in the study. 

AP Codes: K85,K850,K851,K852,K853, K858, K859

CP Codes: K860, K861

These cohorts were tested as an aggregate, and as distinct case cohorts.

Controls were age & sex matched using the MatchIt R library, using nearest neighbor matching with distance estimated via logistic regression. 

## Exclusion criteria ## 

PLINK excluded x subjects based on ____

## Principal Components of Ancestry and Genetic Relatedness Matrix ##

Principal components of ancestry (PCA) and the genetic relatedness matrix (GRM) were generated from the autosomes using GCTA (Yang et al. 2011).

## Stepwise regression ## 

For the NAPS2 study we are replicating, stepwise regression was performed on the full model of age, age^2, sex, BMI, alcohol use, smoking, and PCAs 1-10 to determine the appropriate model using the MASS package (Venables et al. 2003) in R v3.5.2 (R Core Team 2018). BMI was calculated using the subject's height and weight. Alcohol use and smoking were self-reported by study participants. Alcohol use was defined as "yes" if the study participant reported current alcohol consumption, otherwise alcohol use was designated as "no". Study participants were classified as a smoker if the study participant reported current smoking, otherwise the study participant was classified as a nonsmoker. Stepwise regression identified sex, BMI, smoking, PCA 1, and PCA 8 as contributing to the model of pancreatitis.

For the UKB study, we used the NAPS2-identified covariates of sex, BMI, and smoking, in addition to the first 10 principal components for the multiple linear model. 

## Genome-wide association study ## 

GWAS was performed on ___ imputed SNPs with genotyping on the autosomes with a minor allele frequency ≥ 0.01 using GCTA (Yang et al. 2011). A multiple linear model controlled for age, sex, BMI, smoking, and PCAs 1-10 as covariates was used for the analysis along with a genetic relatedness matrix. Genome-wide significant (p ≤ 5 x 10-8) loci were defined using PLINK v1.90 (Purcell et al. 2007).

## Helpful code snippets ##

Extract *only* case or control IDs
'''
cat pancreatitis_vs_control_phenotypes_matched.txt | awk '$3=="1" {print $1}' > case_ids.txt
cat pancreatitis_vs_control_phenotypes_matched.txt | awk '$3=="0" {print $1}' > control_ids.txt
'''

## Older Self-Reported Workflow ##

### Generating UKBB IDs for cases and controls (non-matched) ###
```
grep 1165 Diagnoses.only.txt | awk '{print $1}' > ukb_id_pancreatitis.txt
grep -v 1165 Diagnoses.only.txt | shuf -n 1362 | awk '{print $1}' > ukb_id_control.txt
```
### Grab Covariates ###
**Sex / Gender**
```
./ukbconv ukb32816.enc_ukb txt -s31 -osex.txt
cp sex.txt sex.factor.txt
awk -i inplace '$2=="0" {$2="Female"}1' sex.factor.txt 
awk -i inplace '$2=="1" {$2="Male"}1' sex.factor.txt 
grep -w -F -f ukb_id_pancreatitis.txt sex.txt > sex_pancreatitis.txt
grep -w -F -f ukb_id_control.txt sex.txt > sex_control.txt
grep -w -F -f ukb_id_pancreatitis.txt sex.factor.txt > sex_pancreatitis.factor.txt
grep -w -F -f ukb_id_control.txt sex.factor.txt > sex_control.factor.txt
```
Compare with
```
sort ukb_id_pancreatitis.txt | head
sort sex_pancreatitis.txt | head
```
**Smoking Status**
```
./ukbconv ukb32816.enc_ukb txt -s1239 -ocurrent_tobacco_smoking
./ukbconv ukb32816.enc_ukb txt -s20116 -osmoking_status
grep -w -F -f ukb_id_pancreatitis.txt current_tobacco_smoking.txt > current_tobacco_pancreatitis.tx
grep -w -F -f ukb_id_control.txt current_tobacco_smoking.txt > current_tobacco_control.txt
grep -w -F -f ukb_id_pancreatitis.txt smoking_status.txt > smoking_status_pancreatitis.txt
grep -w -F -f ukb_id_control.txt smoking_status.txt > smoking_status_control.txt
```

## Bibliography ## 

XDurbin, R. 2014. Efficient haplotype matching and storage using the positional Burrows-Wheeler transform (PBWT). _Bioinformatics_ 30(9), pp. 1266–1272.

Loh, P.-R., Danecek, P., Palamara, P.F., et al. 2016. Reference-based phasing using the Haplotype Reference Consortium panel. _Nature Genetics_ 48(11), pp. 1443–1448.

McCarthy, S., Das, S., Kretzschmar, W., et al. 2016. A reference panel of 64,976 haplotypes for genotype imputation. _Nature Genetics_ 48(10), pp. 1279–1283.

Purcell, S., Neale, B., Todd-Brown, K., et al. 2007. PLINK: a tool set for whole-genome association and population-based linkage analyses. _American Journal of Human Genetics_ 81(3), pp. 559–575.

R Core Team 2018. _R: A Language and Environment for Statistical Computing_. Vienna, Austria: R Foundation for Statistical Computing.

Sarner, M. and Cotton, P.B. 1984. Classification of pancreatitis. _Gut_ 25(7), pp. 756–759.

Venables, William N., Venables, W N and Ripley, B.D. 2003. _Modern Applied Statistics with S_. Text is Free of Markings. New York: Springer-Verlag New York, LLC.

Whitcomb, D.C., Yadav, D., Adam, S., et al. 2008. Multicenter approach to recurrent acute and chronic pancreatitis in the United States: the North American Pancreatitis Study 2 (NAPS2). _Pancreatology_ 8(4–5), pp. 520–531.

Yang, J., Lee, S.H., Goddard, M.E. and Visscher, P.M. 2011. GCTA: a tool for genome-wide complex trait analysis. _American Journal of Human Genetics_ 88(1), pp. 76–82.
