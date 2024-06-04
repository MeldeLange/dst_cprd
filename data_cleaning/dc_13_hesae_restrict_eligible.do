*dc_13 Merge spine & HES A&E eventlists to restrict to eligible events
*************************************************************************************

*Mel de Lange 30.5.24 

*Script to combine spine with HES A&E outcome events & cut down to those eligible.

*Start logging
cd "cprd_data\HES A&E"
log using hesae_eligibility.log, replace

*1.Restrict HES A&E eventlists to events around clock change
*************************************************************
cd "cprd_data\HES A&E"
clear
ssc install unique

*Raw eventlist files we have are:
*eventlist_rti_aepatgroup
*eventlist_selfharm_aepatgroup
*eventlist_psy_diag2_aepatgroup
*eventlist_cvd_diag2_aepatgroup


*Loop to merge spine with eventlist & cut down to clock change window.
foreach eventlist in eventlist_rti_aepatgroup eventlist_selfharm_aepatgroup eventlist_psy_diag2_aepatgroup eventlist_cvd_diag2_aepatgroup {
use spine_clockchanges.dta, clear
unique patid
joinby patid using "`eventlist'" // match spine & event list
unique patid
order patid aekey arrivaldate
gen eligible = 0
foreach var of varlist cc*{
replace eligible =1 if arrivaldate - `var' <= 28 & arrivaldate -`var' >= -28 // only eligible if event is within 28 days either side of clock change
}
keep if eligible ==1 
unique patid
drop eligible
save "eligible_`eventlist'", replace
}



*2. Check for duplicates
*2a)Check no duplictes of same person with same aepatgroup code on same date in self harm & rti lists.
foreach eligiblelist in eligible_eventlist_rti_aepatgroup eligible_eventlist_selfharm_aepatgroup {
	use "`eligiblelist'", clear
	duplicates drop patid arrivaldate aepatgroup, force // there are no duplicates in either file.
	save "`eligiblelist'", replace
}


*2b) Check no duplictes of same person with same aepatgroup & diag2 code on same date in cvd & psyc lists.
foreach eligiblelist in eligible_eventlist_psy_diag2_aepatgroup eligible_eventlist_cvd_diag2_aepatgroup  {
	use "`eligiblelist'", clear
	duplicates drop patid arrivaldate aepatgroup diag2, force // there are no duplicates in either file.
	save "`eligiblelist'", replace
}


*Close log
log close