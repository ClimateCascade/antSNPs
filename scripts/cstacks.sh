#! /bin/bash
#PBS -k o
#PBS -l nodes=2:ppn=8,vmem=10gb,walltime=6:00:00
#PBS -M scahan@uvm.edu
#PBS -m abe
#PBS -N cstacks
#PBS -j oe

module load stacks
cd /N/dc2/scratch/scahan/ddRAD1_fastq/ddRAD1_fastq/filtered/reference_samples
cstacks -b 1 -s 0003A_trimmed_filtered -s 0011A_trimmed_filtered -s 0016A_trimmed_filtered -s 0022C_trimmed_filtered -s 0026E_trimmed_filtered -o ./ -n 3 -p 8
 
