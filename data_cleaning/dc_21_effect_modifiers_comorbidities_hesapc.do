*dc_21_effect_modifiers_comorbidities_hesapc
**********************************************

*Up-to-date eventlists:

*Road traffic injuries (weren't included in incident/prevalent cleaning)
cd "projectfolder\cprd_data\final_eventlists\all_eventlists"
*sbp_smok_alc_bmi_sy_2_pc_rti
*sbp_smok_alc_bmi_sy_2_hesapc_rti
*sbp_smok_alc_bmi_sy_2_hesae_rti

*The rest:
cd "projectfolder\effect_modifiers\incident"
*incident_hesae_cvd
*incident_hesae_psy
*incident_hesae_selfharm

*incident_hesapc_anx
*incident_hesapc_cvd
*incident_hesapc_dep
*incident_hesapc_eatdis
*incident_hesapc_selfharm
*incident_hesapc_sleep

*incident_pc_anx
*incident_pc_cvd
*incident_pc_dep
*incident_pc_eatdis
*incident_pc_selfharm
*incident_pc_sleep

*******************************************************************************************************

*Take original cleaned GP (inc prescriptions)/ HES APC data.
*Cut down to patids of people in our study.
*Merge each comorbidity codelist (x14 x 2 + product ones) with hes apc/GP data.
*Keep patid date_smi cm_smi etc.
*Joinby with pc, hesapc & hesae eventlists based on patid. Only keep comorbidity vars that are comordities for that outcome.
*change indicator to 0 if comorbid date is => clinical eventdate.


*1. Prepare HES APC comorbidities eventlists
**************************************************

*1a) Copy original hes apc data to hesapc comorbidities folder
copy "projectfolder\cprd_data\HES APC data\hes_apc.dta" "projectfolder\effect_modifiers\comorbidities\hesapc\"


*1b) Cut down original HES APC data to just those in our study.
cd "projectfolder"
use "effect_modifiers\comorbidities\hesapc\hes_apc.dta", clear
joinby patid using "cprd_data\flow_diagram\final_flow" // cut down to just patids in our study (goes from 54m to 35m obs.)
duplicates drop // (58,187 observations deleted)
save "effect_modifiers\comorbidities\hesapc\hes_apc_studypop.dta", replace // File with HES APC data for everyone in our study.

*1c) Join each HES APC comorbidity codelist with the hes_apc study population to create a list of study participants with the comorbidty in their HES APC record & the date of their first comorbidity event.
clear
cd "projectfolder\effect_modifiers\comorbidities\hesapc\comorb_codelists"
fs "apc*.dta"
foreach f in `r(files)' {
use `f', clear
joinby icd using "projectfolder\effect_modifiers\comorbidities\hesapc\hes_apc_studypop.dta"
rename admidate comorb_date 
rename icd comorb_icd
bys patid (comorb_date): generate comorb_date_n = _n // order comorbidity events for each person. (individual icd code doesn't matter)
keep if comorb_date_n ==1 // Only keep the first event (earliest one) for each person as we just want to know if they have *any* of these comorbidity codes *before* the event date. This gives us an individual-level file.
drop comorb_date_n
drop comorb_icd // We just need patid & earliest comorbidity date.
save "projectfolder\effect_modifiers\comorbidities\hesapc\comorblist_`f'", replace
}


*1d) Rename comorb_date variable with name of comorbidity
clear
cd "projectfolder\effect_modifiers\comorbidities\hesapc"
foreach comorbidity in anx asthma_copd cancer ckd dementia dep diabetes hyperlipid hypertens majorphys majorphys_ment sleep smi substance{
	use "comorblist_apc_`comorbidity'.dta"
	rename comorb_date comorb_`comorbidity'_date
	save, replace
}

**************************************************************************
*2. Merge hesapc comorbidity eventlists with study outcome eventlists (HES APC, HES A&E and GP) & create indicator variables for comorbidities



*2a) HES APC outcome eventlists

*CVD
cd "projectfolder\effect_modifiers"
use incident\incident_hesapc_cvd.dta, clear
foreach comorb in hypertens hyperlipid diabetes ckd asthma_copd cancer smi{
	merge m:1 patid using "projectfolder\effect_modifiers\comorbidities\hesapc\comorblist_apc_`comorb'.dta"
	drop if _merge ==2
gen comorb_`comorb' =0
replace comorb_`comorb'=1 if _merge ==3 // Create indicator variable for that comorbidity based on _merge variable
replace comorb_`comorb'=0 if comorb_`comorb'_date > clinical_eventdate // Change indicator variable to 0 if comorbidity date is after the clinical eventdate.
drop _merge
drop comorb*date
}
save "projectfolder\cprd_data\final_eventlists\eventlists_with_comorbidities\hesapc_cvd_comorb.dta", replace

*Depression
cd "projectfolder\effect_modifiers"
use incident\incident_hesapc_dep.dta, clear
foreach comorb in anx sleep substance majorphys{
	merge m:1 patid using "projectfolder\effect_modifiers\comorbidities\hesapc\comorblist_apc_`comorb'.dta"
	drop if _merge ==2
gen comorb_`comorb' =0
replace comorb_`comorb'=1 if _merge ==3 // Create indicator variable for that comorbidity based on _merge variable
replace comorb_`comorb'=0 if comorb_`comorb'_date > clinical_eventdate // Change indicator variable to 0 if comorbidity date is after the clinical eventdate.
drop _merge
drop comorb*date
}
save "projectfolder\cprd_data\final_eventlists\eventlists_with_comorbidities\hesapc_dep_comorb.dta", replace

*RTIs
cd "projectfolder\cprd_data\final_eventlists\all_eventlists"
use sbp_smok_alc_bmi_sy_2_hesapc_rti.dta, clear
foreach comorb in sleep substance majorphys_ment{
	merge m:1 patid using "projectfolder\effect_modifiers\comorbidities\hesapc\comorblist_apc_`comorb'.dta"
	drop if _merge ==2
gen comorb_`comorb' =0
replace comorb_`comorb'=1 if _merge ==3 // Create indicator variable for that comorbidity based on _merge variable
replace comorb_`comorb'=0 if comorb_`comorb'_date > clinical_eventdate // Change indicator variable to 0 if comorbidity date is after the clinical eventdate.
drop _merge
drop comorb*date
}
save "projectfolder\cprd_data\final_eventlists\eventlists_with_comorbidities\hesapc_rti_comorb.dta", replace

*Anxiety
cd "projectfolder\effect_modifiers"
use incident\incident_hesapc_anx.dta, clear
foreach comorb in dep sleep majorphys {
merge m:1 patid using "projectfolder\effect_modifiers\comorbidities\hesapc\comorblist_apc_`comorb'.dta"
	drop if _merge ==2
gen comorb_`comorb' =0
replace comorb_`comorb'=1 if _merge ==3 // Create indicator variable for that comorbidity based on _merge variable
replace comorb_`comorb'=0 if comorb_`comorb'_date > clinical_eventdate // Change indicator variable to 0 if comorbidity date is after the clinical eventdate.
drop _merge
drop comorb*date
}
save "projectfolder\cprd_data\final_eventlists\eventlists_with_comorbidities\hesapc_anx_comorb.dta", replace


*Sleep disorders
cd "projectfolder\effect_modifiers"
use incident\incident_hesapc_sleep.dta, clear
foreach comorb in anx dep dementia majorphys{
merge m:1 patid using "projectfolder\effect_modifiers\comorbidities\hesapc\comorblist_apc_`comorb'.dta"
	drop if _merge ==2
gen comorb_`comorb' =0
replace comorb_`comorb'=1 if _merge ==3 // Create indicator variable for that comorbidity based on _merge variable
replace comorb_`comorb'=0 if comorb_`comorb'_date > clinical_eventdate // Change indicator variable to 0 if comorbidity date is after the clinical eventdate.
drop _merge
drop comorb*date
}
save "projectfolder\final_eventlists\eventlists_with_comorbidities\hesapc_sleep_comorb.dta", replace


*Eating disorders
cd "projectfolder\effect_modifiers"
use incident\incident_hesapc_eatdis.dta, clear
foreach comorb in anx dep{
merge m:1 patid using "projectfolder\effect_modifiers\comorbidities\hesapc\comorblist_apc_`comorb'.dta"
	drop if _merge ==2
gen comorb_`comorb' =0
replace comorb_`comorb'=1 if _merge ==3 // Create indicator variable for that comorbidity based on _merge variable
replace comorb_`comorb'=0 if comorb_`comorb'_date > clinical_eventdate // Change indicator variable to 0 if comorbidity date is after the clinical eventdate.
drop _merge
drop comorb*date
}
save "projectfolder\cprd_data\final_eventlists\eventlists_with_comorbidities\hesapc_eatdis_comorb.dta", replace


*Self harm
cd "projectfolder\effect_modifiers"
use incident\incident_hesapc_selfharm.dta, clear
foreach comorb in anx dep substance {
merge m:1 patid using "projectfolder\effect_modifiers\comorbidities\hesapc\comorblist_apc_`comorb'.dta"
	drop if _merge ==2
gen comorb_`comorb' =0
replace comorb_`comorb'=1 if _merge ==3 // Create indicator variable for that comorbidity based on _merge variable
replace comorb_`comorb'=0 if comorb_`comorb'_date > clinical_eventdate // Change indicator variable to 0 if comorbidity date is after the clinical eventdate.
drop _merge
drop comorb*date
}
save "projectfolder\cprd_data\final_eventlists\eventlists_with_comorbidities\hesapc_selfharm_comorb.dta", replace

***************************************

*2b) HES A&E outcome eventlists


*CVD
cd "projectfolder\effect_modifiers"
use incident\incident_hesae_cvd.dta, clear
foreach comorb in hypertens hyperlipid diabetes ckd asthma_copd cancer smi{
	merge m:1 patid using "projectfolder\effect_modifiers\comorbidities\hesapc\comorblist_apc_`comorb'.dta"
	drop if _merge ==2
gen comorb_`comorb' =0
replace comorb_`comorb'=1 if _merge ==3 // Create indicator variable for that comorbidity based on _merge variable
replace comorb_`comorb'=0 if comorb_`comorb'_date > clinical_eventdate // Change indicator variable to 0 if comorbidity date is after the clinical eventdate.
drop _merge
drop comorb*date
}
save "projectfolder\cprd_data\final_eventlists\eventlists_with_comorbidities\hesae_cvd_comorb.dta", replace

*Self harm
cd "projectfolder\effect_modifiers"
use incident\incident_hesae_selfharm.dta, clear
foreach comorb in anx dep substance {
merge m:1 patid using "projectfolder\effect_modifiers\comorbidities\hesapc\comorblist_apc_`comorb'.dta"
	drop if _merge ==2
gen comorb_`comorb' =0
replace comorb_`comorb'=1 if _merge ==3 // Create indicator variable for that comorbidity based on _merge variable
replace comorb_`comorb'=0 if comorb_`comorb'_date > clinical_eventdate // Change indicator variable to 0 if comorbidity date is after the clinical eventdate.
drop _merge
drop comorb*date
}
save "projectfolder\cprd_data\final_eventlists\eventlists_with_comorbidities\hesae_selfharm_comorb.dta", replace


*Psychological conditions
cd "projectfolder\effect_modifiers"
use incident\incident_hesae_psy.dta, clear
foreach comorb in substance sleep majorphys{
merge m:1 patid using "projectfolder\effect_modifiers\comorbidities\hesapc\comorblist_apc_`comorb'.dta"
	drop if _merge ==2
gen comorb_`comorb' =0
replace comorb_`comorb'=1 if _merge ==3 // Create indicator variable for that comorbidity based on _merge variable
replace comorb_`comorb'=0 if comorb_`comorb'_date > clinical_eventdate // Change indicator variable to 0 if comorbidity date is after the clinical eventdate.
drop _merge
drop comorb*date
}
save "projectfolder\cprd_data\final_eventlists\eventlists_with_comorbidities\hesae_psy_comorb.dta", replace



*RTIs
cd "projectfolder\cprd_data\final_eventlists\all_eventlists"
use sbp_smok_alc_bmi_sy_2_hesae_rti.dta, clear
foreach comorb in sleep substance majorphys_ment{
	merge m:1 patid using "projectfolder\effect_modifiers\comorbidities\hesapc\comorblist_apc_`comorb'.dta"
	drop if _merge ==2
gen comorb_`comorb' =0
replace comorb_`comorb'=1 if _merge ==3 // Create indicator variable for that comorbidity based on _merge variable
replace comorb_`comorb'=0 if comorb_`comorb'_date > clinical_eventdate // Change indicator variable to 0 if comorbidity date is after the clinical eventdate.
drop _merge
drop comorb*date
}
save "projectfolder\cprd_data\final_eventlists\eventlists_with_comorbidities\hesae_rti_comorb.dta", replace


**********************************

*2c) Primary care outcome eventlists

*CVD
cd "projectfolder\effect_modifiers"
use incident\incident_pc_cvd.dta, clear
foreach comorb in hypertens hyperlipid diabetes ckd asthma_copd cancer smi{
	merge m:1 patid using "projectfolder\effect_modifiers\comorbidities\hesapc\comorblist_apc_`comorb'.dta"
	drop if _merge ==2
gen comorb_`comorb' =0
replace comorb_`comorb'=1 if _merge ==3 // Create indicator variable for that comorbidity based on _merge variable
replace comorb_`comorb'=0 if comorb_`comorb'_date > clinical_eventdate // Change indicator variable to 0 if comorbidity date is after the clinical eventdate.
drop _merge
drop comorb*date
}
save "projectfolder\cprd_data\final_eventlists\eventlists_with_comorbidities\pc_cvd_comorb.dta", replace


*Depression
cd "projectfolder\effect_modifiers"
use incident\incident_pc_dep.dta, clear
foreach comorb in anx sleep substance majorphys{
	merge m:1 patid using "projectfolder\effect_modifiers\comorbidities\hesapc\comorblist_apc_`comorb'.dta"
	drop if _merge ==2
gen comorb_`comorb' =0
replace comorb_`comorb'=1 if _merge ==3 // Create indicator variable for that comorbidity based on _merge variable
replace comorb_`comorb'=0 if comorb_`comorb'_date > clinical_eventdate // Change indicator variable to 0 if comorbidity date is after the clinical eventdate.
drop _merge
drop comorb*date
}
save "projectfolder\cprd_data\final_eventlists\eventlists_with_comorbidities\pc_dep_comorb.dta", replace

*RTIs
cd "projectfolder\cprd_data\final_eventlists\all_eventlists"
use sbp_smok_alc_bmi_sy_2_pc_rti.dta, clear
foreach comorb in sleep substance majorphys_ment{
	merge m:1 patid using "projectfolder\effect_modifiers\comorbidities\hesapc\comorblist_apc_`comorb'.dta"
	drop if _merge ==2
gen comorb_`comorb' =0
replace comorb_`comorb'=1 if _merge ==3 // Create indicator variable for that comorbidity based on _merge variable
replace comorb_`comorb'=0 if comorb_`comorb'_date > clinical_eventdate // Change indicator variable to 0 if comorbidity date is after the clinical eventdate.
drop _merge
drop comorb*date
}
save "projectfolder\cprd_data\final_eventlists\eventlists_with_comorbidities\pc_rti_comorb.dta", replace

*Anxiety
cd "projectfolder\effect_modifiers"
use incident\incident_pc_anx.dta, clear
foreach comorb in dep sleep majorphys {
merge m:1 patid using "projectfolder\effect_modifiers\comorbidities\hesapc\comorblist_apc_`comorb'.dta"
	drop if _merge ==2
gen comorb_`comorb' =0
replace comorb_`comorb'=1 if _merge ==3 // Create indicator variable for that comorbidity based on _merge variable
replace comorb_`comorb'=0 if comorb_`comorb'_date > clinical_eventdate // Change indicator variable to 0 if comorbidity date is after the clinical eventdate.
drop _merge
drop comorb*date
}
save "projectfolder\cprd_data\final_eventlists\eventlists_with_comorbidities\pc_anx_comorb.dta", replace


*Sleep disorders
cd "projectfolder\effect_modifiers"
use incident\incident_pc_sleep.dta, clear
foreach comorb in anx dep dementia majorphys{
merge m:1 patid using "projectfolder\effect_modifiers\comorbidities\hesapc\comorblist_apc_`comorb'.dta"
	drop if _merge ==2
gen comorb_`comorb' =0
replace comorb_`comorb'=1 if _merge ==3 // Create indicator variable for that comorbidity based on _merge variable
replace comorb_`comorb'=0 if comorb_`comorb'_date > clinical_eventdate // Change indicator variable to 0 if comorbidity date is after the clinical eventdate.
drop _merge
drop comorb*date
}
save "projectfolder\cprd_data\final_eventlists\eventlists_with_comorbidities\pc_sleep_comorb.dta", replace

*Eating disorders
cd "projectfolder\effect_modifiers"
use incident\incident_pc_eatdis.dta, clear
foreach comorb in anx dep{
merge m:1 patid using "projectfolder\effect_modifiers\comorbidities\hesapc\comorblist_apc_`comorb'.dta"
	drop if _merge ==2
gen comorb_`comorb' =0
replace comorb_`comorb'=1 if _merge ==3 // Create indicator variable for that comorbidity based on _merge variable
replace comorb_`comorb'=0 if comorb_`comorb'_date > clinical_eventdate // Change indicator variable to 0 if comorbidity date is after the clinical eventdate.
drop _merge
drop comorb*date
}
save "projectfolder\cprd_data\final_eventlists\eventlists_with_comorbidities\pc_eatdis_comorb.dta", replace

*Self harm
cd "projectfolder\effect_modifiers"
use incident\incident_pc_selfharm.dta, clear
foreach comorb in anx dep substance {
merge m:1 patid using "projectfolder\effect_modifiers\comorbidities\hesapc\comorblist_apc_`comorb'.dta"
	drop if _merge ==2
gen comorb_`comorb' =0
replace comorb_`comorb'=1 if _merge ==3 // Create indicator variable for that comorbidity based on _merge variable
replace comorb_`comorb'=0 if comorb_`comorb'_date > clinical_eventdate // Change indicator variable to 0 if comorbidity date is after the clinical eventdate.
drop _merge
drop comorb*date
}
save "projectfolder\cprd_data\final_eventlists\eventlists_with_comorbidities\pc_selfharm_comorb.dta", replace

