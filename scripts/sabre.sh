#! /bin/bash
#PBS -k o
#PBS -l nodes=2:ppn=8,vmem=1gb,walltime=4:00:00
#PBS -M scahan@uvm.edu
#PBS -m abe
#PBS -N sabre
#PBS -j oe

cd /N/dc2/scratch/scahan/ddRAD2
SABRE=~/programs/sabre-master/sabre
$SABRE se -m 1 -f ddRAD2.fq -b ~/Aphaenogaster/ddRAD2.txt -u unknown.fq
