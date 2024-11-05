*dc_7 Combine primary care & hospital datasets
***********************************************

*This script prepares my extracted datasets and then combines the primary care, HES APC and HES A&E (where appropriate) datasets for each outcome.
*Road traffic injuries, CVD & self-harm have data from all 3 soures: prinmary care, HES APC & HES A&E data.
*Depression, sleep, eating disorders, anxiety: just pc & HES APC data.
*Psyc conditions: just HES A&E data.

*At the end of this script we have 8 datasets: rtis, cvd, depression, self-harm, eating disorders, sleep disorders, anxiety and psychological conditions.

***************************************************************************************

*1. Prepare datasets
**************************

*1a) Move all eventlist datasets into one new folder called 'combined'.

*Primary care eventlists
cd "projectnumber\cprd_data\gold_primary_care_all\stata\eventlists\extraction"
ssc install fs
fs "eventlist*"
foreach f in `r(files)' {

copy "projectnumber\cprd_data\combined\"		
}

*HES APC eventlists

cd "projectnumber\cprd_data\HES APC data"
fs "eventlist*"
foreach f in `r(files)' {

copy "projectnumber\cprd_data\HES APC data/`f'" "projectnumber\cprd_data\combined\"		
}

*HES A&E eventlists

cd "projectnumber\cprd_data\HES A&E\extraction"

fs "eventlist*"
foreach f in `r(files)' {

copy "projectnumber\cprd_data\HES A&E\extraction/`f'" "projectnumber\cprd_data\combined\"		
}

*In HES APC and HES A&E data rename the event date to clinical_eventdate so that all data sources have the same date variable name.

*HES APC
cd "projectnumber\cprd_data\combined"
fs "*icd10*"
foreach f in `r(files)' {
	use `f', clear
	rename admidate clinical_eventdate
	save `f', replace
}

*HES A&E
cd "projectnumber\cprd_data\combined"
fs "*aepatgroup*"
foreach f in `r(files)' {
	use `f', clear
	rename arrivaldate clinical_eventdate
	save `f', replace
}

*********************************

*1b) Harmonise the datasets
*Create indicator variable (code_type) for whether new eventcode variable is medcode, icd10 or aepatgroup(A&E code).
*Then rename medcode, icd and aepatgroup variables to 'eventcode' so all data sources have the same code variable name.
*We are doing this so that all data sources have the same name for the eventcode.

*Primary care
cd "projectnumber\cprd_data\combined"
fs "*med*"
foreach f in `r(files)' {
use `f', clear
gen code_type = ""
replace code_type = "med"
rename medcode eventcode
	save `f', replace
}

cd "projectnumber\cprd_data\combined"
fs "*combined*"
foreach f in `r(files)' {
use `f', clear
gen code_type = ""
replace code_type = "med"
rename medcode eventcode
	save `f', replace
}


*HES APC
cd "projectnumber\cprd_data\combined"
fs "*icd10*"
foreach f in `r(files)' {
use `f', clear
gen code_type = ""
replace code_type = "icd"
rename icd eventcode
	save `f', replace
}

*HES A&E
cd "projectnumber\cprd_data\combined"
fs "*aepatgroup*"
foreach f in `r(files)' {
	use `f', clear
	gen code_type = ""
	replace code_type = "aepatgroup"
	rename aepatgroup eventcode
	save `f', replace
}


*Change format of eventcode variable in primary care and HES A&E into string variable so is the same fomrat as the HES APC data.
cd "projectnumber\cprd_data\combined"
foreach i in aepatgroup med combined{
fs "*`i'*"
foreach f in `r(files)' {
	use `f', clear
	tostring eventcode, replace
	save `f', replace
}
}

******************************************************************************************************************************

*2. Combine datasets

*Loop to append datasets for each outcome & save

*RTIs
cd "projectnumber\cprd_data\combined"
use eventlist_med_rti.dta, clear
append using eventlist_icd10_rti.dta
append using eventlist_rti_aepatgroup.dta
save "combined_eventlists/eventlist_rti", replace

*CVD
cd "projectnumber\cprd_data\combined"
use eventlist_med_cvd.dta, clear
append using eventlist_icd10_cvd.dta
append using eventlist_cvd_diag2_aepatgroup.dta
save "combined_eventlists/eventlist_cvd", replace

*Depression
cd "projectnumber\cprd_data\combined"
use eventlist_dep_combined.dta, clear
append using eventlist_icd10_dep.dta
drop eligible // don't need this as it was to help identify those with symptom & prescription.
save "combined_eventlists/eventlist_dep", replace

*Anxiety
cd "projectnumber\cprd_data\combined"
use eventlist_anx_combined.dta, clear
append using eventlist_icd10_anx.dta
drop eligible // don't need this as it was to help identify those with symptom & prescription.
save "combined_eventlists/eventlist_anx", replace

*Eating disorders 
cd "projectnumber\cprd_data\combined"
use eventlist_med_eatdis.dta, clear
append using eventlist_icd10_eatdis.dta
save "combined_eventlists/eventlist_eatdis", replace

*Sleep
cd "projectnumber\cprd_data\combined"
use eventlist_med_prod_sleep.dta, clear
append using eventlist_icd10_sleep.dta
drop eligible
save "combined_eventlists/eventlist_sleep", replace

*Selfharm
cd "projectnumber\cprd_data\combined"
use eventlist_med_selfharm.dta, clear
append using eventlist_icd10_selfharm.dta
append using eventlist_selfharm_aepatgroup.dta
save "combined_eventlists/eventlist_selfharm", replace

*Psychological conditions (A&E data only so no data to append)
cd "projectnumber\cprd_data\combined"
use eventlist_psy_diag2_aepatgroup.dta, clear
save "combined_eventlists/eventlist_psy", replace
