library(dplyr); library(reshape)
dat <- read.csv(file = "cybrid_transformed.csv", header = T)
dat$family <- paste(dat$cross, dat$fid, sep="")
fam <- unique(dat$family)
# separate each family into its own dataframe
for (f in fam) {
  a <- dat %>%
    filter(family == f)
  name <- paste(f,"", sep = "")
  assign(name, a)
}
# edit and fill in based on what families are alive/dead
	# example: dead.lines <- list(BB3, CD4, LB6)
	#		   alive.lines <- list(JB7, FB2)
dead.lines <- list()
alive.lines <- list()
# merge into data frames containing all alive or dead lines
extinct <- reshape::merge_recurse(dead.lines)
extanct <- reshape::merge_recurse(alive.lines)

write.csv(extinct, file = "cybrid_extinct.csv", quote = F, row.names = F)
write.csv(extant, file = "cybrid_extant.csv", quote = F, row.names = F)