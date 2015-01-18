#! /bin/bash

###To demultiplex and filter sequencer lane:


gunzip ddRAD1.fq.gz

# use sabre.sh to demultiplex.  Note - need to make barcode file in correct format:
# FOR ALL SCRIPTS, YOU NEED TO edit script to point to the right directory, file, etc.

# Trim off barcodes with fastx.sh
# Filter out reads with bad data with fastq.sh
# The filtered reads are the ones you will use for downstream applications.

# Getting SNPs with STACKS:
# ustacks.sh
# cstacks.sh
# sstacks.sh

 
# after both of these, run genotypes.sh to get the batch haplotypes file.
# CRITICAL: you need to edit this file (I use nano) to eliminate the space between "Catalog" and "ID" on the first line - this is a stupid thing that Stacks does that messes up all the column operations in bash.  

# Use haplotypes_to_sequence.sh to convert this into a fasta file
cd /N/dc2/scratch/scahan/ddRAD1_fastq/ddRAD1_fastq/filtered/output
INPUT=batch_2.haplotypes_3.tsv
VAR=batch_2.haplotypes_variable.tsv
AMBIG=batch_2.haplotypes_single.tsv
grep -v	"consensus" $INPUT > $VAR                
python haplotypes_to_ambig_code.py $VAR  
python SNP_to_sequence_UVM.py $AMBIG

# Note that the fact that monomorphic loci are removed means the number and identities of the loci used will be different with each set of samples.  Right now it does not filter by number of SNPs in the tag - Andrew has a script to do this but I did not use it here.

Aphaenogaster reference samples:
03A - SC, rudis or carolinensis
11A - PA, rudis
16A - NY, picea
22C - ME, picea
26E - VT, picea

61518 tags present in all five reference samples (3 picea from north, one rudis from PA and one unknown from SC).
52728 of these polymorphic across the reference samples.

To make reference fasta file of tags:
1) cut -f 3,10 batch_1.catalog.tags.tsv > batch_1.catalog.sequences.tsv  #extracts catalog ID and sequence for all tags in catalog
2) cut -f 1 batch_1.haplotypes_all.tsv > taglist.txt #extracts list of desired tags from subset that had a genotype in all five reference samples

3) Use taglist_sequences.sh to do these two tasks:
for X in `cat taglist.txt `; do grep "^$X	" batch_1.catalog.sequences.tsv >> taglist_sequences.tsv; done #pulls out the sequence lines for only those tags that are in all five reference samples
awk '{print ">"$1"\n"$2}' taglist_sequences.tsv > taglist_sequences.fa #converts tab file into fasta format

4) Use bowtie-build.sh to build a new index, move ebwt files into the master indexes directory in my home directory.

To map samples to this reference set:
Use bowtie.sh to map to the index.  The script will copy the indexes directory into the directory with the samples so bowtie can find it.

