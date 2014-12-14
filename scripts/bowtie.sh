#! /bin/bash
#PBS -k o
#PBS -l nodes=2:ppn=8,vmem=10gb,walltime=12:00:00
#PBS -M scahan@uvm.edu
#PBS -m abe
#PBS -N bowtie
#PBS -j oe

module load bowtie
cd /N/dc2/scratch/scahan/ddRAD2/filtered
cp -r ~/indexes .
mkdir mapped_files sam_files
for X in *.fq; do bowtie AphaenogasterRAD $X -S ${X%.*}.sam; mv $X mapped_files; mv *.sam sam_files; done
