###warm ant population genetic analyses

###Only analyze identified specimens
### rad1 <- read.dna('../data/UVM_ant_ids.fasta',format='fasta') ###only samples with species ids
### rad1 <- read.dna('../data/UVM_ant_ids.fasta',format='fasta') ###only samples with species ids
rad1 <- read.dna('../data/UVM_ant_sequences.fasta',format='fasta') ###all sequences
info <- info <- read.xls('../data/RADseq_mastersheet_2014.xlsx')

site.labs <- toupper(paste(as.character(info$Site),info$Collection_no,sep=''));site.labs <- sub('BRM /BRF','BRF',site.labs);site.labs <- sub('IJAMSQL','IJAMS2',site.labs);site.labs <- sub(" \\(SECOND SAMPLE\\)","42",site.labs)
rad.labs <- waSampleIDs(x=attributes(rad1)$dimnames[[1]])
rad.labs[rad.labs%in%phyt.labs] <- site.labs[match(rad.labs,phyt.labs,nomatch=0)]
info.rad <- info[match(rad.labs,site.labs),]
rad.labs <- paste(rad.labs,info.rad[,4],info.rad[,5])

rad1.d <- dist.dna(rad1,model='')
rad1.m <- as.matrix(rad1.d)
attr(rad1.d,'Labels') <- rad1.labs <- rad.labs
rownames(rad1.m) <- colnames(rad1.m) <- rad1.labs
heatmap(rad1.m)
plot(hclust(rad1.d))

##    model: a character string specifying the evolutionary model to be
##           used; must be one of ‘"raw"’, ‘"N"’, ‘"TS"’, ‘"TV"’,‘"JC69"’, ‘"K80"’ (the default), ‘"F81"’, ‘"K81"’, ‘"F84"’,‘"BH87"’, ‘"T92"’, ‘"TN93"’, ‘"GG95"’, ‘"logdet"’,‘"paralin"’, ‘"indel"’, or ‘"indelblock"’.
###
### Samples included in Sara's phylogeny from January
### c('26E','15C','22C','16A','13A','15B','24B','17C','07-B','05-D','13C','12A','02-C','04-B','03A','11D','11A','11B','11C')
### c('MB-6','DSF-8','SEB-9','BRF-4','HSP-6','DSF-11','EW-4','BARD-3','BRP-9','GSMNP-5','HSP-9','NOCK-6','HW-7','UNF-9','FMU-4','WP-6','WP-9','WP-11','WP-3')

###Linking to traits
dem <- read.xls('/Users/Aeolus/Dropbox/WarmAntDimensions/Phytotron\ 2013/Phytotron\ colonies\ 2013\ Traits.xlsx',sheet=1) ###demography
dem <- dem[1:46,]
### dev <- read.xls('/Users/Aeolus/Dropbox/WarmAntDimensions/Phytotron\ 2013/Phytotron\ colonies\ 2013\ Traits.xlsx',sheet=2) ###developmental traits
### mor <- read.xls('/Users/Aeolus/Dropbox/WarmAntDimensions/Phytotron\ 2013/Phytotron\ colonies\ 2013\ Traits.xlsx',sheet=3) ###mortality
dem[,5] <- dem[,5] * -1
plot(dem[,5:4],pch='',xlim=range(dem[,5])+c(-5,5))
text(dem[,5:4],labels=dem$Colony.ID,cex=0.75)
