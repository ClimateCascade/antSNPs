###Ant snps
###13dec2014

##http://chibba.pgml.uga.edu/snphylo/

library(phyclust)
library(ape)

###Building a tree
x <- read.fasta('/N/dc2/scratch/scahan/sandbox/UVM_ant_sequences.fas')
set.seed(12345)
nnt <- phyclust.edist(x$org)
png('rplot.png')
plot(nnt)
dev.off()