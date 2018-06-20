# cybrid_transformed.R
input : cybrid data in .csv format

run in terminal: Rscript cybrid_transformed.R [downloaded_spreadsheet.csv]

output: "cybrid_transformed.csv" to your current working directory

output columns explained:
- mito - mitochondrial line
- nuc - nuclear line
- cross - cross ID ex. BB is a BR x BR cross
- fid - family ID (numbers are reused for different mito x nuc crosses)
- gen - generation (BC = backcross)
- rid - replicate ID, the unique ID for each individual well
- start.date - start date of well
- nauplii - date nauplii first appeared
- FE.removed - date the FE was removed or found dead
- f.num - number of females before one was finally productive
- fe.dead - was the FE found dead or manually removed (n = manually removed, y = found dead)
- status - is the line extinct or extant (0 = extant, 2 = extinct)
- full.ID - concatenated ID including cross_fid_rid
- offspringID - the last part of the full ID (ex. full.ID = BB_1_R1E1E1, then offspringID = E1)
- parentID - the beginning part of the full ID (ex. full.ID = BB_1_R1E1E1, then parentID = BB_1_R1E1)
- parent.start - start date for the parental cross
- start.gen.time - generation time calculated based on subsequent cross start dates
- parent.naup - date nauplii appeared in parental cross
- naup.gen.time - generation time calculated based on subseqent cross nauplii dates
- productivity.time - number of days between the start of the cross and when nauplii appeared

The full IDs will be printed to the terminal by default but you can comment this out in the loops 

### Errors
Error 1:
```
Error in $<-.data.frame(*tmp*, "parent.start", value = c(6L, 13L)) : 
  replacement has 2 rows, data has 1
Calls: $<- -> $<-.data.frame
Execution halted
```
This means that in the full ID column there are two identical values
The full ID that is printed before the error halts the script is the offspring of the well with identical values
In other words, to find the duplicated ID remove the replicate ID from the problematic full ID
ex.  
```
[1] "BB_6_R1E1E1"
Error in `$<-.data.frame`(`*tmp*`, "parent.start", value = c(6L, 13L)) : 
  replacement has 2 rows, data has 1
Calls: $<- -> $<-.data.frame
Execution halted
```
In the master spreadsheet BB_6_R1E1 is duplicated so it cannot determine which data to use

Error 2:
```
Error in `$<-.data.frame`(`*tmp*`, "parent.start", value = integer(0)) : 
  replacement has 0 rows, data has 1
Calls: $<- -> $<-.data.frame
Execution halted
```
This means that there is a full ID without a parent ID
The full ID that is printed is the offspring that is missing a parent
ex. 
```
[1] "BB_6_R4E1E1"
Error in `$<-.data.frame`(`*tmp*`, "parent.start", value = integer(0)) : 
  replacement has 0 rows, data has 1
Calls: $<- -> $<-.data.frame
Execution halted
```
In the master spreadsheet BB_6_R4E1 is missing 

# separate_by_cross.R 
Use to create .csv files each containing the data for one cross.

Must have already run cybrid_transformed.R

run in terminal: Rscript separate_by_cross.R cybrid_transformed.csv

output: ex. "JB.csv" to your current working directory
