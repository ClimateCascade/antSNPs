#setup the barcodes file

#SNP analysis with pyRAD
#1. installing pyRAD
git clone https://github.com/dereneaton/pyrad.git
mv pyrad pyrad_v.3.0
ln -s pyrad_v.3.0/pyRAD pyRAD
#also make sure that these are in a directory that is in your path

#2. setting up the params file

#3. run pyrad
pyRAD -p params.txt -s 1 #this only demultiplexes
pyRAD -p params.txt -s 234567 #this runs everything (see below)

pyRAD -h #for help

#Seven tasks conducted by pyRAD
#1.Demultiplex
#Step 1: de-multiplexing. This step uses information from the barcodes file to separate sequences from your raw fastq files into a separate file for each sample.
#inputs 1. fastq files and 2. barcode file


#2. filtering
#Step 2: filtering. This step uses the Phred quality score recorded in the FASTQ data files to filter low quality base calls. Sites with a score below a set value are changed into “N”s, and reads with more than the number of allowed “N”s are discarded. Files are written to the “edits/” directory with the suffix “.edit”. It also implements a number of optional filters.

#3. within-sample clustering
#Step 3: within-sample clustering. This step first dereplicates the filtered sequences from step 2, recording the number of times each unique read is observed. These are then clustered using VSEARCH, recording if they match within a set sequence similarity. Sequences that clustered together are then aligned and written to a new file in the “clust.xx/” directory with the ending “.clustS.gz”.

#4. error-rate and heterozygosity estimation
#Step 4: error-rate and heterozygosity estimates. This step uses the ML equation of Lynch (20XX) to jointly estimate error rate and heterozygosity from the base counts in each site across all clusters. Results are written to the Pi_estimate.txt file in the stats/ directory.

#5. consensus sequences
#Step 5: create consensus sequences. Using the mean error rate and heterozygosity estimated in step 4, this step creates consensus sequences for each cluster. Those which have less than the minimum coverage, more than the maximum number of undetermined sites, or more than the maximum number of heterozygous sites, or more than the allowed number of alleles, are discarded. In diploid data if two alleles are present the phase of heterozygous sites are retained in the consensus sequences.

#6. consensus sequencing clustering
#Step 6. Consensus sequences are clustered across samples using the same settings as in step 3. If heterozygous, one allele is randomly sampled and used in this step, although both alleles are retained in the final data set.

#7. alignment
#Step 7. Alignment, filtering for paralogs, and output of human readable fasta-like file (.loci). A large number of alternative formats are also available (see output formats). Final assembly statistics are written to the stats/ directory in the .stats file. This step is relatively fast, and can be repeated with different values for options 12,13,14,16,17,etc. to create different data sets that are optimized in coverage for different samples.