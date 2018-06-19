Usage:
Download the cybrid spreadsheet from google drive in csv format
run in terminal: Rscript cybrid_transformed.R [downloaded_spreadsheet.csv]
output: "cybrid_transformed.csv" to your current working directory

The full IDs will be printed to the terminal by default but you can comment this out in the loops 
If there is an error it is likely during one of the loops where generation time is being calculated due to human input error in the google drive spreadsheet

Error 1:

Error in `$<-.data.frame`(`*tmp*`, "parent.start", value = c(6L, 13L)) : 
  replacement has 2 rows, data has 1
Calls: $<- -> $<-.data.frame
Execution halted

This means that in the full ID column there are two identical values
The full ID that is printed before the error halts the script is the offspring of the well with identical values
In other words, to find the duplicated ID remove the replicate ID from the problematic full ID
ex. 
[1] "BB_6_R1E1E1"
Error in `$<-.data.frame`(`*tmp*`, "parent.start", value = c(6L, 13L)) : 
  replacement has 2 rows, data has 1
Calls: $<- -> $<-.data.frame
Execution halted

In the master spreadsheet BB_6_R1E1 is duplicated so it cannot determine which data to use

 

Error 2:

Error in `$<-.data.frame`(`*tmp*`, "parent.start", value = integer(0)) : 
  replacement has 0 rows, data has 1
Calls: $<- -> $<-.data.frame
Execution halted

This means that there is a full ID without a parent ID
The full ID that is printed is the offspring that is missing a parent
ex. 
[1] "BB_6_R4E1E1"
Error in `$<-.data.frame`(`*tmp*`, "parent.start", value = integer(0)) : 
  replacement has 0 rows, data has 1
Calls: $<- -> $<-.data.frame
Execution halted

In the master spreadsheet BB_6_R4E1 is missing 

