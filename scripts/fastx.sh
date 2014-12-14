#! /bin/bash
#PBS -k o
#PBS -l nodes=1:ppn=1,walltime=4:00:00
#PBS -M scahan@uvm.edu
#PBS -m abe
#PBS -N fastx_trim
#PBS -j oe

FASTX=/N/soft/mason/galaxy-apps/fastx_toolkit_0.0.13/fastx_trimmer

cd /N/dc2/scratch/scahan/ddRAD2
mkdir trimmed original
mv ddRAD2.fq original/
for X in *.fq;do $FASTX -Q33 -f 5 -i $X -o ${X%.*}_trimmed.fq;mv $X original;mv *_trimmed.fq trimmed; done

