#! /bin/bash
#PBS -k o
#PBS -l nodes=1:ppn=1,walltime=30:00
#PBS -M scahan@uvm.edu
#PBS -m abe
#PBS -N fastx_trim
#PBS -j oe

FASTX=/N/soft/mason/galaxy-apps/fastx_toolkit_0.0.13/fastq_quality_filter

cd /N/dc2/scratch/scahan/ddRAD1_fastq
$FASTX -Q33 -q 10 -p 100  -i 03A_trimmed.fq -o 03A_filtered.fq

