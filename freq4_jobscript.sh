#!/bin/sh
#SBATCH --job-name="getting_freqfour"
#SBATCH --output=plink_sample_names_%A.out
#SBATCH -p MSC      # Queue name

module load plink2
module load python3
module load R
#head -n 109 chrm_20_snps_tirtytoforty.txt > chrm_20_snps_tirtytoforty_n100.txt
#plink2 --pfile /data/UKB/Genotypes/Imputed/20 --extract chrm_20_snps_tirtytoforty_n100.txt --export vcf --out chrm_20_snps_tirtytoforty_n100_OUT
#python3 GRAB6.py chrm_20_snps_tirtytoforty_n100_OUT.vcf


for file in Sampl_Ids*;
do
for i in 1000 2500 5000 10000 25000;
do 
#python smaller_INTERVAL_AROUND_SNP.py /data/UKB/Genotypes/Imputed/20.pvar ${file##*Sampl_Ids} ${i} ${file##*Sampl_Ids}_${i}_OUT;
#plink2 --pfile /data/UKB/Genotypes/Imputed/20 --export A include-alt --keep ${file} --snps-only --extract bed0 ${file##*Sampl_Ids}_${i}_OUT  --out ${file##*Sampl_Ids}_${i}_OUT;
Rscript EUCLIDEAN_DISTANCES_w_window.R ${file##*Sampl_Ids}_${i}_OUT.raw mut_stat_file${file##*Sampl_Ids} ${i}
done
done
