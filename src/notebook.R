###Ant snps

###22Feb2015

1. start analyzing Fasta = UVM_ant_sequences.fas 
2. start testing waRADpipe.sh
3. create a database

###18Jan2015
#using pyrad

#1 - create a new directory and copy the *.fastq.gz and *.barcodes files
#2 - create a params.txt file
#3 - edit the params.txt file
#4 - run ~/.../pyRAD -p params.txt (~/.../pyRAD -p params.txt -s 234567, will run 2:7)
#5 - post analyses
###http://nbviewer.ipython.org/gist/dereneaton/1f661bfb205b644086cc/tutorial_RAD_3.0.ipynb


##Processing SNP data from RAD-Seq
#http://nbviewer.ipython.org/gist/dereneaton/af9548ea0e94bff99aa0/pyRAD_v.3.0.ipynb#4.-Running-pyRAD
#Make sure to look at the figure for ddRAD
See the waRadpipe.sh


###17dec2014
source('funcs.R')
rsm.1 <- read.xls('/Users/Aeolus/Dropbox/warmantdimensions/Genomics/RADseq_mastersheet_2014.xlsx',sheet=1)
rsm.2 <- read.xls('/Users/Aeolus/Dropbox/warmantdimensions/Genomics/RADseq_mastersheet_2014.xlsx',sheet=2)
pvch <- read.xls('/Users/Aeolus/Library/Containers/com.apple.mail/Data/Library/Mail\ Downloads/63A54484-980A-47B8-9938-B48B98126534/phytotron\ vouchers.xlsx',sheet=1) ###phytotron vouchers
rsm <- rbind(rsm.1[,1:10],rsm.2[,1:10])
rsm.sites <- as.character(apply(rsm[,2:3],1,function(x) paste(x,collapse='')))
rsm.sites <- sub(' ','',rsm.sites)
rsm.sites <- sub('-','',rsm.sites)
rsm.sites <- sub('_','',rsm.sites)
rsm.sites <- toupper(rsm.sites)
pvch$Colony.ID <- sub('-','',as.character(pvch$Colony.ID))
pvch$Colony.ID <- sub(' ','',pvch$Colony.ID)
pvch$Colony.ID <- sub('_','',pvch$Colony.ID)
pvch$Colony.ID <- toupper(pvch$Colony.ID)
pvch$Colony.ID[pvch$Colony.ID%in%rsm.sites==FALSE]

pvch[(pvch$Colony.ID%in%rsm.sites)==FALSE&pvch[,4]=="voucherNCSU",]
pvch.fuzzy <- sapply(pvch$Colony.ID,function(x,y) y[agrep(x,y)],y=rsm.sites)
dim(do.call(rbind,pvch.fuzzy))
rsm.sites[rsm.sites%in%pvch$Colony.ID==FALSE]

pi

###16dec2014
##looking for under-sampled areas

rsm.1 <- read.xls('/Users/Aeolus/Dropbox/warmantdimensions/Genomics/RADseq_mastersheet_2014.xlsx',sheet=1)
rsm.2 <- read.xls('/Users/Aeolus/Dropbox/warmantdimensions/Genomics/RADseq_mastersheet_2014.xlsx',sheet=2)
rsm <- rbind(rsm.1[,1:10],rsm.2[,1:10])
phy <- read.csv('/Users/Aeolus/Dropbox/WarmAntDimensions/Phytotron\ 2013/full\ phytotron\ data.csv')
phy <- phy[as.character(phy$Site)!="",]
rsm.sites <- as.character(apply(rsm[,2:3],1,function(x) paste(x,collapse='')))
rsm.sites <- sub(' ','',rsm.sites)
rsm.sites <- sub('-','',rsm.sites)
rsm.sites <- sub('_','',rsm.sites)
rsm.sites <- toupper(rsm.sites)
phy.sites <- as.character(unique(phy$Site))
phy.sites <- sub(' ','',phy.sites)
phy.sites <- toupper(phy.sites)
###other sampling sites
oss <- read.xls('/Users/Aeolus/Dropbox/WarmAntDimensions/Sampling\ protocols\ and\ data\ sheets/Geographic\ information/PhytotronColonies_2013.xlsx',sheet=1)
oss.sites <- as.character(oss[,1])
oss.sites <- sub(' ','',oss.sites);oss.sites <- sub(' ','',oss.sites);oss.sites <- sub(' ','',oss.sites)
oss.sites <- sub('-','',oss.sites)
oss.sites <- sub('_','',oss.sites)
oss.sites <- toupper(oss.sites)
oss.sites <- sub('LDCMAGSPRINGS','MAGSPR',oss.sites)
oss.sites[oss.sites%in%(unique(c(rsm.sites,phy.sites)))]
oss.sites[oss.sites%in%(unique(c(rsm.sites,phy.sites)))==FALSE]
oss.missing <- oss.sites[is.na(match(oss.sites,c(rsm.sites,phy.sites)))]
oss.fuzz <- sapply(oss.missing,function(x,y) y[agrep(x,y)],y=c(rsm.sites,phy.sites))
oss.sites <- sapply(oss.sites,function(x) paste(strsplit(x,split='')[[1]][strsplit(x,split='')[[1]]%in%LETTERS],collapse=''))

###
phy.missing <- phy.sites[is.na(match(phy.sites,rsm.sites))]
all(sort(phy.missing)==sort(phy.sites[phy.sites%in%rsm.sites==FALSE]))
phy.fuzz <- sapply(phy.missing,function(x,y) y[agrep(x,y)],y=rsm.sites)

###Sites in the phytotron, missing from the SNP sampling
###MAGSPR4 BRM8 BRM4 APB8 HSP7 DSF12 BEAR5 BEAR6 HF001 SEB8 MM1 KBH1 KBH4B MB2 MB1    

###Geographic coverage
oss.loc <- oss
oss.loc[,1] <- oss.sites
oss.loc <- oss.loc[duplicated(oss.sites)==FALSE,1:5]
elev <- apply(oss.loc[,3:4],1,function(x) get.elev(-x[2],x[1]))
plot(oss.loc$Elevation..m.[is.na(oss.loc$Elevation..m.)==FALSE],elev[is.na(oss.loc$Elevation..m.)==FALSE])
oss.res <- residuals(lm(oss.loc$Elevation..m.[is.na(oss.loc$Elevation..m.)==FALSE]~elev[is.na(oss.loc$Elevation..m.)==FALSE]))
plot(oss.loc$Elevation..m.[is.na(oss.loc$Elevation..m.)==FALSE]~oss.res)
data.frame(oss.loc[is.na(oss.loc$Elevation..m.)==FALSE,][abs(oss.res)>100,]
           ,get.elev=elev[is.na(oss.loc$Elevation..m.)==FALSE][abs(oss.res)>100])
###look at spatial and elevation coverage by rms
rsm.loc <- sapply(rsm.sites,function(x) paste(strsplit(x,split='')[[1]][strsplit(x,split='')[[1]]%in%LETTERS],collapse=''))
oss.covered <- oss.loc[match(oss.loc[,1],rsm.loc),]
oss.missing <- oss.loc;oss.loc[,5] <- elev
oss.missing <- oss.loc[is.na(match(oss.loc[,1],rsm.loc)),]
oss.col <- as.numeric(is.na(match(oss.loc[,1],rsm.loc)))+1
oss.cex <- (elev-mean(elev)) / sd(elev);oss.cex <- oss.cex + abs(min(oss.cex)) + 1

plot(-oss.loc$Longitude,oss.loc$Latitude,xlab='Longitude',ylab='Latitude',
     col=oss.col,pch=19,cex=oss.cex)
legend('topleft',legend=c('RadSeq List','Not'),pch=19,col=c(1,2))
plot(1:length(elev)~elev,pch=19,col=oss.col,cex=oss.cex,yaxt='n',ylab='Dataset Ordering',xlab='Elevation (m)')

out <- oss.missing[order(oss.missing$Latitude,-oss.missing$Elevation..m.),]
out <- data.frame(out,1:nrow(out))
colnames(out) <- c('Site','Name','Latitude','Longitude','Elevation','Priority')
## x.refs <- c('MAGSPR4','BRM8','BRM4','APB8','HSP7','DSF12','BEAR5','BEAR6','HF001','SEB8','MM1','KBH1','KBH4B','MB2','MB1')
## x.refs <- sapply(x.refs,function(x) paste(strsplit(x,split='')[[1]][strsplit(x,split='')[[1]]%in%LETTERS],collapse=''))
## out <- out[out[,1]%in%x.refs==FALSE,]
write.csv(out,file='~/Dropbox/WarmAntDimensions/Genomics/MKLau_AddMe.csv',row.names=FALSE)

LDCHW,LDCSESQUI,LDCFMU,LDCGSMNP,LDCDW,LDCIJAMS,FR,OLDRC,LDCWV,BRM,KBH      

###Get mean annual temperature
###getData('worldclim', var='tmin', res=0.5, lon=5, lat=45)

pi
pi

###13dec2014


##http://chibba.pgml.uga.edu/snphylo/


## Code	Meaning	Etymology			Complement	Opposite
## A	A	Adenosine			T		B
## T/U	T	Thymidine/Uridine		A		V
## G	G	Guanine				C		H
## C	C	Cytidine			G		D
## K	G or T	Keto				M		M
## M	A or C	Amino				K		K
## R	A or G	Purine				Y		Y
## Y	C or T	Pyrimidine			R		R
## S	C or G	Strong				S		W
## W	A or T	Weak				W		S
## B	C or G or T				not A (B comes after A)	V	A
## V	A or C or G				not T/U (V comes after U)	B	T/U
## H	A or C or T				not G (H comes after G)		D	G
## D	A or G or T				not C (D comes after C)		H	C
## X/N	G or A or T or C			any N .
## .	not G or A or T or C			    . N
## -	gap of indeterminate length		    

library(phyclust)
library(ape)
library(ctv)
library(picante)
###library(phangorn)

###Building a tree
###x <- read.fasta('/N/dc2/scratch/scahan/sandbox/UVM_ant_sequences.fas')
## x <- read.dna('/N/dc2/scratch/scahan/sandbox/UVM_ant_sequences.fas',format='fasta')

owd <- getwd()
setwd('~/Dropbox/WarmAntDimensions/Phytotron 2013')
x <- readLines('Phytotron_ant_sequences_12-14-14_eol.fas')
setwd(owd)
ids <- x[(1:length(x))[c(T,F)]]
x <- do.call(rbind,lapply(x[(1:length(x))[c(F,T)]],function(x) strsplit(x,split='')[[1]]))
rownames(x) <- ids
x <- tolower(x)
input <- as.DNAbin(x)
gen.dm <- dm <- dist.dna(input,model='JC69')
x.nj <- nj(dm)
plot(x.nj)

##Get sample data
library(gdata)
trs <- read.xls('/Users/Aeolus/Dropbox/WarmAntDimensions/Phytotron\ 2013/Phytotron\ colonies\ 2013\ Transcriptome.xlsx',sheet=1)
trs.id <- sapply(as.character(trs[,1]),function(x) paste(strsplit(x,split='-')[[1]][2:3],collapse=''))
###
pid <- substr(sapply(ids,function(x) strsplit(x,split='_')[[1]][1]),4,7)
pid <- sub('-','',pid)
###
seq.info <- trs[na.omit(match(pid,trs.id)),]
###
library(geosphere)
###NOTE! Adding in the same lat and lon coordinates from brp2 for brp9
seq.info[6,c(17,18)] <- c(35.9264,81.95381249)
geo.dm <- as.dist(distm(seq.info[,c(18,17)]))

###testing genetic and geographic distance
library(vegan)
mantel(gen.dm,geo.dm)





###
library(phytools)
ref <- c("U15717", "U15718", "U15719", "U15720",
         "U15721", "U15722", "U15723", "U15724") 
gbs <- read.GenBank(ref,species.names=TRUE)
x <- fastBM(tree)
tree <- rbdtree(1,0,Tmax=4)
phylosig(tree,
