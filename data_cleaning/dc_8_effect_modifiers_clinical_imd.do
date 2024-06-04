*Create effect modifiers from clinical & deprivation files
***********************************************************



*1 Combine patient files with just gender, year of birth, month of birth & marital status
******************************************************************************************

*1a) Loop to open the 5 patient files, save patid, current registration date & transfer out date.
clear
cd "cprd_data\gold_primary_care_all\Stata files"
ssc install fs
fs "*Patient*"
foreach f in `r(files)' {
	use "`f'", clear
	keep patid yob mob gender marital // keep patient id, year of birth, month of birth, gender & martial status
	save "tempdata/demog_`f'", replace
			}

*1b) Loop to append the 5 temporary spine files.
clear
cd "cprd_data\gold_primary_care_all\Stata files\tempdata"
fs "*demog*"
foreach f in `r(files)' {
	di "`f'"
	append using "`f'"
	rm "`f'"
}

duplicates drop //	(in terms of all variables) (0 observations deleted)


*1c) Clean variables

*Gender
tab gender, missing
*Raw data: 0=Data Not Entered. 1=Male (658088). 2=Female (917008). 3=Indeterminate (15). 4=Unknown.
gen em_gender_bin = gender
recode em_gender_bin (3=.) // recode so we have male, female, missing.
label define em_gender_bin_lb 1"Male" 2"Female"
label values em_gender_bin em_gender_bin_lb
tab em_gender_bin, missing // Male: 658,088. Female: 917,008. Missing: 15.


*Marital status
tab marital, missing
*Raw data: 0 =Data Not Entered. 1 =Single. 2=Married. 3=Widowed. 4=Divorced. 5=Separated. 6=Unknown. 7=Engaged. 8=Co-habiting. 9=Remarried. 10=Stable relationship. 11=Civil Partnership.
gen em_marital_bin = marital
recode  em_marital_bin (0=.) (1=2) (2=1) (3=2) (4=2) (5=2) (6=.) (7=1) (8=1) (9=1) (10=1) (11=1) // Recode to in relationship/rest/missing.
label define em_marital_bin_lb 1"In relationship" 2"Not in relationship"
label values em_marital_bin em_marital_bin_lb
tab em_marital_bin, missing // In r'ship: 176,212. Not in r'ship: 117,750. *Missing: 1,181,149.* We are missing marital status for 80% of our sample!

*Save demographic effect modifiers file
save demog.dta, replace

********************************************************

*2. Create effect modifier from deprivation file

*2a) Save deprivation data

cd "cprd_data\Deprivation"

*Open IMD file
import delimited patient_2019_imd_22_002468.txt, clear

*Explore file
ssc install unique
unique patid // 1490,984 - not sure why we have this many people? 
unique pracid // 391

*Format patid so not in scientific notation
format patid %12.0f

*Save deprivation file as stata file
cd "cprd_data\gold_primary_care_all\Stata files"
save stata_imd.dta, replace
cd "cprd_data\gold_primary_care_all\Stata files\tempdata"
save stata_imd.dta, replace


*2b) Merge deprivation file with demographic effect modifiers based on patid.
cd "cprd_data\gold_primary_care_all\Stata files\tempdata"
use demog.dta, clear
merge 1:1 patid using stata_imd.dta
drop if _merge ==2
drop _merge
*Result                      Number of obs
*    -----------------------------------------
*    Not matched                        15,881
*        from master                         4  (_merge==1)
*        from using                     15,877  (_merge==2)

*    Matched                         1,475,107  (_merge==3)
*    -----------------------------------------

** 4 people in our sample weren't in the IMD dataset.

*rename imd variable
rename e2019_imd_20 em_imd

*Recode imd variable to binary var of most deprived 20% vs rest. (Raw data:1-20. 1=least deprived. 20=most deprived)
tab em_imd, missing // we are missing imd for 1,107 patients.
recode em_imd(1/15=2) (16/20=1), gen(em_imd_bin)
list em_imd em_imd_bin in 1/10
label define em_imd_bin_lb 1"Most deprived" 2"Rest"
label values em_imd_bin em_imd_bin_lb
tab em_imd_bin, missing


*Save combined dataset
save demog_imd.dta, replace

*******************************************************************************************

*3. Generate a date of birth variable
***************************************



*3a) Clean month of birth variable
cd "cprd_data\gold_primary_care_all\Stata files\tempdata"
use demog_imd.dta, clear
tab mob, missing
replace mob =. if mob ==0 //set mob to missing if it is 0.
tab mob, missing
replace mob=7 if mob==. // set mob to July it is missing.
tab mob, missing

*Generate day of birth
gen dayob =01 // set day of birth to 1st of the month for everyone.

*Combine day of birth, month of birth & year of birth into one date of birth variable.
generate dob = mdy(mob, dayob, yob)
format dob %d
list patid dayob mob yob dob in 1/10
list patid dayob mob yob dob in -10/-1

*Save dataset
save demog_imd2.dta, replace

************************************************

*4. Drop variables we no longer need
**********************************
cd "cprd_data\gold_primary_care_all\Stata files\tempdata"
use demog_imd2.dta, clear
keep patid em_gender_bin em_marital_bin em_imd_bin dob // patient id, gender, marital status, deprivation & date of birth.

*Save dataset
save demog_imd3.dta, replace
