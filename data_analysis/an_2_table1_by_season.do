*an_2 - Analysis table1 by season
******************************

*NB Need to do this separately to the whole cohort table 1 because the same patient can be in both Spring & Autumn analyses.


**************
*1. SPRING
************

*1a) Extract demographic data from all the outcome eventlists to create individual files
cd "projectnumber\cprd_data\combined\combined_eventlists"
foreach outcome in anx cvd dep eatdis psy rti selfharm sleep{
	use eventlist_`outcome'_18.dta, clear
	keep patid em_gender_bin em_marital_bin em_imd_bin dob start_date end_date em_season
	keep if em_season =="Spring"
	save "projectnumber\analysis\table1\spring/`outcome'.dta", replace
}


*******************************

*1b)Append the eventlists & remove duplicates
cd "projectnumber\analysis\table1\spring" // need to have deleted previous saved versions of table 1 saved in this folder for this to work.
clear
local filenames : dir . files "*"
foreach file of local filenames { 
      di "`file'"
	  append using "`file'"
}

ssc install unique
unique patid // 410763. Obs:768021

duplicates drop // 410763

save "spring_table1.dta", replace

***********************

*1c) Generate age at start of each person's study follow-up (latest of start_date and study start date of 2.3.2008)

cd "projectnumber\analysis\table1\spring"
use "spring_table1.dta", clear
* Generate start of follow up in this study varible.
gen start_fwup = start_date // Start_date is the max of practice up to standard date and patient current registration date. 
format start_fwup %d // Turn start of follow-up into date format.
gen study_start = "2.3.2008"   //This is 4 weeks before first clock change in the study so is the first date that someone can have an outcome event included in the study.
gen study_startb = date(study_start, "DMY") // reformat study_start to be a date.
drop study_start
rename study_startb study_start
format study_start %d

replace start_fwup= study_start if start_date < study_start // Start of follow up in this study is the latest of start_date and study start date.

gen difference = start_fwup - dob // number of days between dob & start of follow-up (entry into study) = age in days
gen age = difference / 365.25 //turn days into age in years
drop difference

gen em_age_cat=. // generate 10-year age category variable
replace em_age_cat=1 if age <10 
replace em_age_cat=2 if age >=10 & age <20
replace em_age_cat=3 if age >=20 & age <30
replace em_age_cat=4 if age >=30 & age <40
replace em_age_cat=5 if age >=40 & age <50
replace em_age_cat=6 if age >=50 & age <60
replace em_age_cat=7 if age >=60 & age <70
replace em_age_cat=8 if age >=70 & age <80
replace em_age_cat=9 if age >=80 & age <90
replace em_age_cat=10 if age >=90 & age <.
label define em_age_cat_lb 1 "<10" 2 "10-19" 3 "20-29" 4 "30-39" 5"40-49" 6"50-59" 7"60-69" 8 "70-79" 9 "80-89" 10 ">=90"
label values em_age_cat em_age_cat_lb


save "spring_table1.dta", replace
*********************************************************
 

*1d) Generate BMI, smoking, alcohol, sbp and dbp
foreach modifier in alc bmi dbp sbp smok{
cd "projectnumber\analysis\table1\spring"
use spring_table1.dta, clear
keep patid start_fwup // NB everyone has start of follow-up.
joinby patid using "projectnumber\effect_modifiers\additional/`modifier'_eventdate" 
drop adid
drop if `modifier'_eventdate ==. // drop if there isn't a date for the BMI measurement. 31 obs deleted.
drop if `modifier'_eventdate > start_fwup //drop records if the BMI was measured after the start of follow-up. 2,513,782 observations deleted. 2,327,255 obs left.
bys patid (`modifier'_eventdate) : generate `modifier'eventdate_n = _n // sort according to patid & bmi eventdate. Generate var with sequntial number of the bmi record for each person.
by patid (`modifier'_eventdate) : drop if _n !=_N // drop records except those with the latest bmi date for each person. 1,829,478 observations deleted.  497,777 obs.
drop `modifier'_eventdate `modifier'eventdate_n start_fwup
merge 1:1 patid using spring_table1.dta
drop _merge
save "spring_table1.dta", replace
}



******************************************************************************************************
*1e) Need to recode all binary variables to have values of 0 and 1 (otherwise table1mc doesn't work) & make sure they are labelled properly


*Open dataset
cd "projectnumber\analysis\table1\spring"
use spring_table1.dta, clear

*Recode gender
recode em_gender_bin (1=0) (2=1), gen(gender) // 1 was Male, 2 was female. Now 0 = Male. 1 = Female
label define gender_lb 1 "Female" 0 "Male" // 
label values gender gender_lb
tab em_gender_bin
tab gender

*Recode imd // 1 was most deprived. 2 was rest.
recode em_imd_bin (1=0) (2=1), gen(imd) // now most deprived = 0. Rest = 1.
label define imd_lb 1 "Rest" 0 "Most Deprived"
label values imd imd_lb
tab imd
tab em_imd_bin
 
*Recode bmi // 1 was overweight/obese. 2 was normal/under
recode em_bmi_bin (1=0) (2=1), gen(bmi) // overweight/obese = 0. Normal/under = 1.
label define bmi_lb 1 "Normal/Underweight" 0 "Overweight/Obese"
label values bmi bmi_lb
tab bmi
tab em_bmi_bin

*Recode marital// 1 was in relationship. 2 Not in relationship
recode em_marital_bin (1=0) (2=1), gen(marital) // In relationship = 0. Not in relationship = 1.
label define marital_lb 1 "Not In Relationship" 0 "In Relationship"
label values marital marital_lb
tab marital
tab em_marital_bin

*Recode smoking// 1 was current. 2 Non/Ex
recode em_smok_bin (1=0) (2=1), gen(smok) // Current = 0. Non/Ex = 1.
label define smok_lb 1 "Non/Ex Smoker" 0 "Current Smoker"
label values smok smok_lb
tab smok
tab em_smok_bin

*Recode stystolic BP // 1 was high. 2 was Normal
recode em_sbp_bin (1=0) (2=1), gen(sbp) // High = 0. Normal = 1.
label define sbp_lb 1 "Normal" 0 "High"
label values sbp sbp_lb
tab sbp
tab em_sbp_bin

*Recode diastolic BP // 1 was high. 2 was Normal
recode em_dbp_bin (1=0) (2=1), gen(dbp) // High = 0. Normal = 1.
label define dbp_lb 1 "Normal" 0 "High"
label values dbp dbp_lb
tab dbp
tab em_dbp_bin

*Recode alcohol // 1 was current. 2 was non/ex
recode em_alc_bin (1=0) (2=1), gen(alc) // Current = 0. Non/Ex = 1.
label define alc_lb 1 "Non/Ex Alcohol Drinker" 0 "Current Alcohol Drinker"
label values alc alc_lb
tab alc
tab em_alc_bin

*Label all the variables
label variable gender "Gender"
label variable em_age_cat "Age Category"
label variable imd "Index of Multiple Deprivation 2019"
label variable bmi "BMI"
label variable marital "Marital Status"
label variable smok "Smoking Status"
label variable sbp "Systolic Blood Pressure"
label variable dbp "Diastolic Blood Pressure"
label variable alc "Alcohol Status"



save spring_table1_b.dta, replace

*******************************************

*1f) Code to create table

table1_mc, by(em_age_cat) /// you have to specify a by variable even though I don't want one. Using age category as this has no missing data.
vars( ///
gender cat %4.1f \ /// am calling my binary variable categorical so that the missing category is included.
em_age_cat cat %4.1f \ ///
imd cat %4.1f \ ///
bmi cat %4.1f \ ///
marital cat %4.1f \ ///
smok cat %4.1f \ ///
sbp cat %4.1f \ ///
dbp cat %4.1f \ ///
alc cat %4.1f \ ///
) ///
nospace onecol total(before) missing /// include missing data as a category
saving("spring_table1_cprd.xlsx", replace)




**********************************************************************************************************

*2. AUTUMN
**************

*2a) Extract demographic data from all the outcome eventlists to create individual files
cd "projectnumber\cprd_data\combined\combined_eventlists"
foreach outcome in anx cvd dep eatdis psy rti selfharm sleep{
	use eventlist_`outcome'_18.dta, clear
	keep patid em_gender_bin em_marital_bin em_imd_bin dob start_date end_date em_season
	keep if em_season =="Autumn"
	save "projectnumber\analysis\table1\autumn/`outcome'.dta", replace
}


*******************************

*2b) Append the eventlists & remove duplicates
cd "projectnumber\analysis\table1\autumn" // need to have deleted previous saved versions of table 1 saved in this folder for this to work.
clear
local filenames : dir . files "*"
foreach file of local filenames { 
      di "`file'"
	  append using "`file'"
}

ssc install unique
unique patid // Patids: 424264. Obs: 797011


duplicates drop // 372,747 observations deleted. 424,264 obs remaining.

save "autumn_table1.dta", replace

***********************

*2c) Generate age at start of each person's study follow-up (latest of start_date and study start date of 2.3.2008)

cd "projectnumber\analysis\table1\autumn"
use "autumn_table1.dta", clear
* Generate start of follow up in this study varible.
gen start_fwup = start_date // Start_date is the max of practice up to standard date and patient current registration date. 
format start_fwup %d // Turn start of follow-up into date format.
gen study_start = "2.3.2008"   //This is 4 weeks before first clock change in the study so is the first date that someone can have an outcome event included in the study.
gen study_startb = date(study_start, "DMY") // reformat study_start to be a date.
drop study_start
rename study_startb study_start
format study_start %d

replace start_fwup= study_start if start_date < study_start // Start of follow up in this study is the latest of start_date and study start date.

gen difference = start_fwup - dob // number of days between dob & start of follow-up (entry into study) = age in days
gen age = difference / 365.25 //turn days into age in years
drop difference

gen em_age_cat=. // generate 10-year age category variable
replace em_age_cat=1 if age <10 
replace em_age_cat=2 if age >=10 & age <20
replace em_age_cat=3 if age >=20 & age <30
replace em_age_cat=4 if age >=30 & age <40
replace em_age_cat=5 if age >=40 & age <50
replace em_age_cat=6 if age >=50 & age <60
replace em_age_cat=7 if age >=60 & age <70
replace em_age_cat=8 if age >=70 & age <80
replace em_age_cat=9 if age >=80 & age <90
replace em_age_cat=10 if age >=90 & age <.
label define em_age_cat_lb 1 "<10" 2 "10-19" 3 "20-29" 4 "30-39" 5"40-49" 6"50-59" 7"60-69" 8 "70-79" 9 "80-89" 10 ">=90"
label values em_age_cat em_age_cat_lb


save "autumn_table1.dta", replace
*********************************************************
 

*2d) Generate BMI, smoking, alcohol, sbp and dbp
foreach modifier in alc bmi dbp sbp smok{
cd "projectnumber\analysis\table1\autumn"
use autumn_table1.dta, clear
keep patid start_fwup // NB everyone has start of follow-up.
joinby patid using "projectnumber\effect_modifiers\additional/`modifier'_eventdate" 
drop adid
drop if `modifier'_eventdate ==. // drop if there isn't a date for the BMI measurement. 31 obs deleted.
drop if `modifier'_eventdate > start_fwup //drop records if the BMI was measured after the start of follow-up. 2,513,782 observations deleted. 2,327,255 obs left.
bys patid (`modifier'_eventdate) : generate `modifier'eventdate_n = _n // sort according to patid & bmi eventdate. Generate var with sequntial number of the bmi record for each person.
by patid (`modifier'_eventdate) : drop if _n !=_N // drop records except those with the latest bmi date for each person. 1,829,478 observations deleted.  497,777 obs.
drop `modifier'_eventdate `modifier'eventdate_n start_fwup
merge 1:1 patid using autumn_table1.dta
drop _merge
save "autumn_table1.dta", replace
}


************************

*2e) Need to recode all binary variables to have values of 0 and 1 (otherwise table1mc doesn't work) & make sure they are labelled properly.

*Open dataset
cd "projectnumber\analysis\table1\autumn"
use autumn_table1.dta, clear

*Recode gender
recode em_gender_bin (1=0) (2=1), gen(gender) // 1 was Male, 2 was female. Now 0 = Male. 1 = Female
label define gender_lb 1 "Female" 0 "Male" // 
label values gender gender_lb
tab em_gender_bin
tab gender

*Recode imd // 1 was most deprived. 2 was rest.
recode em_imd_bin (1=0) (2=1), gen(imd) // now most deprived = 0. Rest = 1.
label define imd_lb 1 "Rest" 0 "Most Deprived"
label values imd imd_lb
tab imd
tab em_imd_bin
 
*Recode bmi // 1 was overweight/obese. 2 was normal/under
recode em_bmi_bin (1=0) (2=1), gen(bmi) // overweight/obese = 0. Normal/under = 1.
label define bmi_lb 1 "Normal/Underweight" 0 "Overweight/Obese"
label values bmi bmi_lb
tab bmi
tab em_bmi_bin

*Recode marital// 1 was in relationship. 2 Not in relationship
recode em_marital_bin (1=0) (2=1), gen(marital) // In relationship = 0. Not in relationship = 1.
label define marital_lb 1 "Not In Relationship" 0 "In Relationship"
label values marital marital_lb
tab marital
tab em_marital_bin

*Recode smoking// 1 was current. 2 Non/Ex
recode em_smok_bin (1=0) (2=1), gen(smok) // Current = 0. Non/Ex = 1.
label define smok_lb 1 "Non/Ex Smoker" 0 "Current Smoker"
label values smok smok_lb
tab smok
tab em_smok_bin

*Recode stystolic BP // 1 was high. 2 was Normal
recode em_sbp_bin (1=0) (2=1), gen(sbp) // High = 0. Normal = 1.
label define sbp_lb 1 "Normal" 0 "High"
label values sbp sbp_lb
tab sbp
tab em_sbp_bin

*Recode diastolic BP // 1 was high. 2 was Normal
recode em_dbp_bin (1=0) (2=1), gen(dbp) // High = 0. Normal = 1.
label define dbp_lb 1 "Normal" 0 "High"
label values dbp dbp_lb
tab dbp
tab em_dbp_bin

*Recode alcohol // 1 was current. 2 was non/ex
recode em_alc_bin (1=0) (2=1), gen(alc) // Current = 0. Non/Ex = 1.
label define alc_lb 1 "Non/Ex Alcohol Drinker" 0 "Current Alcohol Drinker"
label values alc alc_lb
tab alc
tab em_alc_bin

*Label all the variables
label variable gender "Gender"
label variable em_age_cat "Age Category"
label variable imd "Index of Multiple Deprivation 2019"
label variable bmi "BMI"
label variable marital "Marital Status"
label variable smok "Smoking Status"
label variable sbp "Systolic Blood Pressure"
label variable dbp "Diastolic Blood Pressure"
label variable alc "Alcohol Status"



save autumn_table1_b.dta, replace


********************************************************

*2f) Code to create table

table1_mc, by(em_age_cat) /// you have to specify a by variable even though I don't want one. Using age category as this has no missing data.
vars( ///
gender cat %4.1f \ /// am calling my binary variable categorical so that the missing category is included.
em_age_cat cat %4.1f \ ///
imd cat %4.1f \ ///
bmi cat %4.1f \ ///
marital cat %4.1f \ ///
smok cat %4.1f \ ///
sbp cat %4.1f \ ///
dbp cat %4.1f \ ///
alc cat %4.1f \ ///
) ///
nospace onecol total(before) missing /// include missing data as a category
saving("autumn_table1_cprd.xlsx", replace)