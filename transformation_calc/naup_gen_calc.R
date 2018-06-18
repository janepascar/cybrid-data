#!/usr/bin/env Rscript
# usage Rscript naup_gen_calc.R [current.data] 
# run this script after running start_gen_calc.R

require(stringr); require(tidyr)
args = commandArgs(trailingOnly = TRUE)
args2 <- str_sub(args, 1, str_length(args)-4)
options(warn=-1)
dat = read.csv(args)

dat$full.ID <- paste(dat$cross, dat$fid, dat$rid, sep = "_")

offspringID <- unlist(lapply(stringr::str_split(gsub("([E])"," \\1", dat$full.ID), " "), function(i) tail(i, n=1))) # put space before E then take the last vector entry with tail function
pa <- lapply(stringr::str_split(gsub("([E])"," \\1", dat$full.ID), " "), function(i) head(i, n=-1)) # split into vector at E with numbers followoing and remove last
pa2 <- lapply(pa, function(i) paste(i, collapse=" ")) # collapse vector to string
parentID <- unlist(lapply(pa2, function(i) gsub(" ", "", i))) # remove spaces from string and unlist

dat2 <- as.data.frame(cbind(dat, offspringID, parentID))
dat2$offspringID <- as.character(dat2$offspringID)
dat2$parentID <- as.character(dat2$parentID)
dat2$rid <- as.character(dat2$rid) # stupid R factoring I don't understand 
dat2$full.ID <- as.character(dat2$full.ID)
out <- NULL

for (i in 1:nrow(dat2[dat2$parentID!="",])){
	coi <- NULL
	coi <- dat2[dat2$parentID!="",][i,]
	print(coi$full.ID)
	coi$parent.naup <- dat2[dat2$full.ID==coi$parentID,]$nauplii
	coi$naup.gen.time <- as.integer(
		as.Date(strptime(coi$nauplii, "%Y-%m-%d")) - 
		as.Date(strptime(coi$parent.naup, "%Y-%m-%d")))
	out <- rbind(out, coi)
}

write.csv(out, paste(args2[1] , "_naup", sep = "",".csv"), quote = F, row.names = F)