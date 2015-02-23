###warm ant population genetic analyses

## sample information 
library('gdata')
info <- read.xls('../data/RADseq_mastersheet_2014.xlsx')

## sequence information
library('seqinr')
library('ape')
r1.check <- read.fasta('../data/UVM_ant_sequences_noPogo_ddrad1.fasta')
names(r1.check) <- sapply(names(r1.check),function(x) sub('00','',strsplit(x,split='_')[[1]][1]))
heatmap(do.call(rbind,lapply(r1.check,table)))
do.call(rbind,lapply(r1.check,table))

rad1 <- read.dna('../data/UVM_ant_sequences_noPogo_ddrad1.fasta',format='fasta')

## get genetic distances
rad1.labs <- sapply(labels(rad1),function(x) sub('00','',strsplit(x,split='_')[[1]][1]))
rad1.d <- dist.dna(rad1,model='F84')
rad1.m <- as.matrix(rad1.d)
rad1.m[is.na(rad1.m)] <- 0
rownames(rad1.m) <- colnames(rad1.m) <- rad1.labs
heatmap(rad1.m)
