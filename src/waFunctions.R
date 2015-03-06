###Warm Ant Dimensions SNP data processing functions

arInfo <- function(ltp.path='./'){
    if (all(dir() != 'MasterReport.txt')){
        warning('Please move to the directory containing the aftrRAD Genotype.pl output.')
    }else{
        require('txtplot',quiet=TRUE)
                                        #aftrRAD run information
        report <- readLines(dir()[grep('Report_*.txt',dir())][1]);report <- sub('\t',' ',report[report != ""])
        print(report)
                                        #missing data proportions for quality assessment
        mdp <- read.delim('MissingDataProportions.txt',sep='\t',head=FALSE) 
        names <- sub('Individual','',mdp[,1])
        mdp <- mdp[,2]
        txtplot(mdp,ylim=c(0,1),xlab='Individual Index')
        print(names)
                                #SNP Locations for read length assessment
        LocationsToPlot <- scan(file=paste(ltp.path,"SNPLocationsToPlot.txt",sep=''))
        ltp <- table(LocationsToPlot)
        ltp <- ltp
        bins <- as.numeric(names(ltp))
        txtplot(bins,ltp,xlab='Read Position',ylab='Frequency')
    }
}


waSampleIDs <- function(x='sequence labels'){
  rad.labs <- toupper(x)
  rad.labs <- sub('00','',sub('_TRIMMED_FILTERED','',rad.labs))
  rad.labs <- sub('IJANSQ','IJAMS',rad.labs);rad.labs <- sub('IJANS','IJAMS',rad.labs);rad.labs <- sub('DSDF','DSF',rad.labs)
  rad.labs <- sub('-','',rad.labs)
  return(rad.labs)
}

waQC <- function(seqs,quality.threshold = 0.8,rm.count=FALSE){
  if (class(seqs) == 'DNAbin'){seqs <- waConvert(seqs);DNAbin.class <- TRUE}else{DNAbin.class <- FALSE}
  start.length <- length(seqs)
  ac <- apply(do.call(rbind,lapply(seqs,table)),1,function(x) x/sum(x))
  seqs <- seqs[names(seqs) %in% colnames(ac)[ac[rownames(ac) == 'n'] <= quality.threshold]]
  end.length <- length(seqs)
  if (DNAbin.class){seqs <- waConvert(seqs)}else{}
  if (rm.count){start.length-end.length}else{
    print(paste(I(start.length - end.length)," sequences removed",sep=''))
    return(seqs)
  }
}

waConvert <- function(x){
  if (class(x) == 'DNAbin'){
    x <- as.character(x)
    if (class(x) == 'matrix'){x.l <- split(x,row(x));names(x.l) <- rownames(x);x <- x.l}
  }else if (class(x) == 'list'){x <- as.DNAbin(x)}else{warning('Unknown data class.')}
  return(x)
}


