library(data.table)
args = commandArgs(trailingOnly=T)
dat <- as.data.frame(fread(args[1], drop=c("IID", "PAT", "MAT", "SEX", "PHENOTYPE"), header=T))

a <- args[2]
num <- args[3]
a <- gsub(".*file","",a)
colnames(dat) <- gsub("_.*", "", colnames(dat))
dat <- dat[ , -which(colnames(dat) %in% c(a))]


dat <- na.omit(dat)
rownames(dat) <- dat$FID # This ID column is set to rownames, used to ensure samples in inputs consistent
dat$FID <- NULL 


group <- read.table(args[2]) # 2nd command line argument consists of IDs and whether mutation is present/not
rownames(group) <- group$SAMPLE_ID #IDs set to rownames
group$SAMPLE_ID <- NULL
group2 <- merge(group, dat, by = 0)
row.names(group2) <- group2$Row.names



Mutants <- group2[which(group2$MUTATION_STATUS==0),]
Normals <- group2[which(group2$MUTATION_STATUS==1),]
row.names(Mutants) <- Mutants$Row.names
Mutants$Row.names <- NULL
Mutants$MUTATION_STATUS <- NULL




mut_dists <- c()
for(i in  1:nrow(Mutants)){
  mut_dists[i] <- sqrt(sum(((Mutants[i,])-(apply(Mutants[-i,], 2, mean, na.rm = T)))^2))
}


norm_dists <- c()
row.names(Normals) <- Normals$Row.names
Normals$Row.names <- NULL
Normals$MUTATION_STATUS <- NULL

centroid <- apply(Normals, 2, mean, na.rm = T)

for(i in 1:nrow(Normals)){
  norm_dists[i] <- sqrt(sum((((Mutants[i,])-centroid)^2)))
  
}




rs <- args[1]      
s<-gsub("_.*","",rs)

result <- t.test(norm_dists, mut_dists, paired = TRUE)
write(paste0(s, " ", result$p.value),file=paste0("P_VALUES_",num,"_window.txt"),append=TRUE)
df_distances <- data.frame(norm_dists, mut_dists)
write.table(df_distances, paste0(s, "_distances_table_",num))

