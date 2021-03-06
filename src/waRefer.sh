#! /bin/bash

# Aphaenogaster reference samples:
# 03A - SC, rudis or carolinensis
# 11A - PA, rudis
# 16A - NY, picea
# 22C - ME, picea
# 26E - VT, picea

# 61518 tags present in all five reference samples (3 picea from north, one rudis from PA and one unknown from SC).
# 52728 of these polymorphic across the reference samples.

To make reference fasta file of tags:
# 1) cut -f 3,10 batch_1.catalog.tags.tsv > batch_1.catalog.sequences.tsv  #extracts catalog ID and sequence for all tags in catalog
cut -f 3,10 batch_1.catalog.tags.tsv > batch_1.catalog.sequences.tsv
# 2) cut -f 1 batch_1.haplotypes_all.tsv > taglist.txt #extracts list of desired tags from subset that had a genotype in all five reference samples
cut -f 1 batch_1.haplotypes_all.tsv > taglist.txt 
# 3) Use taglist_sequences.sh to do these two tasks:
for X in `cat taglist.txt `; do grep "^$X	" batch_1.catalog.sequences.tsv >> taglist_sequences.tsv; done #pulls out the sequence lines for only those tags that are in all five reference samples
awk '{print ">"$1"\n"$2}' taglist_sequences.tsv > taglist_sequences.fa #converts tab file into fasta format
# 4) Use bowtie-build.sh to build a new index, move ebwt files into the master indexes directory in my home directory.
bowtie-build.sh

# To map samples to this reference set:
# Use bowtie.sh to map to the index.  The script will copy the indexes directory into the directory with the samples so bowtie can find it.

