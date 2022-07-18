import sys
n = sys.argv[1] # Command line argument, must provide snp IDs in format chromosomenumber:pos:ref:alt
##second arg is window either side
interval  = sys.argv[2]

# Generate a list of elements in the order of chrm, pos, ref, alt
numbers = []
with open(n, "r") as snps:
	a = snps.readlines()
	for line in a:
		line = line.strip()
		line = line.split(":") 
		for word in line:
			word = word.split(',') 
			numbers.append(word)


#Convert list objects in chromosome numbers into a single list of comma separated chromosome numbers
chrom_numbers = numbers[1::4]
chrom_numbers = [item for sublist in chrom_numbers for item in sublist]
#print(chrom_numbers)
ref = numbers[3::4]
alt = numbers[4::4]
ref =  [item for sublist in ref for item in sublist]
alt =  [item for sublist in alt for item in sublist]

#Do same for list of positions
centres = numbers[2::4] # SNP positions
centres = [item for sublist in centres for item in sublist] 


#Make a .bed file for each entry, containing chrm number, 10000 positions to the left of the SNP and 10000 to the right
for i in range(len(centres)):
	with open("POS" + "_N_" + str(interval) + "_" + str(chrom_numbers[i]) +"_" + str(centres[i]) + "_" + str(ref[i]) + "_" + str(alt[i]), 'w') as fp:
               fp.write(str(chrom_numbers[i]) + " " + str(int(centres[i])-int(interval)) + " " + str(int(centres[i])+int(interval)))
