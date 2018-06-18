#!/usr/bin/env Rscript
# usage Rscript cybrid_calc.R [output from gen_time.R] [output from naup_time.R]
# run this script after naup_test.R

args = commandArgs(trailingOnly = TRUE)
options(warn=-1)
file1 <- args[1]
file2 <- args[2]
print(file1)
print(file2)
gen <- read.csv(file1)
naup <- read.csv(file2)

# make one data table with generation times based on nauplii and start dates
cybrid_master_calc <- gen
cybrid_master_calc$parent.naup <- naup$parent.naup
cybrid_master_calc$naup.gen.time <- naup$naup.gen.time

# calculate how long it takes from when a female and male is paired to when nauplii appear
#cybrid_master_calc$start.date <- as.Date(cybrid_master_calc$start.date)
#cybrid_master_calc$nauplii <- as.Date(cybrid_master_calc$nauplii)

cybrid_master_calc$productivity.time <- difftime(as.Date(cybrid_master_calc$nauplii, format="%Y-%m-%d"), as.Date(cybrid_master_calc$start.date, format="%Y-%m-%d"), units="days")

write.csv(cybrid_master_calc, file = "cybrid_master_calc.csv", quote = F, row.names = F)