#!/usr/bin/env Rscript
# usage: Rscript cybrid_transformed.R [.csv of cybrid data from google drive]
# will save a file named cybrid_transformed.csv to your current working directory
# errors will halt the script
# error 1: replacement has 2 rows, data has 1
	# in the spreadsheet there is a duplicated full ID so it does not know which one to pull dates from; one must be deleted or corrected
# error 2: replacement has 0 rows, data has 1
	# in the spreadsheet there is a full ID that does not have a corresponding parental ID; either the offspring ID is incorrect or the parental data is missing

require(stringr); require(tidyr); require(dplyr)
args = commandArgs(trailingOnly=TRUE)
args2<-str_sub(args, 1, str_length(args)-4)
options(warn=-1)
dat = read.csv(args)

# full ID includes the cross, family ID, and unique well ID ex. BB_1_R1E1E1
dat$full.ID <- paste(dat$cross, dat$fid, dat$rid, sep = "_")

# offspring ID is the last part of the full ID i.e. the replicate
# parent ID is the full ID excluding the last expansion ID
offspringID <- unlist(lapply(stringr::str_split(gsub("([E])"," \\1", dat$full.ID), " "), function(i) tail(i, n=1))) # put space before E then take the last vector entry with tail function
pa <- lapply(stringr::str_split(gsub("([E])"," \\1", dat$full.ID), " "), function(i) head(i, n=-1)) # split into vector at E with numbers following and remove last
pa2 <- lapply(pa, function(i) paste(i, collapse=" ")) # collapse vector to string
parentID <- unlist(lapply(pa2, function(i) gsub(" ", "", i))) # remove spaces from string and unlist

# making a new data frame with columns for offspringID and parentID
dat2 <- as.data.frame(cbind(dat, offspringID, parentID))
dat2$offspringID <- as.character(dat2$offspringID)
dat2$parentID <- as.character(dat2$parentID)
dat2$rid <- as.character(dat2$rid)
dat2$full.ID <- as.character(dat2$full.ID)

# calculating the generation time between parental generation and subsequent generation based on the start date of crosses
# this removes rows
# ex. the generation time between F1 and BC1 is calculated in the row for BC1 so F1 is removed
output1 <- NULL
print("calculating generation based on start time...........................................")
for (i in 1:nrow(dat2[dat2$parentID!="",])){
  coi <- NULL
  coi <- dat2[dat2$parentID!="",][i,]
  print(coi$full.ID)
  coi$parent.start <- dat2[dat2$full.ID==coi$parentID,]$start.date
  coi$start.gen.time <- as.integer(
  	as.Date(strptime(coi$start.date, "%Y-%m-%d")) - 
  	as.Date(strptime(coi$parent.start, "%Y-%m-%d")))
  output1<-rbind(output1, coi)
}
print("done with generation based on start time.............................................")

# calculating the generation time between parental generation and subsequent generation based on the date nauplii appear in each cross
# this removes rows
# ex. the generation time between F1 and BC1 is calculated in the row for BC1 so F1 is removed

dat2 <- as.data.frame(cbind(dat, offspringID, parentID))
dat2$offspringID <- as.character(dat2$offspringID)
dat2$parentID <- as.character(dat2$parentID)
dat2$rid <- as.character(dat2$rid) 
dat2$full.ID <- as.character(dat2$full.ID)
output2 <- NULL

print("calculating generation based on nauplii time...........................................")
for (i in 1:nrow(dat2[dat2$parentID!="",])){
	coi <- NULL
	coi <- dat2[dat2$parentID!="",][i,]
	print(coi$full.ID)
	coi$parent.naup <- dat2[dat2$full.ID==coi$parentID,]$nauplii
	coi$naup.gen.time <- as.integer(
		as.Date(strptime(coi$nauplii, "%Y-%m-%d")) - 
		as.Date(strptime(coi$parent.naup, "%Y-%m-%d")))
	output2 <- rbind(output2, coi)
}
print("done with generation based on nauplii time.............................................")

# columns missing in dat2 parent.start, start.gen.time, parent.naup, naup.gen.time
# filter for just F1 rows and add these columns to the data frame with NA data
f1 <- dat2 %>%
  filter(gen == "F1")
f1$parentID <- rep(NA, length(f1$parentID))
f1$parent.start <- rep(NA, length(f1$mito))
f1$start.gen.time <- rep(NA, length(f1$mito))
f1$parent.naup <- rep(NA, length(f1$mito))
f1$naup.gen.time <- rep(NA, length(f1$mito))

# making a new data frame including all of the new columns combined into one data frame
cybrid_master_calc <- output1
cybrid_master_calc$parent.naup <- output2$parent.naup
cybrid_master_calc$naup.gen.time <- output2$naup.gen.time

# comment in if there is an error to make sure data frames are compatible for merging
#print(str(cybrid_master_calc)) 
#print(str(f1))

# add the rows for F1 generations
cybrid_transformed <- rbind(cybrid_master_calc, f1)

# calculate time from cross start date to date when nauplii appear
cybrid_master_calc$start.date <- as.Date(cybrid_master_calc$start.date)
cybrid_master_calc$nauplii <- as.Date(cybrid_master_calc$nauplii)

cybrid_transformed$productivity.time <- difftime(as.Date(cybrid_transformed$nauplii, format="%Y-%m-%d"), as.Date(cybrid_transformed$start.date, format="%Y-%m-%d"), units="days")
write.csv(cybrid_transformed, file = "cybrid_transformed.csv", quote = F, row.names = F)
print("file saved")
