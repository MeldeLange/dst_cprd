*dc_20_incident_prevalent
*************************

*Generate incident vs prevalent case variable for our eventlists.
*Not needed for road traffic injuries.

******************
*1.Primary care
******************

*1a)Copy files needed into one folder & rename


*original extraction eventlists
foreach outcome in anx dep{
copy "projectnumber\cprd_data\gold_primary_care_all\stata\eventlists\extraction\eventlist_`outcome'_combined.dta" "\\projectnumber\effect_modifiers\incident\extraction_pc_`outcome'.dta"	
}

foreach outcome in cvd eatdis selfharm{
copy "projectnumber\cprd_data\gold_primary_care_all\stata\eventlists\extraction\eventlist_med_`outcome'.dta" "projectnumber\effect_modifiers\incident\extraction_pc_`outcome'.dta"	
}

copy "projectnumber\cprd_data\gold_primary_care_all\stata\eventlists\extraction\eventlist_med_prod_sleep.dta" "projectnumber\effect_modifiers\incident\extraction_pc_sleep.dta"


*Current eventlists
foreach outcome in anx dep selfharm sleep{
copy "projectnumbercprd_data\final_eventlists\all_eventlists\sbp_smok_alc_bmi_sy_2_pc_`outcome'.dta" "projectnumber\effect_modifiers\incident\eventlist_pc_`outcome'.dta"	
}

foreach outcome in cvd eatdis{
copy "projectnumber\cprd_data\final_eventlists\all_eventlists\sbp_smok_alc_bmi_sub_pc_`outcome'.dta" "projectnumber\effect_modifiers\incident\eventlist_pc_`outcome'.dta"	
}



******************************************************************************************

*1b) Loop to create incident case variable
cd "projectnumber\effect_modifiers\incident\"
foreach outcome in anx cvd dep eatdis selfharm sleep{
	use "extraction_pc_`outcome'.dta", clear // open original extraction eventlists
joinby patid using "projectnumber\cprd_data\flow_diagram\final_flow" // cut down to just patids in our study
duplicates drop
bys patid medcode (clinical_eventdate):generate clinicaleventdate_n = _n // for each person & medcode generate an event number
joinby using "eventlist_pc_`outcome'", unmatched (using) // join with current eventlist, keeping records in current eventlist without incident data.
gen em_incident_bin =0 // generate variable for incident case
replace em_incident_bin=1 if clinicaleventdate_n ==1 // make 1 if this is the first case of this code for this person.
label define em_incident_bin_lb 1"Yes" 0"No"
label values em_incident_bin em_incident_bin_lb // label the new variable.
drop _merge clinicaleventdate_n
save "projectnumber\effect_modifiers\incident\incident_pc_`outcome'", replace
}

****************************************************************************************************************************************
****************************************************************************************************************************************

*2. HES APC
***********

*2a)Copy files needed into one folder & rename


*Original extraction eventlists
foreach outcome in anx cvd dep eatdis selfharm sleep{
copy "projectnumber\cprd_data\HES APC data\eventlist_icd10_`outcome'.dta" "projectnumber\effect_modifiers\incident\extraction_hesapc_`outcome'.dta"	
}

*Current eventlists
foreach outcome in anx dep selfharm sleep{
copy "projectnumber\cprd_data\final_eventlists\all_eventlists\sbp_smok_alc_bmi_sy_2_hesapc_`outcome'.dta" "projectnumber\effect_modifiers\incident\eventlist_hesapc_`outcome'.dta"	
}

foreach outcome in cvd eatdis{
copy "projectnumber\cprd_data\final_eventlists\all_eventlists\sbp_smok_alc_bmi_sub_hesapc_`outcome'.dta" "projectnumber\effect_modifiers\incident\eventlist_hesapc_`outcome'.dta"	
}

*****************************************************************

*2b) Loop to rename admidate clinical_eventdate in all extracted eventlists
cd "projectnumber\effect_modifiers\incident\"
ssc install fs
fs "*extraction_hesapc*"
foreach f in `r(files)' {
use "`f'", clear
rename admidate clinical_eventdate
save "`f'", replace
}

*****************************************************************

*2c) Loop to create incident case variable
cd "projectnumber\effect_modifiers\incident\"
foreach outcome in anx cvd dep eatdis selfharm sleep{
	use "extraction_hesapc_`outcome'.dta", clear // open original extraction eventlists
joinby patid using "projectnumber\cprd_data\flow_diagram\final_flow" // cut down to just patids in our study
duplicates drop
bys patid icd (clinical_eventdate):generate clinicaleventdate_n = _n // for each person & icdcode generate an event number
joinby using "eventlist_hesapc_`outcome'", unmatched (using) // join with current eventlist, keeping records in current eventlist without incident data.
gen em_incident_bin =0 // generate variable for incident case
replace em_incident_bin=1 if clinicaleventdate_n ==1 // make 1 if this is the first case of this code for this person.
label define em_incident_bin_lb 1"Yes" 0"No"
label values em_incident_bin em_incident_bin_lb // label the new variable.
drop _merge clinicaleventdate_n
save "projectnumbereffect_modifiers\incident\incident_hesapc_`outcome'", replace
}


****************************************************************************************************************************************
****************************************************************************************************************************************

*3. HES A&E
***********

*3a)Copy files needed into one folder & rename

*Original extraction eventlists
foreach outcome in cvd psy{
copy "projectnumber\cprd_data\HES A&E\extraction\eventlist_`outcome'_diag2_aepatgroup.dta" "projectnumber\effect_modifiers\incident\extraction_hesae_`outcome'.dta"	
}

copy "projectnumber\cprd_data\HES A&E\extraction\eventlist_selfharm_aepatgroup.dta" "projectnumber\effect_modifiers\incident\extraction_hesae_selfharm.dta"	
}

*Current eventlists
foreach outcome in cvd psy selfharm{
copy "projectnumber\cprd_data\final_eventlists\all_eventlists\sbp_smok_alc_bmi_sy_2_hesae_`outcome'.dta" "projectnumber\effect_modifiers\incident\eventlist_hesae_`outcome'.dta"	
}

*3b) Loop to rename arrivaldate clinical_eventdate in all extracted eventlists
cd "projectnumber\effect_modifiers\incident\"
ssc install fs
fs "*extraction_hesae*"
foreach f in `r(files)' {
use "`f'", clear
rename arrivaldate clinical_eventdate
save "`f'", replace
}

*3c) Loop to create incident case variable for selfharm
cd "projectnumber\effect_modifiers\incident\"
use "extraction_hesae_selfharm.dta", clear // open original extraction eventlists
drop aekey
joinby patid using "projectnumber\cprd_data\flow_diagram\final_flow" // cut down to just patids in our study
duplicates drop
bys patid aepatgroup (clinical_eventdate):generate clinicaleventdate_n = _n // for each person & icdcode generate an event number
joinby using "eventlist_hesae_selfharm", unmatched (using) // join with current eventlist, keeping records in current eventlist without incident data.
gen em_incident_bin =0 // generate variable for incident case
replace em_incident_bin=1 if clinicaleventdate_n ==1 // make 1 if this is the first case of this code for this person.
label define em_incident_bin_lb 1"Yes" 0"No"
label values em_incident_bin em_incident_bin_lb // label the new variable.
drop _merge clinicaleventdate_n
save "projectnumber\effect_modifiers\incident\incident_hesae_selfharm", replace



*3d) Loop to create incident case variable for psychological conditions & cvd (need to inc aepatgroup & diag2)
cd "projectnumber\effect_modifiers\incident\"
foreach outcome in cvd psy{
use "extraction_hesae_`outcome'.dta", clear // open original extraction eventlists
drop aekey	
joinby patid using "projectnumber\cprd_data\flow_diagram\final_flow" // cut down to just patids in our study
duplicates drop
bys patid aepatgroup diag2 (clinical_eventdate):generate clinicaleventdate_n = _n // for each person & icdcode generate an event number
joinby using "eventlist_hesae_`outcome'", unmatched (using) // join with current eventlist, keeping records in current eventlist without incident data.
gen em_incident_bin =0 // generate variable for incident case
replace em_incident_bin=1 if clinicaleventdate_n ==1 // make 1 if this is the first case of this code for this person.
label define em_incident_bin_lb 1"Yes" 0"No"
label values em_incident_bin em_incident_bin_lb // label the new variable.
drop _merge clinicaleventdate_n
save "projectnumber\effect_modifiers\incident\incident_hesae_`outcome'", replace
}