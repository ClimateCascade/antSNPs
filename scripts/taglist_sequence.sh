#! /bin/bash
#PBS -k o
#PBS -l nodes=1:ppn=1,vmem=10gb,walltime=6:00:00
#PBS -M scahan@uvm.edu
#PBS -m abe
#PBS -N taglist_to_fasta
#PBS -j oe


cd /N/dc2/scratch/scahan/ddRAD1_fastq/ddRAD1_fastq/filtered/reference_samples
for X in `cat taglist.txt `; do grep "^$X	" batch_1.catalog.sequences.tsv >> taglist_sequences.tsv; done
awk '{print ">"$1"\n"$2}' taglist_sequences.tsv > taglist_sequences.fa

