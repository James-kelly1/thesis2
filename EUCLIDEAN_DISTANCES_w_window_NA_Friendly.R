library(data.table)
args = commandArgs(trailingOnly=T)
dat <- as.data.frame(fread(args[1], drop=c("IID", "PAT", "MAT", "SEX", "PHENOTYPE"), header=T))

a <- args[2]
num <- args[3]
a <- gsub(".*file","",a)
a <- gsub("_", ":", a)
colnames(dat) <- gsub("_.*", "", colnames(dat))

#dat <- dat[ , -which(colnames(dat) %in% c(a))]
#print(dat[c(1:10), c(1:10)])

#dat <- na.omit(dat)
#dat <- dat[ ,apply(dat, 2, function(x) !any(is.na(x)))]
rownames(dat) <- dat$FID # This ID column is set to rownames, used to ensure samples in inputs consistent
dat$FID <- NULL

group <- read.table(args[2]) # 2nd command line argument consists of IDs and whether mutation is present/not
rownames(group) <- group$SAMPLE_ID #IDs set to rownames
group$SAMPLE_ID <- NULL
group2 <- merge(group, dat, by = 0)
row.names(group2) <- group2$Row.names
#group2 <- group2[ ,apply(group2, 2, function(x) !any(is.na(x)))]
#head(group2)
Mutants <- group2[which(group2$MUTATION_STATUS==0),]
Normals <- group2[which(group2$MUTATION_STATUS==1),]
row.names(Mutants) <- Mutants$Row.names
Mutants$Row.names <- NULL
Mutants$MUTATION_STATUS <- NULL


mut_dists <- c()
for(i in  1:nrow(Mutants)){
  indiv <- as.numeric(Mutants[i,])
  indiv <- indiv[!is.na(indiv)]
  mut_dists[i] <- sqrt(sum((indiv-(apply(Mutants[-i,], 2, mean, na.rm = T)))^2))
}
print(mut_dists)

norm_dists <- c()
row.names(Normals) <- Normals$Row.names
Normals$Row.names <- NULL
Normals$MUTATION_STATUS <- NULL

centroid <- apply(Normals, 2, mean, na.rm = T)

for(i in 1:nrow(Mutants)){
   indiv <- as.numeric(Mutants[i,])
   indiv <- indiv[!is.na(indiv)]
   norm_dists[i] <- sqrt(sum((indiv-centroid)^2))
}
len <- length(mut_dists)
rs <- args[2]
s<-gsub("mut_stat_file","",rs)
df_distances <- data.frame(norm_dists, mut_dists)
write.table(df_distances, paste0(s, "_youbetterwork_",num))


result <- t.test(norm_dists, mut_dists, paired = TRUE)
write(paste0(s, " ", result$p.value, " ", len),file=paste0("P_VALUES_",num,"_window.txt"),append=TRUE)
#t.test(norm_dists, mut_dists, paired = TRUE)
