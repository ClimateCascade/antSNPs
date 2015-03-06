###warm ant population genetic analyses
###library('RADami')
###library('phytools')
library('GenABEL')
library('gstudio')
library('popgraph')
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
rad1 <- read.dna('../data/uvm_qc_0.4.fasta')
ac <- apply(as.character(rad1),1,table);ac <- round(ac/sum(ac[,1]),7);ac <- ac[c(1,2,3,9,4,5,6,7,8,10,11),]

hom <- apply(ac[1:4,],2,sum)
het <- apply(ac[-c(1:4,7),],2,sum)


pairs(t(ac))

###

par(mfrow=c(7,10),mai=rep(0,4))
for (i in 1:70){
  lab <- paste(sub('_t','',substr(attributes(rad1)$dimnames[[1]],3,7)[i]),round(ac[i],2))
  plot(as.numeric(grepl('n',as.character(rad1[i,])[1,])),type='l',lwd=0.02,xaxt='none',yaxt='none')
  text(I(length(as.character(rad1[i,])[1,])/2),0.5,label=lab,cex=1.5)
}

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

### setup tree
rad1.tree <- nj(rad1.d)
rad1.tree <- ladderize(rad1.tree,right=FALSE)
plot(rad1.tree)
root.n <- sort(unlist(sapply(c('HW6'),grep,x=rad1.labs)))
rad1.tree <- root(rad1.tree,outgroup=as.numeric(root.n))

### plot tree
plot(rad1.tree)

## Assess tree validity
x <- as.vector(rad1.d)
###nj
y <- as.vector(as.dist(cophenetic(rad1.tree)))
plot(x, y, xlab="original pairwise distances", ylab="pairwise distances on the tree", main="Is NJ appropriate?", pch=20, col=transp("black",.1), cex=3)
abline(lm(y~x), col="red")
if(any(ls() == 'nj.boot')){}else{nj.boot <- boot.phylo(rad1.tree,rad1,function(e) root(nj(dist.dna(e,model='TN93')),root.n))}

pdf('../results/njt_rooted_booted.pdf',width=11,height=9)
plot(rad1.tree,show.tip=TRUE,edge.width=1,cex=0.75)
title("NJ Tree + bootstrap values")
axisPhylo()
nodelabels(nj.boot,cex=0.6,bg=1,col='white')
dev.off()

###Linking to traits
dem <- read.xls('/Users/Aeolus/Dropbox/WarmAntDimensions/Phytotron\ 2013/Phytotron\ colonies\ 2013\ Traits.xlsx',sheet=1) ###demography
dem <- dem[1:46,]
### dev <- read.xls('/Users/Aeolus/Dropbox/WarmAntDimensions/Phytotron\ 2013/Phytotron\ colonies\ 2013\ Traits.xlsx',sheet=2) ###developmental traits
### mor <- read.xls('/Users/Aeolus/Dropbox/WarmAntDimensions/Phytotron\ 2013/Phytotron\ colonies\ 2013\ Traits.xlsx',sheet=3) ###mortality
dem[,5] <- dem[,5] * -1
plot(dem[,5:4],pch='',xlim=range(dem[,5])+c(-5,5))
text(dem[,5:4],labels=dem$Colony.ID,cex=0.75)

###Population Graphs
data(arapat)
file <- system.file("extdata", "data_snp.csv", package = "gstudio")
snp <- read_population(file, type = "snp", locus.columns = 4:7)

rad.l <- as.character(rad1)


data <- to_mv(arapat)
pops <- arapat$Population
graph <- popgraph(x = data, groups = pops)
plot(graph)
