*Create effect modifiers from patient & deprivation files
***********************************************************



*1 Combine patient files with just gender, year of birth, month of birth & marital status
******************************************************************************************

*1a) Loop to open the 5 patient files, save patid, current registration date & transfer out date.
clear
cd "projectnumber\cprd_data\gold_primary_care_all\stata"
ssc install fs
fs "*Patient*"
foreach f in `r(files)' {
	use "`f'", clear
	keep patid yob mob gender marital // keep patient id, year of birth, month of birth, gender & martial status
	save "projectnumber\effect_modifiers\patient/`f'", replace
			}

*1b) Loop to append the 5 temporary spine files.
clear
cd "projectnumber\effect_modifiers\patient"
fs "*patient*"
foreach f in `r(files)' {
	di "`f'"
	append using "`f'"
	rm "`f'"
} // obs: 1,474,651


duplicates drop //	(in terms of all variables) 0 duplicates.


*1c) Clean variables

*Gender
tab gender, missing
*Raw data: 0=Data Not Entered. 1=Male (658088). 2=Female (917008). 3=Indeterminate (15). 4=Unknown.
gen em_gender_bin = gender
recode em_gender_bin (3=.) (0=.) (4=.) // recode so we have male, female, missing.
label define em_gender_bin_lb 1"Male" 2"Female"
label values em_gender_bin em_gender_bin_lb
tab em_gender_bin, missing // Male:  657,930. Female:816,705. Missing:16.


*Marital status
tab marital, missing
*Raw data: 0 =Data Not Entered. 1 =Single. 2=Married. 3=Widowed. 4=Divorced. 5=Separated. 6=Unknown. 7=Engaged. 8=Co-habiting. 9=Remarried. 10=Stable relationship. 11=Civil Partnership.
gen em_marital_bin = marital
recode  em_marital_bin (0=.) (1=2) (2=1) (3=2) (4=2) (5=2) (6=.) (7=1) (8=1) (9=1) (10=1) (11=1) // Recode to in relationship/rest/missing.
label define em_marital_bin_lb 1"In relationship" 2"Not in relationship"
label values em_marital_bin em_marital_bin_lb
tab em_marital_bin, missing // In r'ship: 176,143. Not in r'ship: 117,727 . *Missing:1,180,781 .* We are missing marital status for 80% of the source sample.

*Save patient effect modifiers file
save patient.dta, replace

********************************************************

*2. Create effect modifier from deprivation file

*2a) Save deprivation data

cd "projectnumber\effect_modifiers\deprivation"

*Open IMD file
import delimited patient_2019_imd_22_002468.txt, clear

*Explore file
ssc install unique
unique patid // 1474651
unique pracid //391

*Format patid so not in scientific notation
format patid %15.0f

*Save deprivation file as stata file
save imd.dta, replace


*2b) Merge deprivation file with demographic effect modifiers based on patid.
cd "projectnumber"
use "effect_modifiers\patient/patient.dta", clear
merge 1:1 patid using "effect_modifiers\deprivation\imd.dta" // all matched.
drop _merge


*2c) Rename imd variable
rename e2019_imd_20 em_imd

*Recode imd variable to binary var of most deprived 20% vs rest. (Raw data:1-20. 1=least deprived. 20=most deprived)
tab em_imd, missing // we are missing imd for 1,107 patients.
recode em_imd(1/15=2) (16/20=1), gen(em_imd_bin)
list em_imd em_imd_bin in 1/10
label define em_imd_bin_lb 1"Most deprived" 2"Rest"
label values em_imd_bin em_imd_bin_lb
tab em_imd_bin, missing


*2d) Save combined dataset
save "effect_modifiers\patient\patient_imd.dta", replace


*******************************************************************************************

*3. Generate a date of birth variable
***************************************

*a) Clean month of birth variable
cd "projectnumber\effect_modifiers\patient\"
use patient_imd.dta, clear
tab mob, missing
replace mob =. if mob ==0 //set mob to missing if it is 0.
tab mob, missing
replace mob=7 if mob==. // set mob to July if it is missing.
tab mob, missing

*b)Generate day of birth
gen dayob =01 // set day of birth to 1st of the month for everyone.

*c) Combine day of birth, month of birth & year of birth into one date of birth variable.
generate dob = mdy(mob, dayob, yob)
format dob %d
list patid dayob mob yob dob in 1/10
list patid dayob mob yob dob in -10/-1

*d) Drop variables we no longer need
keep patid em_gender_bin em_marital_bin em_imd_bin dob // patient id, gender, marital status, deprivation & date of birth

*e)Save dataset
save patient_imd2.dta, replace



*****************************************

*4. Merge patient & deprivation dataset with eventlists
*********************************************************

*a)Primary care data
clear
cd "projectnumber\cprd_data\gold_primary_care_all\stata\eventlists\valid_gp"
ssc install fs
fs "*eventlist*"
foreach f in `r(files)' {
use `f', clear
merge m:1 patid using "projectnumber\effect_modifiers\patient/patient_imd2.dta"
keep if _merge ==3
drop _merge
save "projectnumber\cprd_data\gold_primary_care_all\stata\eventlists\age/patient_`f'", replace
}


*b) HES APC
clear
cd "projectnumber\cprd_data\HES APC data\clockchanges"
ssc install fs
fs "*eventlist*"
foreach f in `r(files)' {
use `f', clear
merge m:1 patid using "projectnumber\effect_modifiers\patient/patient_imd2.dta"
keep if _merge ==3
drop _merge
save "projectnumber\cprd_data\HES APC data\age/patient_`f'", replace
}


*c) HES A&E
clear
cd "projectnumber\cprd_data\HES A&E\clockchanges"
ssc install fs
fs "*eventlist*"
foreach f in `r(files)' {
use `f', clear
merge m:1 patid using "projectnumber\effect_modifiers\patient/patient_imd2.dta"
keep if _merge ==3
drop _merge
save "projectnumber\cprd_data\HES A&E\age/patient_`f'", replace
}
