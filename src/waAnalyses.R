###warm ant population genetic analyses
###library('RADami')
###library('phytools')
library('gdata')
library('seqinr')
library('ape')
library('adegenet')
source('./waFunctions.R')

###http://adegenet.r-forge.r-project.org/files/tutorial-genomics.pdf


###Only analyze identified specimens
### rad1 <- read.dna('../data/UVM_ant_ids.fasta',format='fasta') ###only samples with species ids
### rad1 <- read.dna('../data/UVM_ant_ids.fasta',format='fasta') ###only samples with species ids
rad1.snps <- read.dna('../data/UVM_ant_sequences.fasta',format='fasta') ###all sequences
info <- info <- read.xls('../data/RADseq_mastersheet_2014.xlsx')

### quality control
ac <- apply(do.call(rbind,lapply(waConvert(rad1.snps),table)),1,function(x) x/sum(x))

###for (i in seq(0.40,0.5,by=0.05)){print(i);write.dna(waQC(rad1.snps,i),file=paste('../data/uvm_qc_',i,'.fasta',sep=''))}
###rad1 <- waQC(rad1,0.5)
###write.dna(waQC(rad1.snps,0.90),file=paste('../data/uvm_qc_',0.90,'.fasta',sep=''))
rad1 <- read.dna('../data/uvm_qc_0.90.fasta')


### formalize labels
site.labs <- toupper(paste(as.character(info$Site),info$Collection_no,sep=''));site.labs <- sub('BRM /BRF','BRF',site.labs);site.labs <- sub('IJAMSQL','IJAMS2',site.labs);site.labs <- sub(" \\(SECOND SAMPLE\\)","42",site.labs)
phyt.labs <- sub('-','',as.character(info$Phytotron_ID..Ap_GXL.))
if ('dimnames' %in% names(attributes(rad1))){rad.labs <- waSampleIDs(x=attributes(rad1)$dimnames[[1]])}else{rad.labs <- waSampleIDs(x=attributes(rad1)$names)}
rad.labs[rad.labs%in%phyt.labs] <- site.labs[match(rad.labs,phyt.labs,nomatch=0)]
info.rad <- info[match(rad.labs,site.labs),]
rad.labs <- paste(rad.labs,info.rad[,4],info.rad[,5])

### distance based analyses
rad1.d <- dist.dna(rad1,model='TN93')
rad1.m <- as.matrix(rad1.d)
attr(rad1.d,'Labels') <- rad1.labs <- rad.labs
rownames(rad1.m) <- colnames(rad1.m) <- rad1.labs
heatmap(rad1.m)
rad1.tree <- nj(rad1.d)
rad1.tree <- ladderize(rad1.tree,right=FALSE)
plot(rad1.tree)
#root.n <- sort(unlist(sapply(c('NSP5','NSP11','BARD5','NSP7','NOCK9','NOCK1','NSP4'),grep,x=rad1.labs)))
root.n <- sort(unlist(sapply(c('NSP5'),grep,x=rad1.labs)))
rad1.tree <- root(rad1.tree,outgroup=root.n)

### plot tree
plot(rad1.tree)

## Assess tree validity
x <- as.vector(rad1.d)
###nj
y <- as.vector(as.dist(cophenetic(rad1.tree)))
plot(x, y, xlab="original pairwise distances", ylab="pairwise distances on the tree", main="Is NJ appropriate?", pch=20, col=transp("black",.1), cex=3)
abline(lm(y~x), col="red")
nj.boot <- boot.phylo(rad1.tree,rad1,function(e) root(nj(dist.dna(e,model='TN93')),root.n))
plot(rad1.tree,show.tip=TRUE,edge.width=1,cex=0.85)
title("NJ Tree + bootstrap values")
axisPhylo()
nodelabels(nj.boot,cex=0.6,bg=1,col='white')

###upgma
y <- as.vector(as.dist(cophenetic(as.phylo(hclust(rad1.d,method='average')))))
plot(x, y, xlab="original pairwise distances", ylab="pairwise distances on the tree", main="Is NJ appropriate?", pch=20, col=transp("black",.1), cex=3)
abline(lm(y~x), col="red")


###Linking to traits
dem <- read.xls('/Users/Aeolus/Dropbox/WarmAntDimensions/Phytotron\ 2013/Phytotron\ colonies\ 2013\ Traits.xlsx',sheet=1) ###demography
dem <- dem[1:46,]
### dev <- read.xls('/Users/Aeolus/Dropbox/WarmAntDimensions/Phytotron\ 2013/Phytotron\ colonies\ 2013\ Traits.xlsx',sheet=2) ###developmental traits
### mor <- read.xls('/Users/Aeolus/Dropbox/WarmAntDimensions/Phytotron\ 2013/Phytotron\ colonies\ 2013\ Traits.xlsx',sheet=3) ###mortality
dem[,5] <- dem[,5] * -1
plot(dem[,5:4],pch='',xlim=range(dem[,5])+c(-5,5))
text(dem[,5:4],labels=dem$Colony.ID,cex=0.75)
