###Ant snps
###13dec2014

##http://chibba.pgml.uga.edu/snphylo/

###Building a tree
x <- readLines('/N/dc2/scratch/scahan/sandbox/UVM_ant_sequences.fas')
ids <- x[(1:length(x))[c(T,F)]]
x <- x[(1:length(x))[c(F,T)]]

library(ape)
snp = rbind(A=c(1,1,1,0,1),B=c(1,1,0,1,1),D=c(1,1,1,1,1),E=c(0,1,0,1,0))
stree = nj(dist.gene(snp))
png('rplot.png')
plot(stree)
dev.off()