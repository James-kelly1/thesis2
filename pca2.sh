#!/bin/sh
#SBATCH --job-name="prep_"
#SBATCH --output=plink_sample_names_%A.out
#SBATCH -p highmem      # Queue name
#SBATCH -w compute06	  # node choice

module load plink2
for i in 5000 10000 25000;
do
plink2 --pfile /data/UKB/Genotypes/Imputed/20 --keep Sampl_Idsrs2224324 --snps-only --extract bed0 rs2224324_${i}_OUT --make-pgen --out rs2224324_${i}_for_pca;
plink2 --pfile rs2224324_${i}_for_pca --pca --out rs2224324_${i}_for_pca;
done



