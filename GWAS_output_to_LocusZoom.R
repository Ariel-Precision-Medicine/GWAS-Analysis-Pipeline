# Prepping GWAS output for LocusZoom batch upload (Hitspec)
# author: K Orlova 6/11/2020
# updated by D. Spagnolo 7/2/2020
remove(list = ls())

# GWAS results are in variable "results"
data.dir <- "/Users/dspagnolo/Documents/ariel/UKBB/TerraAnalysis/gwas_output_files"
fname <- "gwas_ap_caucasian_HWE1en6_AF1en2_prep.tsv"
#fname <- "gwas_cp_caucasian_HWE1en6_AF1en2_prep.tsv"
#fname <- "gwas_panc_caucasian_HWE1en6_AF1en2_prep.tsv"
results <-  read.table(file.path(data.dir,fname), header=TRUE, sep="\t")

# Create SNP column
results$SNP <- paste0("chr",results$chr,":",results$pos)
  
# Re-order by chromosome and P-value
results <- results[order(results$chr, results$pos),]

# Write out table of hits (if you want)
#thresh <- 10^(-7)
thresh <- 5*10^(-8)
hits <- results[which(results$p_value <= thresh),]
write.csv(hits,file=file.path(data.dir,paste0("hits_",fname)))


# Top independent hits function
tophitsloci <- function(results,n=30,d=400000) {
  results <- results[order(results$p_value),]
  lzh <- results[NULL,]
  # Look for top hit loci that aren't within 400kb of each other
  # Start by initializing
  # Then look for new loci
  lzh[1,] <- results[1,]
  for (i in 2:n) {
    prev <- lzh[i-1,]
    keep.looking <- TRUE
    where.to.look <- which(results$SNP==prev$SNP)
    while (keep.looking == TRUE) {
      where.to.look <- where.to.look + 1
      tempsum <- 0
      for (j in 1:(i-1)) {
        tempsum <- tempsum + (results[where.to.look,"chr"]==lzh[j,"chr"] & abs(results[where.to.look,"pos"]-lzh[j,"pos"]) < d)
      }
      if (tempsum==0) {
        lzh[i,] <- results[where.to.look,]
      } 
      if (tempsum >= 1) {
        keep.looking <- TRUE
      } else{
        keep.looking <- FALSE
      }
    }
  }
  return(lzh)
}


# Grab relevant columns
lz <- results[,c("SNP","p_value","chr","pos")]

# Make top independent hits list
tophits <- tophitsloci(lz,n=30,d=400000) # top 30 hits within 400k of each other
tophits <- tophits[tophits$p_value <= thresh,] # This p-value threshold determines whether to draw an LZ plot
write.table(tophits, file=file.path(data.dir,paste0("tophits_",fname)), quote=FALSE, col.names=TRUE, row.names=FALSE)


# Write hitspec file
n <- dim(tophits)[1]
hitspec <- data.frame(Feature=tophits$SNP,chr="na",start="na",end="na",flank="500kb",plot="yes",arguments="",stringsAsFactors = F)
hitspec$arguments <- paste0('rfrows=10 snpset="HapMap" showRecomb=T showAnnot=T showRefsnpAnnot=T annotCol="type" annotPch="22,21" title="',1:n,'_',tophits$SNP,'"') 
write.table(hitspec,file=file.path(data.dir,paste0("hitspec_",fname)),quote=F,sep="\t",row.names=F,col.names=T)


# Write out results file columns for LZ input
lzfile <- file.path(data.dir,paste0("lzfile_",fname))
write.table(lz[,c("SNP","p_value")],file=lzfile,quote=F,sep="\t",row.names=F,col.names=T)


# Compress results file	
#install.packages("R.utils")
library(R.utils)
gzip(lzfile,remove=FALSE)


