#!/bin/sh
#SBATCH --job-name="SOMATs"
#SBATCH --output=plink_sample_names_%A.out
#SBATCH -p highmem      # Queue name
#SBATCH -w compute09	  # node choice

module load plink2
module load python3
module load R
for file in Sampl_Ids*;
do
for i in 1000 2500 5000 10000 25000;
do
python3 The_Somatic_Interval.py Somatic2 ${i};
plink2 --bfile /data/UKB/Genotypes/Exome/UKB_${file:9:1}_200k --export A include-alt --keep ${file} --snps-only --extract bed0 POS_N_${i}_${file##*Sampl_Ids} --out POS_N_${i}_${file##*Sampl_Ids}_OUT;
Rscript EUCLIDEAN_DISTANCES_w_window_NA_Friendly.R  POS_N_${i}_${file##*Sampl_Ids}_OUT.raw mut_stat_file${file##*Sampl_Ids} ${i};
done
done

##This did not work for double digit chromosome number so repeating for chromosome 17
for file in Sampl_Ids17*;
do
for i in  1000 2500 5000 10000 25000;
do 
plink2 --bfile /data/UKB/Genotypes/Exome/UKB_17_200k --export A include-alt --keep ${file} --snps-only --extract bed0 POS_N_${i}_${file##*Sampl_Ids} --out POS_N_${i}_${file##*Sampl_Ids}_OUT;
Rscript EUCLIDEAN_DISTANCES_w_window_NA_Friendly.R  POS_N_${i}_${file##*Sampl_Ids}_OUT.raw mut_stat_file${file##*Sampl_Ids} ${i};
done
done

