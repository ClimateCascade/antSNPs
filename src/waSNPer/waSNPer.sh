#! /bin/bash

####################################################
### WARNING: please make sure you are working in the 
### correct location on the server.
####################################################

##############################
### Setup
##############################

#Assume you are working locally (./) with an unzipped file 
outdir=waSNPs #output directory
rads=~/mkls/ddRADs/scahan_VGN_20141014_CCO3-RAD_R1.fastq #unzipped file path
barcodes=~/mkls/ddRADs/ddRAD2 #formatted: GCATG<tab>03A
refmap=~/indexes
batchid=2 #the batch id used in stacks ref_map.pl and genotype.pl
nmismatch=3 #ref_map.pl -n = number of mismatches
mindepth=1 #ref_map.pl -m = minimum depth of coverage to report a stack
nthreads=8 #ref_map.pl -T = number of threads
minprog=3 #genotype.pl -r = minimum number of progeny to keep read
minstack=2 #genotype.pl -m = minimum stack depth for exporting a locus
maptype=GEN #genotype.pl -t = map type ('CP', 'DH', 'F2', 'BC1', and 'GEN')

#Load modules and alieses
module load stacks
module load bowtie
FASTX=/N/soft/mason/galaxy-apps/fastx_toolkit_0.0.13/fastx_trimmer
FASTQ=/N/soft/mason/galaxy-apps/fastx_toolkit_0.0.13/fastq_quality_filter

#################################
### Demultiplex, trim and filter
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

### Filtered reads are used from here on

#################################
###Identifying SNPs
#################################

### map to "reference" genome
ln -s $refmap ./indexes
mkdir sam
for X in $fqs; 
do 
    bowtie AphaenogasterRAD ./filtered/$X -S ./sam/$X.sam; 
done

# ###Build the following as a bash script that will then be called as sh sam_map.sh
echo "#! /bin/bash" | tee "sam_map.sh"
echo "ref_map.pl \\" | tee -a "sam_map.sh"
for X in $fqs;
do 
    echo "-s ./sam/$X.sam \\" | tee -a "sam_map.sh"
done
echo "-o ./rm_out -n $nmismatch -m $mindepth -T $nthreads -b $batchid -S" | tee -a "sam_map.sh"
mkdir rm_out
sh sam_map.sh

###############
### Genotyping
###############
genotypes -b $batchid -P ./rm_out -r $minprog -m $minstack -t GEN -s

################################
### SNP Filtering and Output
################################

INPUT=./rm_out/batch_$batchid.haplotypes_$minprog.tsv
VAR=./rm_out/batch_$batchid.haplotypes_variable.tsv
DIP=./rm_out/batch_$batchid.haplotypes_variable$minstack.tsv
AMBIG=./rm_out/batch_$batchid.haplotypes_variable$minstack_single.tsv

### Fix CatalogID 
sed "s|Catalog ID|CatalogID|g" $INPUT > $INPUT
sed "s|Catalog ID|CatalogID|g" $VAR > $VAR

#### add input variables
#### add correct input file
### python ../Filtering_taxaNUM_SNPnum.py input???

grep -v "consensus" $INPUT > $VAR
grep -v "\w*/\w*/" $VAR > $DIP
python ../haplotype_to_ambig_code.py $DIP
python ../SNP_to_sequence.py $AMBIG
