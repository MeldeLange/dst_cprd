* Amending checked codelist for RTIs

* Date started: 23/11/2022

* Author: Mel de Lange

****************************************************************************
***Need to set global macro for rticodesdir2
*global rticodesdir2 ""

** Load in the Excel spreadsheet refined & checked by Mel

import excel "$rticodesdir2\rti_checked.xlsx", firstrow clear

*Remove codes we don't want to keep
count if rti==1
*1,385
count if keep==1
*404
count if keep!=1
*981

drop if keep!=1
drop keep
count
*404

***Investigate duplicates and delete if genuine duplicates
ssc install unique
unique Medicalcode
*404

unique Goldreadcodev2 
*404

*No duplicates found.

**********************************************************
**Save codelist ready to use in data cleaning

*Simplify variable names
rename Medicalcode medcode
rename Goldreadcodev2 readcode
rename Readtermdescription readterm

*Only keep variables we need for codelist
keep medcode readcode readterm

*Need to reset global macros for rticodesdir2
*global rticodesdir2 ""

*Save file
export excel "$rticodesdir2\rti_final.xlsx", firstrow(varlabels) replace
save"$rticodesdir2\rti_final.dta", replace