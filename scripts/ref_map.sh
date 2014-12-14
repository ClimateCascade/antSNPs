#! /bin/bash
#PBS -k o
#PBS -l nodes=2:ppn=8,vmem=10gb,walltime=6:00:00
#PBS -M scahan@uvm.edu
#PBS -m abe
#PBS -N ref_map
#PBS -j oe


cd /N/dc2/scratch/scahan/ddRAD1_fastq/ddRAD1_fastq/filtered/sam_files
module load stacks
mkdir output
ref_map.pl -s 0003A_trimmed_filtered.sam \
-s 0011A_trimmed_filtered.sam \
-s 0011B_trimmed_filtered.sam \
-s 0011D_trimmed_filtered.sam \
-s 0012A_trimmed_filtered.sam \
-s 0013A_trimmed_filtered.sam \
-s 0015B_trimmed_filtered.sam \
-s 0015C_trimmed_filtered.sam \
-s 0016A_trimmed_filtered.sam \
-s 0017C_trimmed_filtered.sam \
-s 0022C_trimmed_filtered.sam \
-s 0026E_trimmed_filtered.sam \
-s 00APB11_trimmed_filtered.sam \
-s 00APB13_trimmed_filtered.sam \
-s 00APB1_trimmed_filtered.sam \
-s 00APB5_trimmed_filtered.sam \
-s 00APB7_trimmed_filtered.sam \
-s 00APB9_trimmed_filtered.sam \
-s 00Bard11_trimmed_filtered.sam \
-s 00Bard12_trimmed_filtered.sam \
-s 00Bard1_trimmed_filtered.sam \
-s 00Bard4_trimmed_filtered.sam \
-s 00Bard5_trimmed_filtered.sam \
-s 00Bard6_trimmed_filtered.sam \
-s 00Bard7_trimmed_filtered.sam \
-s 00BRF10_trimmed_filtered.sam \
-s 00BRF12_trimmed_filtered.sam \
-s 00BRF1_trimmed_filtered.sam \
-s 00BRF2_trimmed_filtered.sam \
-s 00BRF3_trimmed_filtered.sam \
-s 00Brf4_trimmed_filtered.sam \
-s 00BRF5_trimmed_filtered.sam \
-s 00BRF6_trimmed_filtered.sam \
-s 00BRF7_trimmed_filtered.sam \
-s 00BRF9_trimmed_filtered.sam \
-s 00DSDF3_trimmed_filtered.sam \
-s 00DSF10_trimmed_filtered.sam \
-s 00DSF1_trimmed_filtered.sam \
-s 00DSF2_trimmed_filtered.sam \
-s 00DSF7_trimmed_filtered.sam \
-s 00DSF9_trimmed_filtered.sam \
-s 00HSP10_trimmed_filtered.sam \
-s 00HSP11_trimmed_filtered.sam \
-s 00HSP3_trimmed_filtered.sam \
-s 00HSP5_trimmed_filtered.sam \
-s 00Ijams4_trimmed_filtered.sam \
-o ./output -n 3 -m 1 -T 8 -S -b 2 

mv output ../output2
