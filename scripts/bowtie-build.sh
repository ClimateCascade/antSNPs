#! /bin/bash
#PBS -k o
#PBS -l nodes=2:ppn=8,vmem=10gb,walltime=12:00:00
#PBS -M scahan@uvm.edu
#PBS -m abe
#PBS -N bowtie
#PBS -j oe

module load bowtie
cd ~/Aphaenogaster
bowtie-build taglist_sequences.fa AphaenogasterRAD
