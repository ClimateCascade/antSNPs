#! /bin/bash
#PBS -k o
#PBS -l nodes=1:ppn=1,walltime=4:00:00
#PBS -M scahan@uvm.edu
#PBS -m abe
#PBS -N SNP-To-sequence
#PBS -j oe

HAPLOTYPE=~/scripts/haplotype_to_ambig_code.py
SEQUENCE=~/scripts/SNP_to_sequence_UVM.py

cd /N/dc2/scratch/scahan/sandbox

python $HAPLOTYPE batch_1.haplotypes_variable_all.tsv
python $SEQUENCE batch_1.haplotypes_variable_all_single.tsv

