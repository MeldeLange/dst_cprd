*dc_13_restrict_age
******************

*1. Generate age at time of clinical event variable
************************************************

*NB All participants have had day of birth inputted as 1. All participants without a month of birth have had month inputted as July.

*a)Primary care
clear
cd "projectnumber\cprd_data\gold_primary_care_all\stata\eventlists\age"
ssc install fs
fs "*eventlist*"
foreach f in `r(files)' {
use `f', clear
gen difference = clinical_eventdate - dob // number of days between dob & event
gen diff_years = difference / 365.25 //turn days into years
gen age = round(diff_years,1.00) // round years (age) to whole number
drop difference diff_years
save "projectnumber\cprd_data\gold_primary_care_all\stata\eventlists\age/`f'", replace
}



*b) HES APC
clear
cd "projectnumber\cprd_data\HES APC data\age"
ssc install fs
fs "*eventlist*"
foreach f in `r(files)' {
use `f', clear
gen difference = admidate - dob // number of days between dob & event
gen diff_years = difference / 365.25 //turn days into years
gen age = round(diff_years,1.00) // round years (age) to whole number
drop difference diff_years
save "`f'", replace
}



*c) HES A&E
clear
cd "projectnumber\cprd_data\HES A&E\age"
ssc install fs
fs "*eventlist*"
foreach f in `r(files)' {
use `f', clear
gen difference = arrivaldate - dob // number of days between dob & event
gen diff_years = difference / 365.25 //turn days into years
gen age = round(diff_years,1.00) // round years (age) to whole number
drop difference diff_years
save "`f'", replace
}



***************************************************************************


*2. Cut down to only those events where the person is in the correct age range at the time of the event.
******************************************************************************************************
*>=10 for depression, anxiety, sleep, self-harm & eating disorders
*All ages for road traffic injuries. (don't need to cut down)
*>=40 for cardiovascular disease.


*a)Primary care
****************
*Mental health outcomes (<=10)
clear
cd "projectnumber\cprd_data\gold_primary_care_all\stata\eventlists\age"
ssc install fs
fs "*anx*" "*dep*" "*sleep*" "*selfharm*" "*eatdis*"
foreach f in `r(files)' {
use `f', clear
keep if age >=10
save "age_`f'", replace
}


*CVD
clear
cd "projectnumber\cprd_data\gold_primary_care_all\stata\eventlists\age"
ssc install fs
use patient_validgp_clock_eventlist_med_cvd.dta, clear
keep if age >=40
save "age_patient_validgp_clock_eventlist_med_cvd.dta", replace

*b) HES APC
****************
*Mental health outcomes (<=10)
clear
cd "projectnumber\cprd_data\HES APC data\age"
ssc install fs
fs "*anx*" "*dep*" "*sleep*" "*selfharm*" "*eatdis*"
foreach f in `r(files)' {
use `f', clear
keep if age >=10
save "age_`f'", replace
}

*CVD
clear
cd "projectnumber\cprd_data\HES APC data\age"
ssc install fs
use patient_clock_eventlist_icd10_cvd.dta, clear
keep if age >=40
save "age_patient_clock_eventlist_icd10_cvd.dta", replace

*c) HES A&E 
*************
*Mental health outcomes (<=10)
clear
cd "projectnumber\cprd_data\HES A&E\age"
ssc install fs
fs "*psy*" "*selfharm*"
foreach f in `r(files)' {
use `f', clear
keep if age >=10
save "age_`f'", replace
}

*CVD
clear
cd "projectnumber\cprd_data\HES A&E\age"
use patient_clock_eventlist_cvd_diag2_aepatgroup.dta, clear
keep if age >=40
save "age_patient_clock_eventlist_cvd_diag2_aepatgroup.dta", replace

**********************************************************************************

*3. Save final eventlists in one folder & rename files

*a)Copy & rename primary care files

*Anxiety
copy "projectnumber\cprd_data\gold_primary_care_all\stata\eventlists\age\age_patient_validgp_clock_eventlist_anx_combined.dta" "projectnumber\cprd_data\final_eventlists\primary_care\pc_anx.dta"

*Depression
copy "projectnumber\cprd_data\gold_primary_care_all\stata\eventlists\age\age_patient_validgp_clock_eventlist_dep_combined.dta" "projectnumber\cprd_data\final_eventlists\primary_care\pc_dep.dta"

*CVD
copy "projectnumber\cprd_data\gold_primary_care_all\stata\eventlists\age\age_patient_validgp_clock_eventlist_med_cvd.dta" "\\ads.bris.ac.uk\filestore\HealthSci SafeHaven\CPRD Projects UOB\Projects\22_002468\cprd_data\final_eventlists\primary_care\pc_cvd.dta"

*Eatdis
copy "projectnumber\cprd_data\gold_primary_care_all\stata\eventlists\age\age_patient_validgp_clock_eventlist_med_eatdis.dta" "\\ads.bris.ac.uk\filestore\HealthSci SafeHaven\CPRD Projects UOB\Projects\22_002468\cprd_data\final_eventlists\primary_care\pc_eatdis.dta"

*Sleep
copy "projectnumber\cprd_data\gold_primary_care_all\stata\eventlists\age\age_patient_validgp_clock_eventlist_med_prod_sleep.dta" "\\ads.bris.ac.uk\filestore\HealthSci SafeHaven\CPRD Projects UOB\Projects\22_002468\cprd_data\final_eventlists\primary_care\pc_sleep.dta"

*Selfharm
copy "projectnumber\cprd_data\gold_primary_care_all\stata\eventlists\age\age_patient_validgp_clock_eventlist_med_selfharm.dta" "\\ads.bris.ac.uk\filestore\HealthSci SafeHaven\CPRD Projects UOB\Projects\22_002468\cprd_data\final_eventlists\primary_care\pc_selfharm.dta"

*RTIs
copy "projectnumber\cprd_data\gold_primary_care_all\stata\eventlists\age\patient_validgp_clock_eventlist_med_rti.dta" "\\ads.bris.ac.uk\filestore\HealthSci SafeHaven\CPRD Projects UOB\Projects\22_002468\cprd_data\final_eventlists\primary_care\pc_rti.dta"

****************************************

*b)Copy & rename HES APC files
********************************

*Anxiety
copy "projectnumber\cprd_data\HES APC data\age\age_patient_clock_eventlist_icd10_anx.dta" "\\ads.bris.ac.uk\filestore\HealthSci SafeHaven\CPRD Projects UOB\Projects\22_002468\cprd_data\final_eventlists\hes_apc\hesapc_anx.dta"

*Depression
copy "projectnumber\cprd_data\HES APC data\age\age_patient_clock_eventlist_icd10_dep.dta" "\\ads.bris.ac.uk\filestore\HealthSci SafeHaven\CPRD Projects UOB\Projects\22_002468\cprd_data\final_eventlists\hes_apc\hesapc_dep.dta"

*CVD
copy "projectnumber\cprd_data\HES APC data\age\age_patient_clock_eventlist_icd10_cvd.dta" "\\ads.bris.ac.uk\filestore\HealthSci SafeHaven\CPRD Projects UOB\Projects\22_002468\cprd_data\final_eventlists\hes_apc\hesapc_cvd.dta"

*eatdis
copy "projectnumber\cprd_data\HES APC data\age\age_patient_clock_eventlist_icd10_eatdis.dta" "\\ads.bris.ac.uk\filestore\HealthSci SafeHaven\CPRD Projects UOB\Projects\22_002468\cprd_data\final_eventlists\hes_apc\hesapc_eatdis.dta"

*seflharm
copy "projectnumber\22_002468\cprd_data\HES APC data\age\age_patient_clock_eventlist_icd10_selfharm.dta" "\\ads.bris.ac.uk\filestore\HealthSci SafeHaven\CPRD Projects UOB\Projects\22_002468\cprd_data\final_eventlists\hes_apc\hesapc_selfharm.dta"

*sleep
copy "projectnumber\cprd_data\HES APC data\age\age_patient_clock_eventlist_icd10_sleep.dta" "\\ads.bris.ac.uk\filestore\HealthSci SafeHaven\CPRD Projects UOB\Projects\22_002468\cprd_data\final_eventlists\hes_apc\hesapc_sleep.dta"

*RTIs
copy "projectnumber\cprd_data\HES APC data\age\patient_clock_eventlist_icd10_rti.dta" "\\ads.bris.ac.uk\filestore\HealthSci SafeHaven\CPRD Projects UOB\Projects\22_002468\cprd_data\final_eventlists\hes_apc\hesapc_rti.dta"


****************************************************************
*c)Copy & rename HES A&E files

********************************
*CVD
copy "projectnumber\cprd_data\HES A&E\age\age_patient_clock_eventlist_cvd_diag2_aepatgroup.dta" "projectnumber\cprd_data\final_eventlists\hes_ae\hesae_cvd.dta"

*Psych conditions
copy "projectnumber\cprd_data\HES A&E\age\age_patient_clock_eventlist_psy_diag2_aepatgroup.dta" "projectnumber\cprd_data\final_eventlists\hes_ae\hesae_psy.dta"

*Selfharm
copy "projectnumber\cprd_data\HES A&E\age\age_patient_clock_eventlist_selfharm_aepatgroup.dta" "projectnumber\cprd_data\final_eventlists\hes_ae\hesae_selfharm.dta"

*RTIs
copy "projectnumber\cprd_data\HES A&E\age\patient_clock_eventlist_rti_aepatgroup.dta" "projectnumber\cprd_data\final_eventlists\hes_ae\hesae_rti.dta"
