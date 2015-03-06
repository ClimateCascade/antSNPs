antSNPs
=======

##4mar2015

PHRED Quality Scores for Illimina 1.8+
L - Illumina 1.8+ Phred+33,  raw reads typically (0, 41)

LLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLL
!"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJ
0.2......................26...31.........41
012345678911111111112222222222333333333344
__________01234567890123456789012345678901
--------------++++++++++++++++++++++++++++

A phred score of 14 or higher is equivalent to a probability of
incorrect assignment of 0.05 or lower.

###Quality score mapping
```
library(txtplot)
q <- 0:41
p <- 10^(-q/10)
txtplot(p,q,pch='.')
```

##2mar2015

Based on a recently published paper (Sovic et al 2015, Mol Ecol
Resources), Stacks doesn't account for indel variation and pyRAD,
which does, is extremely slow. AftrRAD is similar to Stacks in compute
time and accounts for indel variation and seems to have a complete
pipeline from demultiplexing to output for analytical packages
(structure, genepop, etc.).  

Just finished the example for AftrRAD, and it worked quickly with the
example dataset on Aeolus (Macbook Air, duo-core). Outline of
workflow:

+ git clone AtfrRAD
+ install ACANA
+ install Mafft
+ R and appropriate packages should also be installed
+ create Data and Barcode directories
+ populate with data and barcode files
+ specify the data and barcode file arguments (this is essential as
- AtrRAD will be looking for them specifically)
+ specify other arguments appropriate to the dataset
+ perl AftRAD.pl minDepth-3 (to demultiplex)
+ perl genotype.pl 
+ perl filtersnps.pl
+ perl outputStructure.pl
+ perl outputGenepop.pl


##30jan2015
spatial ecology from Jose-Marie Fortin
http://www.cambridge.org/us/academic/subjects/life-sciences/ecology-and-conservation/spatial-analysis-guide-ecologists

Step 1: de-multiplexing. This step uses information from the barcodes file to separate sequences from your raw fastq files into a separate file for each sample. These are placed in a new directory within your working directory called “fastq/”. File names are not important for single end data. However, for paired-end reads it is necessary that the raw data file names follow a specific format: The first read files must contain "_R1_" in the name, and the second read files must be identical to the first read files but with "_R2_" in place of "_R1_". Here is an example pair of input files:

Step 2: filtering. This step uses the Phred quality score recorded in the FASTQ data files to filter low quality base calls. Sites with a score below a set value are changed into “N”s, and reads with more than the number of allowed “N”s are discarded. Files are written to the “edits/” directory with the suffix “.edit”. It also implements a number of optional filters.

Step 3: within-sample clustering. This step first dereplicates the filtered sequences from step 2, recording the number of times each unique read is observed. These are then clustered using VSEARCH, recording if they match within a set sequence similarity. Sequences that clustered together are then aligned and written to a new file in the “clust.xx/” directory with the ending “.clustS.gz”.

Step 4: error-rate and heterozygosity estimates. This step uses the ML equation of Lynch (20XX) to jointly estimate error rate and heterozygosity from the base counts in each site across all clusters. Results are written to the Pi_estimate.txt file in the stats/ directory.

Step 5: create consensus sequences. Using the mean error rate and heterozygosity estimated in step 4, this step creates consensus sequences for each cluster. Those which have less than the minimum coverage, more than the maximum number of undetermined sites, or more than the maximum number of heterozygous sites, or more than the allowed number of alleles, are discarded. In diploid data if two alleles are present the phase of heterozygous sites are retained in the consensus sequences.

Step 6. Consensus sequences are clustered across samples using the same settings as in step 3. If heterozygous, one allele is randomly sampled and used in this step, although both alleles are retained in the final data set.

Step 7. Alignment, filtering for paralogs, and output of human readable fasta-like file (.loci). A large number of alternative formats are also available (see output formats). Final assembly statistics are written to the stats/ directory in the .stats file. This step is relatively fast, and can be repeated with different values for options 12,13,14,16,17,etc. to create different data sets that are optimized in coverage for different samples.

##26jan2015
##max compute info 
https://129.79.213.150/data/bdkd.html#3

##Setting up github
- add an rsa from mason to github, so github recognizes mason
- change the .git/config file from https to ssh

###Manuscript Outline
Use Keller et al. 2010 as a model

aphaenogaster SNP processing

Tree building program?
Distance?

- ddrad1 ddrad2
- 50+ samples
- what is next? structure
- more sequencing at unc
- look at radseq master list (done. emailed sara the extra colonies)

- trait reconstruction

- tree building
- STRUCTURE (http://adegenet.r-forge.r-project.org/)
- mantels and other trait~geno+temp+(geo)
- sources of variation (pop, colony, individual)
- katie's c:n ratio
