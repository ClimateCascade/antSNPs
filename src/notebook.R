###Ant snps
###13dec2014

##http://chibba.pgml.uga.edu/snphylo/

library(phyclust)
library(ape)

###Building a tree
x <- read.fasta('/N/dc2/scratch/scahan/sandbox/UVM_ant_sequences.fas')
set.seed(12345)
x.clust <- phyclust.edist(x$org)
x.nnt <- nj(x.clust)
x.rnt <- root(x.nnt,outgroup=1:5,resolve.root=TRUE)
x.rnt <- multi2di(x.nnt)
x.draw <- x.rnt
png('rplot.png')
plot(x.draw)
dev.off()

