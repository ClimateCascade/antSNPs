###Warm Ant Dimensions SNP data processing functions

waSampleIDs <- function(x='sequence labels'){
  rad.labs <- toupper(x)
  rad.labs <- sub('00','',sub('_TRIMMED_FILTERED','',rad.labs))
  rad.labs <- sub('IJANSQ','IJAMS',rad.labs);rad.labs <- sub('IJANS','IJAMS',rad.labs);rad.labs <- sub('DSDF','DSF',rad.labs)
  rad.labs <- sub('-','',rad.labs)
  return(rad.labs)
}

waQC <- function(seqs,quality.threshold = 0.8){
  ac <- apply(do.call(rbind,lapply(seqs,table)),1,function(x) x/sum(x))
  seq.rm <- colnames(ac)[apply(ac[(rownames(ac) %in% c('a','t','c','g')) == FALSE,],2,sum) > quality.threshold]
  seqs <- seqs[names(seqs) %in% seq.rm == FALSE]
  return(seqs)
}


