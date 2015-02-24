###warm ant population genetic analyses
###SNP data processing

## sample information 
library('gdata')
library('seqinr')
library('ape')
source('./waFunctions.R')
info <- read.xls('../data/RADseq_mastersheet_2014.xlsx')

## sequence information
rad1 <- read.dna('../data/UVM_ant_sequences.fasta',format='fasta')

## associate rad labels with master sheet labels
site.labs <- toupper(paste(as.character(info$Site),info$Collection_no,sep=''))
site.labs <- sub('BRM /BRF','BRF',site.labs);site.labs <- sub('IJAMSQL','IJAMS2',site.labs);site.labs <- sub(" \\(SECOND SAMPLE\\)","42",site.labs)
phyt.labs <- as.character(info$Phytotron_ID..Ap_GXL.)
phyt.labs <- sub('-','',phyt.labs)
seq
rad.labs <- toupper(attributes(rad1)$dimnames[[1]])
rad.labs <- sub('00','',sub('_TRIMMED_FILTERED','',rad.labs))
rad.labs <- sub('IJANSQ','IJAMS',rad.labs);rad.labs <- sub('IJANS','IJAMS',rad.labs);rad.labs <- sub('DSDF','DSF',rad.labs)
rad.labs <- sub('-','',rad.labs)
rad.labs[rad.labs%in%phyt.labs] <- site.labs[match(rad.labs,phyt.labs,nomatch=0)]

###Remove specimens that do not have species ID's
seqs <- read.fasta('../data/UVM_ant_sequences.fasta')
if (all(attributes(rad1)$dimnames[[1]]==names(seqs))){
  info.rad <- info[match(rad.labs,site.labs),]
  rad1.ids <- seqs[as.character(info.rad$Species) != '']
  print(length(rad1.ids));rad1.ids <- waQC(rad1.ids);print(length(rad1.ids))
  write.fasta(rad1.ids, names=names(rad1.ids), file.out='../data/UVM_ant_ids.fasta')
}else{warning('Sorted names do not match!')}
###
