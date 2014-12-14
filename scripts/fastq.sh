#! /bin/bash
#PBS -k o
#PBS -l nodes=1:ppn=1,walltime=4:00:00
#PBS -M scahan@uvm.edu
#PBS -m abe
#PBS -N fastq_filter
#PBS -j oe

FASTQ=/N/soft/mason/galaxy-apps/fastx_toolkit_0.0.13/fastq_quality_filter

cd /N/dc2/scratch/scahan/ddRAD2
mkdir filtered
cd trimmed
for X in *.fq;do $FASTQ -Q33 -q 10 -p 100  -i $X -o ${X%.*}_filtered.fq;mv *_filtered.fq ../filtered; done

