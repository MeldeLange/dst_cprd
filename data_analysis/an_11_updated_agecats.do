*Analysis 11: Update the age category variables 
************************************************

*In order to maximise power we will have binary age variables (age at time of clock change) with roughly equally-sized groups (based on the median). The age categories will have to be different for the different outcomes.


*1. Checking age range of our datasets
****************************************

*Open log
log using "projectnumber\analysis\logs/age.log", replace

cd "projectnumber\cprd_data\combined\combined_eventlists"


foreach outcome in anx cvd dep eatdis psy rti selfharm sleep{
use eventlist_`outcome'_18.dta, clear
di "`outcome'"
sum age, detail
count if age ==.
tab em_age_cat, missing
}

*Close log
log close

*We will have the following age categories:

*Anxiety: 10-50 vs >50
*CVD: 40-75 vs >75
*Dep: 10-45 vs >45
*Eastdis: 10-25 vs >25
*Psychological conditions: 10-35 vs >35
*RTI: <=30 vs >30
*Selfharm: 10-30 vs >30
*Sleep: 10-55 vs >55 





*2. Loop to create binary age in years at clock change variable 
***************************************************************

*Note: People aged under 10 have already been removed from the anxiety, depression, eating disorders, self-harm & psychoogical conditions datsets.
*People aged under 40 have already been removed from the CVD dataset.


cd "projectnumber\cprd_data\combined\combined_eventlists"
foreach outcome in "anx" "cvd" "dep" "eatdis" "psy" "rti" "selfharm" "sleep"{
use "eventlist_`outcome'_20.dta", clear
gen em_age_bin=. // new binary age category effect modifier variable
if "`outcome'"== "anx" {
replace em_age_bin=0 if age <=50
replace em_age_bin=1 if age >50 & age <.
label define age_`outcome'_lb 0"<=50" 1">50"
label values em_age_bin age_`outcome'_lb
}
if "`outcome'"== "cvd" {
replace em_age_bin=0 if age <=75
replace em_age_bin=1 if age >75 & age <.
label define age_`outcome'_lb 0"<=75" 1">75"
label values em_age_bin age_`outcome'_lb
}
if "`outcome'"== "dep" {
replace em_age_bin=0 if age <=45
replace em_age_bin=1 if age >45 & age <.
label define age_`outcome'_lb 0"<=45" 1">45"
label values em_age_bin age_`outcome'_lb
}
if "`outcome'"== "eatdis" {
replace em_age_bin=0 if age <=25
replace em_age_bin=1 if age >25 & age <.
label define age_`outcome'_lb 0"<=25" 1">25"
label values em_age_bin age_`outcome'_lb
}
if "`outcome'"== "psy" {
replace em_age_bin=0 if age <=35
replace em_age_bin=1 if age >35 & age <.
label define age_`outcome'_lb 0"<=35" 1">35"
label values em_age_bin age_`outcome'_lb
}
if "`outcome'"== "rti" {
replace em_age_bin=0 if age <=30
replace em_age_bin=1 if age >30 & age <.
label define age_`outcome'_lb 0"<=30" 1">30"
label values em_age_bin age_`outcome'_lb
}
if "`outcome'"== "selfharm" {
replace em_age_bin=0 if age <=30
replace em_age_bin=1 if age >30 & age <.
label define age_`outcome'_lb 0"<=30" 1">30"
label values em_age_bin age_`outcome'_lb
}
if "`outcome'"== "sleep" {
replace em_age_bin=0 if age <=55
replace em_age_bin=1 if age >55 & age <.
label define age_`outcome'_lb 0"<=55" 1">55"
label values em_age_bin age_`outcome'_lb
}


save "eventlist_`outcome'_21.dta", replace // save updated datsets.

}



********************************************

*3. Remove extra blank observations for practices/regions with no people in (data for pracid & region is there but rest of row is just missing data) 

cd "projectnumber\cprd_data\combined\combined_eventlists"
foreach outcome in anx cvd dep eatdis psy rti selfharm sleep{
use "eventlist_`outcome'_21.dta", clear
drop if patid ==. // 13 obs deleted from the eating disorders eventlist only.
save "eventlist_`outcome'_22.dta", replace // save updated datsets.

}