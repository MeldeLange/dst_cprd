*dc_19_effect modifiers_additional2
***********************************

*Merge effect modifiers from additional files (BMI, alcohol, smoking, systolic blood pressure) with eventlists to get measurement closest to outcome eventdate
*************************************************************************************************************************************************************
*We want measurements before the outcome event date and if there is more than one measurement we want the one closest to the event date.



*1. Set up folders & naming of outcome event date variables
*1a) Copy all files into one folder

*Primary care cvd & eatdis
foreach outcome in cvd eatdis {
copy "projectnumber\cprd_data\final_eventlists\primary_care\sub_pc_`outcome'.dta" "projectnumber\cprd_data\final_eventlists\all_eventlists\"		
}
*Primary care anxiety, depression, rti, selfharm, sleep
foreach outcome in anx dep rti selfharm sleep {
copy "projectnumber\cprd_data\final_eventlists\primary_care\sy_2_pc_`outcome'.dta" "\\projectnumber\cprd_data\final_eventlists\all_eventlists\"
}
*HES APC cvd & eatdis
foreach outcome in cvd eatdis {
copy "projectnumber\cprd_data\final_eventlists\hes_apc\sub_hesapc_`outcome'.dta" "projectnumber\cprd_data\final_eventlists\all_eventlists\"		
}
*HES APC anxiety, depression, rti, selfharm, sleep
foreach outcome in anx dep rti selfharm sleep {
copy "projectnumber\cprd_data\final_eventlists\hes_apc\sy_2_hesapc_`outcome'.dta" "projectnumber\cprd_data\final_eventlists\all_eventlists\"
}
*HES A&E cvd, psyc condits, rti, selfharm
foreach outcome in cvd psy rti selfharm {
copy "projectnumber\cprd_data\final_eventlists\hes_ae\sy_2_hesae_`outcome'.dta" "projectnumber\cprd_data\final_eventlists\all_eventlists\"
}

*1b) *Rename admidate and arrivaldate in HES APC and HES A&E data to be clinical_eventdate to match the primary care data
cd "projectnumber\cprd_data\final_eventlists\all_eventlists"
ssc install fs
fs "*hesapc*"
foreach f in `r(files)' {
use "`f'", clear
rename admidate clinical_eventdate
save "`f'", replace
}

cd "projectnumber\cprd_data\final_eventlists\all_eventlists"
ssc install fs
fs "*hesae*"
foreach f in `r(files)' {
use "`f'", clear
rename arrivaldate clinical_eventdate
save "`f'", replace
}

*************************************************************

*2. BMI
cd "projectnumber\cprd_data\final_eventlists\all_eventlists"
ssc install fs
fs "*.dta"
foreach f in `r(files)' {
use "`f'", clear
keep patid clinical_eventdate
duplicates drop
joinby patid using "projectnumber\effect_modifiers\additional\bmi_eventdate" 
drop adid
drop if bmi_eventdate ==. // drop if there isn't a date for the BMI measurement
drop if bmi_eventdate > clinical_eventdate //drop records if the BMI was measured after the outcome event.
bys patid clinical_eventdate (bmi_eventdate) : generate bmieventdate_n = _n // sort according to patid, clinical eventdate & bmi eventdate. Generate var with number of bmi records for each person.
by patid clinical_eventdate (bmi_eventdate) : drop if _n !=_N // drop records except those with the latest bmi date for each person.
drop bmi_eventdate bmieventdate_n
joinby patid clinical_eventdate using "projectnumber\cprd_data\final_eventlists\all_eventlists/`f'", unmatched(using)
drop _merge
save "bmi_`f'", replace
}

*************************************************************

*3. Alcohol
cd "projectnumber\cprd_data\final_eventlists\all_eventlists"
ssc install fs
fs "bmi*"
foreach f in `r(files)' {
use "`f'", clear
keep patid clinical_eventdate
duplicates drop
joinby patid using "projectnumber\effect_modifiers\additional\alc_eventdate" 
drop adid
drop if alc_eventdate ==. // drop if there isn't a date for the alc measurement
drop if alc_eventdate > clinical_eventdate //drop records if the alc was measured after the outcome event.
bys patid clinical_eventdate (alc_eventdate) : generate alceventdate_n = _n // sort according to patid, clinical eventdate & alc eventdate. Generate var with number of alcohol records for each person.
by patid clinical_eventdate (alc_eventdate) : drop if _n !=_N // drop records except those with the latest alc date for each person.
drop alc_eventdate alceventdate_n
joinby patid clinical_eventdate using "projectnumber8\cprd_data\final_eventlists\all_eventlists/`f'", unmatched(using)
drop _merge
save "alc_`f'", replace
}

*************************************************************

*4. Smoking
cd "projectnumber\cprd_data\final_eventlists\all_eventlists"
ssc install fs
fs "alc*"
foreach f in `r(files)' {
use "`f'", clear
keep patid clinical_eventdate
duplicates drop
joinby patid using "projectnumber\effect_modifiers\additional\smok_eventdate" 
drop adid
drop if smok_eventdate ==. // drop if there isn't a date for the smok measurement
drop if smok_eventdate > clinical_eventdate //drop records if the smok was measured after the outcome event.
bys patid clinical_eventdate (smok_eventdate) : generate smokeventdate_n = _n // sort according to patid, clinical eventdate & smok eventdate. Generate var with number of smok records for each person.
by patid clinical_eventdate (smok_eventdate) : drop if _n !=_N // drop records except those with the latest smok date for each person.
drop smok_eventdate smokeventdate_n
joinby patid clinical_eventdate using "projectnumber\cprd_data\final_eventlists\all_eventlists/`f'", unmatched(using)
drop _merge
save "smok_`f'", replace
}

*Fix previous error in labelling of smoking variable (the labels hadn't been applied)
cd "projectnumber\cprd_data\final_eventlists\all_eventlists"
ssc install fs
fs "smok*"
foreach f in `r(files)' {
use "`f'", clear
label define em_smok_bin_lb 1"Current" 2"Non/Ex"
label values em_smok_bin em_smok_bin_lb
save "`f'", replace
}


*************************************************************
*5. Blood pressure
cd "projectnumber\cprd_data\final_eventlists\all_eventlists"
ssc install fs
fs "smok*"
foreach f in `r(files)' {
use "`f'", clear
keep patid clinical_eventdate
duplicates drop
joinby patid using "projectnumber\effect_modifiers\additional\sbp_eventdate" 
drop adid
drop if sbp_eventdate ==. // drop if there isn't a date for the sbp measurement
drop if sbp_eventdate > clinical_eventdate //drop records if the sbp was measured after the outcome event.
bys patid clinical_eventdate (sbp_eventdate) : generate sbpeventdate_n = _n // sort according to patid, clinical eventdate & sbp eventdate. Generate var with number of sbp records for each person.
by patid clinical_eventdate (sbp_eventdate) : drop if _n !=_N // drop records except those with the latest sbp date for each person.
drop sbp_eventdate sbpeventdate_n
joinby patid clinical_eventdate using "projectnumber\cprd_data\final_eventlists\all_eventlists/`f'", unmatched(using)
drop _merge
save "sbp_`f'", replace
}