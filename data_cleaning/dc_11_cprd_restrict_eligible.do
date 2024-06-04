*dc_11 Merge spine & primary care eventlists to restrict to eligible events
****************************************************************************

*Mel de Lange 29.5.24 

*Script to combine spine with primary care outcome events & cut down to those eligible.

*Start logging
cd "cprd_data\gold_primary_care_all\Stata files\tempdata"
log using cprd_eligibility.log, replace

*1.Restrict to events around clock change & in eligible GP period
*********************************************
cd "cprd_data\gold_primary_care_all\Stata files\tempdata"
clear
ssc install unique

*Loop to merge spine with eventlist, cut down to clock change window, cut down to GP record eligibility window.
ssc install fs
fs "eventlist_med*"
foreach f in `r(files)' {
use spine_clockchanges.dta, clear
unique patid
joinby patid using "`f'" // match spine & event list
unique patid
order patid medcode clinical_eventdate
gen eligible = 0
foreach var of varlist cc*{
replace eligible =1 if clinical_eventdate - `var' <= 28 & clinical_eventdate -`var' >= -28 // only eligible if event is within 28 days either side of clock change
}
keep if eligible ==1 
unique patid
replace eligible =0 if clinical_eventdate <start_date | clinical_eventdate > end_date // only eligible if event is within eligible GP period
keep if eligible ==1 
unique patid
drop eligible
save "eligible_`f'", replace
}

*********************************************************************************************************************************
*2 Cut down anxiety symptom, depression symptom & sleep eventlists to those with prescription within 90 days either side of the event date.

*Rename clinical_eventdate prod_eventdate so don't have 2 variables called the same thing when merge with symptom event lists.
cd "cprd_data\gold_primary_care_all\Stata files\tempdata"
foreach outcome in anx dep sleep {
use eventlist_prod_`outcome'.dta, clear
rename clinical_eventdate prod_eventdate
save eventlist_prod_`outcome'2.dta, replace
}


*Anxiety symptoms
	use "eligible_eventlist_med_anx_symp.dta", clear
	unique patid
	joinby patid using "eventlist_prod_anx2.dta"
	unique patid
	gen eligible = 0
	replace eligible = 1 if prod_eventdate - clinical_eventdate <=90 & prod_eventdate - clinical_eventdate >= -90
	keep if eligible == 1
	unique patid
	duplicates drop patid medcode clinical_eventdate, force //Need to drop obs where have same person, same clinical eventdate, but multiple prescriptions within the 180 day period
	unique patid
	save eligible_eventlist_med_prod_anx_symp.dta, replace

**Depression symptoms
	use "eligible_eventlist_med_dep_symp.dta", clear
	unique patid
	joinby patid using "eventlist_prod_dep2.dta"
	unique patid
	gen eligible = 0
	replace eligible = 1 if prod_eventdate - clinical_eventdate <=90 & prod_eventdate - clinical_eventdate >= -90
	keep if eligible == 1
	unique patid
	duplicates drop patid medcode clinical_eventdate, force
	unique patid
	save eligible_eventlist_med_prod_dep_symp.dta, replace
	
*Sleep diagnoses/symptoms		
	use "eligible_eventlist_med_sleep.dta", clear
	unique patid
	joinby patid using "eventlist_prod_sleep2.dta"
	unique patid
	gen eligible = 0
	replace eligible = 1 if prod_eventdate - clinical_eventdate <=90 & prod_eventdate - clinical_eventdate >= -90
	keep if eligible == 1
	unique patid
	duplicates drop patid medcode clinical_eventdate, force
	unique patid
	save eligible_eventlist_med_prod_sleep.dta, replace

****************************************************************************************************************
*3 Append eligible anxiety & depression symptom eventlists on to anxiety & depression diagnoses eventlists
cd "cprd_data\gold_primary_care_all\Stata files\tempdata"

*Depression
use eligible_eventlist_med_prod_dep_symp.dta, clear
unique patid
append using eligible_eventlist_med_dep_diag.dta
unique patid
save eligible_eventlist_dep_combined.dta, replace

*Anxiety
use eligible_eventlist_med_prod_anx_symp.dta, clear
unique patid
append using eligible_eventlist_med_anx_diag.dta
unique patid
save eligible_eventlist_anx_combined.dta, replace



*Close log
log close