library(plyr); library(dplyr)
dat <- read.csv("cybrid_transformed.csv", header = T)
# counts the frequency of a parental ID
freq <- plyr::count(dat, vars = "parentID")
# new column with the number of successful wells from the offspring of the full_ID well
dat$success <- freq$freq[match(dat$full.ID, freq$parentID)]
# change NA to 0
dat$success[is.na(dat$success)] <- 0
# if a well has not produced any successful offspring it has presumably gone extinct (TRUE)
dat$well_extinct <- ifelse(dat$success >0, "FALSE", "TRUE")