import pandas as pd
import sys
 
#Read in a vcf file, append each line to a list removing the initial junk plink outputs which starts with ##
n = sys.argv[1]
b = []
f = open(n, 'r')
linelist = f.readlines()
for line in linelist:
	if not line.startswith('##'):
		b.append(line)
f.close


#Split each line into list elements corresponding to each column, remove all columns except "0/0" which is 9 and onwards. Replace SNP values with 0 for mutation present or 1 for normal
b[0]  = b[0].split('\t')
b[0] = b[0][9:]
for i in range(0,len(b[0])):
	b[0][i] =  b[0][i].split("\t")


#print(b[1][4])


chrom_number = b[1].split('\t')
chrom_number = chrom_number[0]

snp_pos = []

for i in range(1,len(b)):
	b[i]  = b[i].split('\t')
	snp_pos.append(b[i][2])
	b[i] = b[i][9:]
	for j in range(len(b[i])):
                b[i][j] = b[i][j].replace("0/0", "1")
                b[i][j] = b[i][j].replace("0/1", "0")
                b[i][j] = b[i][j].replace("1/1", "0")

        	
#for i in range(len(snp_pos)):
#	snp_pos[i] = snp_pos[i].replace(":", "_")
#print(snp_pos)
#Write a csv relating sample ID to mutation status for each SNP
names = b[0]
names = [item for sublist in names for item in sublist]
for i in range(len(names)):
	names[i] = names[i].replace("_", " ")
#print(names[1:10])
j = 0
for i in range(1,len(b)):#
	d = {'SAMPLE_ID':names, 'MUTATION_STATUS':b[i]}
	df = pd.DataFrame(d, columns=['SAMPLE_ID','MUTATION_STATUS'])
	mutant_df = df[df['MUTATION_STATUS'] == "0"]
	normal_df = df[df['MUTATION_STATUS'] == "1"]
	if (normal_df.shape[0] >= 2500):
		normal_df = normal_df.sample(n=2500)
	else:
		pass
	if (mutant_df.shape[0] >= 2500):
		mutant_df = mutant_df.sample(n=2500)
	else:   
		pass
	
	df1 = pd.concat([mutant_df,normal_df])
	df1.to_csv("mut_stat_file" + str(snp_pos[j]), index = False, sep = "\t")	#
	df2 = df1[["SAMPLE_ID"]]
	df2.to_csv("Sampl_Ids" + str(snp_pos[j]) , index = False, sep = "\t")#
	j = j +1
	
