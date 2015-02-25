###warm ant population genetic analyses
###library('RADami')
###library('phytools')
library('gdata')
library('seqinr')
library('ape')
library('adegenet')
source('./waFunctions.R')

rad1.snps <- read.dna('../data/UVM_ant_sequences.fasta',format='fasta') ###all sequences
for (i in seq(0.30,0.85,by=0.05)){print(i);write.dna(waQC(rad1.snps,i),file=paste('../data/uvm_qc_',i,'.fasta',sep=''))}
