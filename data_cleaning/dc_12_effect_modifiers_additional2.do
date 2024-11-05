*dc_12_effect_modifiers_additional2
************************************

*Mel de Lange
*10.10.24

*This script merges the extracted data for BMI, smoking, alcohol, systolic & diastolic blood pressure with the eventlists.

***********************************************************************

*1. BMI
cd "projectnumber\cprd_data\combined\combined_eventlists"

foreach outcome in anx cvd dep eatdis psy rti selfharm sleep{
use "eventlist_`outcome'_5.dta", clear
keep patid date_clockchange
duplicates drop
drop if date_clockchange ==.
joinby patid using "projectnumber\effect_modifiers\additional\bmi_eventdate" 
drop adid
drop if bmi_eventdate ==. // drop if there isn't a date for the BMI measurement
drop if bmi_eventdate > date_clockchange //drop records if the BMI was measured after the clock change (exposure)
bys patid date_clockchange (bmi_eventdate) : generate bmieventdate_n = _n // sort according to patid, clock change date & bmi eventdate. Generate var with number of bmi records for each person.
by patid date_clockchange (bmi_eventdate) : drop if _n !=_N // drop records except those with the latest bmi date for each person.
drop bmi_eventdate bmieventdate_n
joinby patid date_clockchange using "projectnumber\cprd_data\combined\combined_eventlists/eventlist_`outcome'_5", unmatched(using)
drop _merge
save "eventlist_`outcome'_6", replace
}



****************************************************************

*2. Alcohol
cd "projectnumber\cprd_data\combined\combined_eventlists"
foreach outcome in anx cvd dep eatdis psy rti selfharm sleep{
use "eventlist_`outcome'_6.dta", clear 
keep patid date_clockchange
duplicates drop
drop if date_clockchange ==.
joinby patid using "projectnumber\effect_modifiers\additional\alc_eventdate" 
drop adid
drop if alc_eventdate ==. // drop if there isn't a date for the alc measurement
drop if alc_eventdate > date_clockchange //drop records if the alc was measured after the clock change (exposure)
bys patid date_clockchange (alc_eventdate) : generate alceventdate_n = _n // sort according to patid, clock change date & alc eventdate. Generate var with number of alc records for each person.
by patid date_clockchange (alc_eventdate) : drop if _n !=_N // drop records except those with the latest alc date for each person.
drop alc_eventdate alceventdate_n
joinby patid date_clockchange using "projectnumber\cprd_data\combined\combined_eventlists/eventlist_`outcome'_6", unmatched(using)
drop _merge
save "eventlist_`outcome'_7", replace
}


****************************************************************

*3. Smoking
cd "projectnumber\cprd_data\combined\combined_eventlists"
foreach outcome in anx cvd dep eatdis psy rti selfharm sleep{
use "eventlist_`outcome'_7.dta", clear  
keep patid date_clockchange
duplicates drop
drop if date_clockchange ==.
joinby patid using "projectnumber\effect_modifiers\additional\smok_eventdate" 
drop adid
drop if smok_eventdate ==. // drop if there isn't a date for the smok measurement
drop if smok_eventdate > date_clockchange //drop records if the smok was measured after the clock change (exposure)
bys patid date_clockchange (smok_eventdate) : generate smokeventdate_n = _n // sort according to patid, clock change date & smok eventdate. Generate var with number of smok records for each person.
by patid date_clockchange (smok_eventdate) : drop if _n !=_N // drop records except those with the latest smok date for each person.
drop smok_eventdate smokeventdate_n
joinby patid date_clockchange using "projectnumber\cprd_data\combined\combined_eventlists/eventlist_`outcome'_7", unmatched(using)
drop _merge
save "eventlist_`outcome'_8", replace
}

****************************************************************

*4. Systolic blood pressure
cd "projectnumber\cprd_data\combined\combined_eventlists"
foreach outcome in anx cvd dep eatdis psy rti selfharm sleep{
use "eventlist_`outcome'_8.dta", clear  
keep patid date_clockchange
duplicates drop
drop if date_clockchange ==.
joinby patid using "projectnumber\effect_modifiers\additional\sbp_eventdate" 
drop adid
drop if sbp_eventdate ==. // drop if there isn't a date for the sbp measurement
drop if sbp_eventdate > date_clockchange //drop records if the sbp was measured after the clock change (exposure)
bys patid date_clockchange (sbp_eventdate) : generate sbpeventdate_n = _n // sort according to patid, clock change date & sbp eventdate. Generate var with number of sbp records for each person.
by patid date_clockchange (sbp_eventdate) : drop if _n !=_N // drop records except those with the latest sbp date for each person.
drop sbp_eventdate sbpeventdate_n
joinby patid date_clockchange using "projectnumber\cprd_data\combined\combined_eventlists/eventlist_`outcome'_8", unmatched(using)
drop _merge
save "eventlist_`outcome'_9", replace
}

****************************************************************

*5. Diastolic blood pressure
cd "projectnumber\cprd_data\combined\combined_eventlists"
foreach outcome in anx cvd dep eatdis psy rti selfharm sleep{
use "eventlist_`outcome'_9.dta", clear  
keep patid date_clockchange
duplicates drop
drop if date_clockchange ==.
joinby patid using "projectnumber\effect_modifiers\additional\dbp_eventdate" 
drop adid
drop if dbp_eventdate ==. // drop if there isn't a date for the sbp measurement
drop if dbp_eventdate > date_clockchange //drop records if the dbp was measured after the clock change (exposure)
bys patid date_clockchange (dbp_eventdate) : generate dbpeventdate_n = _n // sort according to patid, clock change date & dbp eventdate. Generate var with number of dbp records for each person.
by patid date_clockchange (dbp_eventdate) : drop if _n !=_N // drop records except those with the latest dbp date for each person.
drop dbp_eventdate dbpeventdate_n
joinby patid date_clockchange using "projectnumber\cprd_data\combined\combined_eventlists/eventlist_`outcome'_9", unmatched(using)
drop _merge
save "eventlist_`outcome'_10", replace
}

