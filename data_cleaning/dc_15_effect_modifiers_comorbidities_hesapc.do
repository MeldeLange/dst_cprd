*dc_15_effect_modifiers_comorbidities_hesapc
***********************************************

*Mel de Lange
*18.10.2024

*1. Prepare HES APC comorbidities eventlists
**************************************************

*1a) Copy original hes apc data to hesapc comorbidities folder
copy "projectnumber\cprd_data\HES APC data\hes_apc.dta" "projectfolder\effect_modifiers\comorbidities\hesapc\"

*1b) Join each HES APC comorbidity codelist with the original hes_apc study population to create a list of people with the comorbidty in their HES APC record & the date of their first comorbidity event.
clear
cd "projectnumber\effect_modifiers\comorbidities\hesapc\comorb_codelists"
fs "apc*.dta"
foreach f in `r(files)' {
use `f', clear
joinby icd using "projectnumber\effect_modifiers\comorbidities\hesapc\hes_apc.dta"
rename admidate comorb_date 
rename icd comorb_eventcode
bys patid (comorb_date): generate comorb_date_n = _n // order comorbidity events for each person by date. (individual eventcode doesn't matter)
keep if comorb_date_n ==1 // Only keep the first event (earliest one) for each person as we just want to know if they have *any* of these comorbidity codes *before* the clock change date. This gives us an individual-level file.
drop comorb_date_n
drop comorb_eventcode // We just need patid & earliest comorbidity date.
save "projectnumber\effect_modifiers\comorbidities\hesapc\comorblist_`f'", replace
}


*1c) Rename comorb_date variable with name of comorbidity
clear
cd "projectnumber\effect_modifiers\comorbidities\hesapc"
foreach comorbidity in anx asthma_copd cancer ckd dementia dep diabetes hyperlipid hypertens majorphys majorphys_ment sleep smi substance{
	use "comorblist_apc_`comorbidity'.dta", clear
	rename comorb_date comorb_`comorbidity'_date
	save, replace
}

*********************************************************************************************************************

*2. Merge hesapc comorbidity eventlists with study outcome eventlists & create indicator variables for comorbidities

*2a)CVD
cd "projectnumber\cprd_data\combined\combined_eventlists"
use eventlist_cvd_12.dta, clear
foreach comorb in hypertens hyperlipid diabetes ckd asthma_copd cancer smi{
	merge m:1 patid using "projectnumber\effect_modifiers\comorbidities\hesapc\comorblist_apc_`comorb'.dta"
	drop if _merge ==2
gen comorb_`comorb' =0
replace comorb_`comorb'=1 if _merge ==3 // Create indicator variable for that comorbidity based on _merge variable
replace comorb_`comorb'=0 if comorb_`comorb'_date > date_clockchange // Change indicator variable to 0 if comorbidity date is after the date of the clock change.
drop _merge
drop comorb*date
}
save "projectnumber\cprd_data\combined\combined_eventlists\eventlist_cvd_13.dta", replace


*******************

*2b)Depression

cd "projectnumber\cprd_data\combined\combined_eventlists"
use eventlist_dep_12.dta, clear
foreach comorb in anx sleep substance majorphys{
	merge m:1 patid using "projectnumber\effect_modifiers\comorbidities\hesapc\comorblist_apc_`comorb'.dta"
	drop if _merge ==2
gen comorb_`comorb' =0
replace comorb_`comorb'=1 if _merge ==3 // Create indicator variable for that comorbidity based on _merge variable
replace comorb_`comorb'=0 if comorb_`comorb'_date > date_clockchange // Change indicator variable to 0 if comorbidity date is after the date of the clock change.
drop _merge
drop comorb*date
}
save "projectnumber\cprd_data\combined\combined_eventlists\eventlist_dep_13.dta", replace



*******************

*2c)RTIs

cd "projectnumber\cprd_data\combined\combined_eventlists"
use eventlist_rti_12.dta, clear
foreach comorb in sleep substance majorphys_ment{
	merge m:1 patid using "projectnumber\effect_modifiers\comorbidities\hesapc\comorblist_apc_`comorb'.dta"
	drop if _merge ==2
gen comorb_`comorb' =0
replace comorb_`comorb'=1 if _merge ==3 // Create indicator variable for that comorbidity based on _merge variable
replace comorb_`comorb'=0 if comorb_`comorb'_date > date_clockchange // Change indicator variable to 0 if comorbidity date is after the date of the clock change.
drop _merge
drop comorb*date
}
save "projectnumber\cprd_data\combined\combined_eventlists\eventlist_rti_13.dta", replace

*******************

*2d)Anxiety

cd "projectnumber\cprd_data\combined\combined_eventlists"
use eventlist_anx_12.dta, clear
foreach comorb in dep sleep majorphys {
	merge m:1 patid using "projectnumber\effect_modifiers\comorbidities\hesapc\comorblist_apc_`comorb'.dta"
	drop if _merge ==2
gen comorb_`comorb' =0
replace comorb_`comorb'=1 if _merge ==3 // Create indicator variable for that comorbidity based on _merge variable
replace comorb_`comorb'=0 if comorb_`comorb'_date > date_clockchange // Change indicator variable to 0 if comorbidity date is after the date of the clock change.
drop _merge
drop comorb*date
}
save "projectnumber\cprd_data\combined\combined_eventlists\eventlist_anx_13.dta", replace


*******************

*2e) Sleep disorders

cd "projectnumber\cprd_data\combined\combined_eventlists"
use eventlist_sleep_12.dta, clear
foreach comorb in anx dep dementia majorphys{
	merge m:1 patid using "projectnumber\effect_modifiers\comorbidities\hesapc\comorblist_apc_`comorb'.dta"
	drop if _merge ==2
gen comorb_`comorb' =0
replace comorb_`comorb'=1 if _merge ==3 // Create indicator variable for that comorbidity based on _merge variable
replace comorb_`comorb'=0 if comorb_`comorb'_date > date_clockchange // Change indicator variable to 0 if comorbidity date is after the date of the clock change.
drop _merge
drop comorb*date
}
save "projectnumber\cprd_data\combined\combined_eventlists\eventlist_sleep_13.dta", replace

*******************

*2f) Eating disorders

cd "projectnumber\cprd_data\combined\combined_eventlists"
use eventlist_eatdis_12.dta, clear
foreach comorb in anx dep{
	merge m:1 patid using "projectnumber\effect_modifiers\comorbidities\hesapc\comorblist_apc_`comorb'.dta"
	drop if _merge ==2
gen comorb_`comorb' =0
replace comorb_`comorb'=1 if _merge ==3 // Create indicator variable for that comorbidity based on _merge variable
replace comorb_`comorb'=0 if comorb_`comorb'_date > date_clockchange // Change indicator variable to 0 if comorbidity date is after the date of the clock change.
drop _merge
drop comorb*date
}
save "projectnumber\cprd_data\combined\combined_eventlists\eventlist_eatdis_13.dta", replace

*******************

*2g) Self harm

cd "projectnumber\cprd_data\combined\combined_eventlists"
use eventlist_selfharm_12.dta, clear
foreach comorb in anx dep substance {
	merge m:1 patid using "projectnumber\effect_modifiers\comorbidities\hesapc\comorblist_apc_`comorb'.dta"
	drop if _merge ==2
gen comorb_`comorb' =0
replace comorb_`comorb'=1 if _merge ==3 // Create indicator variable for that comorbidity based on _merge variable
replace comorb_`comorb'=0 if comorb_`comorb'_date > date_clockchange // Change indicator variable to 0 if comorbidity date is after the date of the clock change.
drop _merge
drop comorb*date
}
save "projectnumber\cprd_data\combined\combined_eventlists\eventlist_selfharm_13.dta", replace


*******************

*2h) Psychological conditions (in A&E only)

cd "projectnumber\cprd_data\combined\combined_eventlists"
use eventlist_psy_12.dta, clear
foreach comorb in substance sleep majorphys{
	merge m:1 patid using "projectnumber\effect_modifiers\comorbidities\hesapc\comorblist_apc_`comorb'.dta"
	drop if _merge ==2
gen comorb_`comorb' =0
replace comorb_`comorb'=1 if _merge ==3 // Create indicator variable for that comorbidity based on _merge variable
replace comorb_`comorb'=0 if comorb_`comorb'_date > date_clockchange // Change indicator variable to 0 if comorbidity date is after the date of the clock change.
drop _merge
drop comorb*date
}
save "projectnumber\cprd_data\combined\combined_eventlists\eventlist_psy_13.dta", replace