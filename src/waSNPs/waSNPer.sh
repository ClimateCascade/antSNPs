#! /bin/bash

#Load modules
module load stacks
module load bowtie

#Assume you are working locally (./) with an unzipped file 
outdir=waSNPs
rads=~/mkls/test_aftrrad/test1/Data/ddRAD2  #unzipped file path
barcodes=~/mkls/test_aftrrad/test1/Barcodes/ddRAD2 #formatted: GCATG	03A.fq
refmap=~/indexes

#setup alieses
FASTX=/N/soft/mason/galaxy-apps/fastx_toolkit_0.0.13/fastx_trimmer
FASTQ=/N/soft/mason/galaxy-apps/fastx_toolkit_0.0.13/fastq_quality_filter

#################################
#demultiplex, trim, filter
#################################
mkdir $outdir
cd $outdir
sabre se -m 1 -f $rads -b $barcodes -u unknown
fqs=$(ls)
mkdir trimmed original
for X in $fqs;
do 
    echo $X
    $FASTX -Q33 -f 5 -i $X -o ./trimmed/$X;
    mv $X original/$X;
done
mkdir filtered
for X in $fqs;
do 
    echo $X
    $FASTQ -Q33 -q 10 -p 100  -i ./trimmed/$X -o ./filtered/$X;
done

# #Filtered reads are used from here on
# #################################
# #Identifying SNPs
# #################################

#map to "reference" genome

###uses the filtered sequences
ln -s $refmap ./indexes
mkdir sam
for X in $fqs; 
do 
    bowtie AphaenogasterRAD ./filtered/$X -S ./sam/$X.sam; 
done
#######??????????????###########
#######??????????????###########
#######??????????????###########
### this step could be made to create a database see:
### http://creskolab.uoregon.edu/stacks/comp/ref_map.php
#######??????????????###########
#######??????????????###########
#######??????????????###########
# ###Build the following as a bash script that will then be called as sh sam_map.sh
echo "#! /bin/bash" | tee "sam_map.sh"
echo "ref_map.pl \\" | tee -a "sam_map.sh"
for X in $fqs;
do 
    echo "-s ./sam/$X.sam \\" | tee -a "sam_map.sh"
done
echo "-o ./output -n 3 -m 1 -T 8 -S -b 2 " | tee -a "sam_map.sh"
mkdir output
sh sam_map.sh

# #getting genotypes
genotypes -b 2 -P ./output -r 3 -m 2 -t GEN -s
### sql output 
# genotypes -b 2 -P ./output -r 3 -m 2 -t GEN -s

# Convert to FASTA
INPUT=./output/batch_2.haplotypes_3.tsv
VAR=./output/batch_2.haplotypes_variable.tsv
DIP=./output/batch_2.haplotypes_variable2.tsv
AMBIG=./output/batch_2.haplotypes_variable2_single.tsv
grep -v "consensus" $INPUT > $VAR
grep -v "\w*/\w*/" $VAR > $DIP
python ../haplotype_to_ambig_code.py $DIP
python ../SNP_to_sequence.py $AMBIG
python ../Filtering_taxaNUM_SNPnum.py waSNPs.fas

# ####Code from andrew that filters tags with too many SNPs or too
# # much missing data Andrew's script to filter out tags with too many
# # SNPs and tags with too much missing data.
## from Filtering_taxaNUM_SNPnum.py

