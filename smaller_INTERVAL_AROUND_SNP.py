import sys
import pandas as pd
b = []

with open(sys.argv[1], 'r') as SnpPos: # path to pvar
    for eachline in SnpPos:
            if (sys.argv[2] in eachline):
                    b.append(eachline)

for thing in b:
     pos = thing.split('\t')

n = int(sys.argv[3])
my_list = [int(pos[0]), (int(pos[1]) -n), (int(pos[1]) + n)]

df = pd.DataFrame(my_list)
df = pd.DataFrame.transpose(df)
df.to_csv(sys.argv[4], sep = ' ', header = False, index = False)

