#! /bin/bash
#PBS -k o
#PBS -l nodes=2:ppn=8,vmem=10gb,walltime=6:00:00
#PBS -M scahan@uvm.edu
#PBS -m abe
#PBS -N genotypes
#PBS -j oe

module load stacks
cd /N/dc2/scratch/scahan/ddRAD1_fastq/ddRAD1_fastq/filtered/output2
genotypes -b 2 -P ./ -r 3 -m 2 -t GEN 
