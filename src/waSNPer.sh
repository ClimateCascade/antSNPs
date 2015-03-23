#! /bin/bash

#Assume you are working locally (./) with an unzipped file 
lane=ddRAD2
rads_input=../../../test_aftrrad/test1/Data/ddRAD2  #unzipped file name
barcodes=ddRAD2.txt #formatted: GCATG	03A.fq
FASTX=/N/soft/mason/galaxy-apps/fastx_toolkit_0.0.13/fastx_trimmer
FASTQ=/N/soft/mason/galaxy-apps/fastx_toolkit_0.0.13/fastq_quality_filter


#################################
#demultiplex, trim, filter
#################################
mkdir $lane
sabre se -m 1 -f $rads_input -b $barcodes -u unknown.fq

cd $lane
mkdir trimmed original
mv $rads_input original
for X in *.fq;do $FASTX -Q33 -f 5 -i $X -o ${X%.*}_trimmed.fq;mv $X original;mv *_trimmed.fq trimmed; done

mkdir filtered
cd trimmed
for X in *.fq;do $FASTQ -Q33 -q 10 -p 100  -i $X -o ${X%.*}_filtered.fq;mv *_filtered.fq ../filtered; done
cd ..
#Filtered reads are used from here on

#################################
#Identifying SNPs
#################################

###this step could be made to create a database see: http://creskolab.uoregon.edu/stacks/comp/ref_map.php

module load stacks
mkdir output

###Build the following as a bash script that will then be called as sh sam_map.sh

ref_map.pl \
-s 0003A_trimmed_filtered.sam \
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

#getting genotypes
genotypes.sh

#
cd /N/dc2/scratch/scahan/ddRAD1_fastq/ddRAD1_fastq/filtered/output
INPUT=batch_2.haplotypes_3.tsv
VAR=batch_2.haplotypes_variable.tsv
AMBIG=batch_2.haplotypes_single.tsv
grep -v	"consensus" $INPUT > $VAR                

####Code from andrew that filters tags with too many SNPs or too much missing data
# Andrew's script to filter out tags with too many SNPs and tags with too much missing data is in the scripts directory in the shared scratch space: Filtering_taxaNUM_SNPnum.py. Looks like this should be used before the haplotype_to_ambig_code.py script, as it references haplotypes separated by "/" in the script. I believe it just omits lines that fail to meet the critera, altered by editing the script (down near the bottom - annotated).
python  Filtering_taxaNUM_SNPnum.py 

python haplotypes_to_ambig_code.py $VAR  
python SNP_to_sequence_UVM.py $AMBIG
