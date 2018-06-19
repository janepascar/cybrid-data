#!/usr/bin/env Rscript
# usage: Rscript separate_by_cross.R cybrid_transformed.csv
# Use this to separate the master transformed data into individual csv files based on crosses
# output: [cross].csv files into working directory
# must have already run cybrid_transformed.R

packages <- c("dplyr", "stringr")
lapply(packages, library, character.only = TRUE)

args = commandArgs(trailingOnly = TRUE)
args2 = str_sub(args, 1, str_length(args)-4)
dat <- read.csv(args)

dat$fid <- as.factor(dat$fid)

lines <- unique(dat$cross)

for (line in lines) {
  a <- dat %>%
    filter(cross == line)
  name <- paste(line,"", sep = "")
  assign(name, a)
  write.csv(name, file =paste(name, ".csv", sep = ""))
}
