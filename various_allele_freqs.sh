#!/bin/sh
#SBATCH --job-name="getting_diff_freqs"
#SBATCH --output=plink_sample_names_%A.out
#SBATCH -p MSC      # Queue name

#plink2 --pfile /data/UKB/Genotypes/Imputed/20  --geno 0.02 --make-pgen --out /data/MSc/20_snps
#plink2 --pfile /data/MSc/20_snps --mind 0.02 --make-pgen --out 20_snps

#plink2 --pfile 20_snps --min-maf 0.03 --max-maf 0.06 --make-pgen --out 20_snps326
#plink2 --pfile 20_snps326 --hwe 1e-10 --make-pgen --out 20_snps326
#plink2 --pfile 20_snps326 --geno-counts --out 20_snps326
#

#awk '{ if($5 > 25000 && $6 > 25000  && $10 < 5) print $2;}'  20_snps326.gcount  > chrm_20_snps_threetosix.txt


#plink2 --pfile 20_snps --maf 0.06 --max-maf 0.1 --make-pgen --out 20_snps6to1
#plink2 --pfile 20_snps6to1 --hwe 1e-10 --make-pgen --out 20_snps6to1
#plink2 --pfile 20_snps6to1 --geno-counts --out 20_snps6to1


#awk '{ if($5 > 25000 && $6 > 25000  && $10 < 5) print $2;}' 20_snps.gcount  > chrm_20_snps_sixtoten.txt


plink2 --pfile 20_snps --maf 0.1 --max-maf 0.2 --make-pgen --out 20_snps10totwenty
plink2 --pfile 20_snps10totwenty --hwe 1e-10 --make-pgen --out 20_snps10totwenty
plink2 --pfile 20_snps10totwenty --geno-counts --out 20_snps10totwenty


awk '{ if($5 > 25000 && $6 > 25000  && $10 < 5) print $2;}' 20_snps10totwenty.gcount  > chrm_20_snps_tentotwenty.txt


plink2 --pfile 20_snps --maf 0.2 --max-maf 0.3 --make-pgen --out 20_snps20to30
plink2 --pfile 20_snps20to30  --hwe 1e-10 --make-pgen --out 20_snps20to30 
plink2 --pfile 20_snps20to30  --geno-counts --out 20_snps20to30 


awk '{ if($5 > 25000 && $6 > 25000  && $10 < 5) print $2;}' 20_snps20to30.gcount  > chrm_20_snps_twentytothirty.txt

plink2 --pfile 20_snps --maf 0.3 --max-maf 0.4 --make-pgen --out 20_snps30to40
plink2 --pfile 20_snps30to40 --hwe 1e-10 --make-pgen --out 20_snps30to40
plink2 --pfile 20_snps30to40 --geno-counts --out 20_snps30to40


awk '{ if($5 > 25000 && $6 > 25000  && $10 < 5) print $2;}' 20_snps30to40.gcount  > chrm_20_snps_tirtytoforty.txt

mv chrm_20_snps_tirtytoforty.txt freq0.4/
mv chrm_20_snps_twentytothirty.txt freq0.3/
mv chrm_20_snps_tentotwenty.txt freq0.2/

mv chrm_20_snps_threetosix.txt freq0.06/

mv chrm_20_snps_sixtoten.txt freq0.1


##In order to check for for genotype calls with fewer calls for non-reference allele

awk '{ if($5 > 25000 && $6 > 5 && $6 < 50 && $7 <50  && $10 < 5) print $2;}' 20_snps.gcount > 20_snps_harder_calls.gcount
#awk '{ if($5 > 25000 && $6 > 2 && $6 < 10 && $7 <10  && $10 < 5) print $2;}' 20_snps.gcount > 20_snps_harder_calls_twototen.gcount
#awk '{ if($5 > 25000 && $6 > 10 && $6 < 20 && $7 <20  && $10 < 5) print $2;}' 20_snps.gcount > 20_snps_harder_calls_tentotwenty.gcount
#awk '{ if($5 > 25000 && $6 > 20 && $6 < 40 && $7 <40  && $10 < 5) print $2;}' 20_snps.gcount > 20_snps_harder_calls_twentytoforty.gcount
#awk '{ if($5 > 25000 && $6 > 20 && $6 < 40 && $7 <40  && $10 < 5) print $2;}' 20_snps.gcount > 20_snps_harder_calls_twentytoforty.gcount

mv 20_snps_harder_calls.gcount freq_harder_call


plink2 --pfile 20_snps --maf 0.03 --max-maf 0.06 --make-pgen --out 20_snps_03_06
plink2 --pfile 20_snps_03_06 --hwe 1e-10 --make-pgen --out 20_snps_03_06 
plink2 --pfile 20_snps_03_06 --freq --out 20_snps_03_06
plink2 --pfile 20_snps_03_06 --geno-counts --out 20_snps_03_06
awk '{ if($5 > 25000 && $6 > 25000  && $10 < 5) print $2;}' 20_snps_03_06.gcount  > 20_snps_03_06.txt

