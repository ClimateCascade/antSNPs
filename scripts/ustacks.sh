#! /bin/bash
#PBS -k o
#PBS -l nodes=2:ppn=8,vmem=10gb,walltime=12:00:00
#PBS -M scahan@uvm.edu
#PBS -m abe
#PBS -N ustacks
#PBS -j oe

module load stacks
cd /N/dc2/scratch/scahan/ddRAD1_fastq/ddRAD1_fastq/filtered
ustacks -t fastq -f 0011B_trimmed_filtered.fq -d -r -o ./ustacks_output -i 6 -m 2 -M 3 -p 8
ustacks -t fastq -f 0011D_trimmed_filtered.fq -d -r -o ./ustacks_output -i 7 -m 2 -M 3 -p 8
ustacks -t fastq -f 0012A_trimmed_filtered.fq -d -r -o ./ustacks_output -i 8 -m 2 -M 3 -p 8
ustacks -t fastq -f 0013A_trimmed_filtered.fq -d -r -o ./ustacks_output -i 9 -m 2 -M 3 -p 8
ustacks -t fastq -f 0015B_trimmed_filtered.fq -d -r -o ./ustacks_output -i 10 -m 2 -M 3 -p 8
ustacks -t fastq -f 0015C_trimmed_filtered.fq -d -r -o ./ustacks_output -i 11 -m 2 -M 3 -p 8
ustacks -t fastq -f 0017C_trimmed_filtered.fq -d -r -o ./ustacks_output -i 12 -m 2 -M 3 -p 8
 
