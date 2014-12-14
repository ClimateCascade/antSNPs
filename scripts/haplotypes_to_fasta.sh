#! /bin/bash
#PBS -k o
#PBS -l nodes=1:ppn=1,vmem=10gb,walltime=6:00:00
#PBS -M scahan@uvm.edu
#PBS -m abe
#PBS -N haplotypes_to_fasta
#PBS -j oe

  
cd /N/dc2/scratch/scahan/ddRAD1_fastq/ddRAD1_fastq/filtered/output2
INPUT=batch_2.haplotypes_3.tsv
VAR=batch_2.haplotypes_variable.tsv
DIP=batch_2.haplotypes_variable2.tsv
AMBIG=batch_2.haplotypes_variable2_single.tsv
grep -v "consensus" $INPUT > $VAR
grep -v "\w*/\w*/" $VAR > $DIP
python ~/scripts/haplotype_to_ambig_code.py $DIP
python ~/scripts/SNP_to_sequence_UVM.py $AMBIG
