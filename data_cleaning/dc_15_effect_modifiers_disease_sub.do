*dc_15_effect_modofiers: disease subgroup

*Script to create disease subgroups for cvd & eating disorders
**************************************************************

*1. Primary care data
**********************

*1a) Convert disease subgroup readcode lists to medcodes

*Eating disorders
*Save excel files as Stata files
cd "effect_modifiers\disease_subgroups\primary care\eat_dis"

ssc install fs
fs "*.xlsx" 
foreach f in `r(files)' {
import excel using "`f'", firstrow clear
local outfile = subinstr("`f'",".xlsx","",.)
save "`outfile'.dta", replace
}


*Merge disease subgroup code lists with readcode & medcodes file to create list of medcodes
fs "pc*.dta" 
foreach f in `r(files)' {
use "`f'", clear
di "`f'"
count
merge 1:1 readcode using eatdis_read_med.dta
keep if _merge ==3
count
keep medcode
save "med_`f'", replace
}

***************************************

*CVD
*Save excel files as Stata files
clear
cd "effect_modifiers\disease_subgroups\primary care\cvd"



ssc install fs
fs "*.xlsx" 
foreach f in `r(files)' {
import excel using "`f'", firstrow clear
local outfile = subinstr("`f'",".xlsx","",.)
save "`outfile'.dta", replace
}


*Merge disease subgroup code lists with readcode & medcodes file to create list of medcodes
fs "pc*.dta" 
foreach f in `r(files)' {
use "`f'", clear
di "`f'"
count
merge 1:1 readcode using cvd_read_med.dta
keep if _merge ==3
count
keep medcode
save "med_`f'", replace
}


******************************************************

*1b) Merge disease subgroup code list with eligible eventlists

*Eating disorders
cd "cprd_data\gold_primary_care_all\Stata files\eligible"
use sy_eligible_eventlist_med_eatdis.dta, clear
gen em_subgroup_eatdis = .
local n=1
fs "med_pc_eatdis*.dta" // i have checke that the files are in the right order (anorexia, bulimia, other) so numbering of variable categories is correct.
foreach f in `r(files)' {
merge m:1 medcode using "`f'"
replace em_subgroup_eatdis = `n' if _merge ==3
drop if _merge ==2
drop _merge
local n=`n'+1
}

tab em_subgroup_eatdis, missing

*Label the em_subgroup_eatdis variable
label define em_subgroup_eatdis_lb 1"Anorexia" 2"Bulimia" 3"Other"
label values em_subgroup_eatdis em_subgroup_eatdis_lb 
tab em_subgroup_eatdis

*Save final dataset
save sy_eligible_eventlist_med_eatdis2.dta, replace

*****************************************************************************
*CVD
cd "cprd_data\gold_primary_care_all\Stata files\eligible"
use sy_eligible_eventlist_med_cvd.dta, clear

gen em_subgroup_cvd = .
local n=1
foreach file in med_pc_cvd_af med_pc_cvd_mi med_pc_cvd_stroke med_pc_cvd_other { // doing it this way so numbering of categories is correct
merge m:1 medcode using "`file'.dta"
replace em_subgroup_cvd = `n' if _merge ==3
drop if _merge ==2
drop _merge
local n=`n'+1
}

tab em_subgroup_cvd, missing

*Label the em_subgroup_eatdis variable
label define em_subgroup_cvd_lb 1"Atrial Fibrillation / Arrhythmia" 2"Myocardial Infarction" 3"Stroke / TIA" 4"Other"
label values em_subgroup_cvd em_subgroup_cvd_lb 
tab em_subgroup_cvd

*Save final dataset
save sy_eligible_eventlist_med_cvd2.dta, replace


***************************************************************************

*2. HES APC data

************************

*2a) Save subgroup codelists as Stata files
clear
cd "effect_modifiers\disease_subgroups\hes_apc\eat_dis"

*Eating disorders
ssc install fs
fs "*.xlsx" 
foreach f in `r(files)' {
import excel using "`f'", firstrow clear
local outfile = subinstr("`f'",".xlsx","",.)
save "`outfile'.dta", replace
}


*CVD
cd "effect_modifiers\disease_subgroups\hes_apc\cvd"
fs "*.xlsx" 
foreach f in `r(files)' {
import excel using "`f'", firstrow clear
local outfile = subinstr("`f'",".xlsx","",.)
save "`outfile'.dta", replace
}


***********************************************************************************

*2b) Merge disease subgroup code list with eligible eventlists

*Eating disorders
cd "cprd_data\gold_primary_care_all\Stata files\eligible"
use sy_eligible_eventlist_icd10_eatdis.dta, clear
gen em_subgroup_eatdis = .
local n=1
fs "apc_eatdis*.dta" // i have checke that the files are in the right order (anorexia, bulimia, other) so numbering of variable categories is correct.
foreach f in `r(files)' {
merge m:1 icd using "`f'"
replace em_subgroup_eatdis = `n' if _merge ==3
drop if _merge ==2
drop _merge
local n=`n'+1
}

tab em_subgroup_eatdis, missing

*Label the em_subgroup_eatdis variable
label define em_subgroup_eatdis_lb 1"Anorexia" 2"Bulimia" 3"Other"
label values em_subgroup_eatdis em_subgroup_eatdis_lb 
tab em_subgroup_eatdis

*Save final dataset
save sy_eligible_eventlist_icd10_eatdis2.dta, replace


*******************************************


*CVD
cd "cprd_data\gold_primary_care_all\Stata files\eligible"
use sy_eligible_eventlist_icd10_cvd.dta, clear

gen em_subgroup_cvd = .
local n=1
foreach file in apc_cvd_arrhythmia apc_cvd_mi apc_cvd_stroke apc_cvd_other { // doing it this way so numbering of categories is correct
merge m:1 icd using "`file'.dta"
replace em_subgroup_cvd = `n' if _merge ==3
drop if _merge ==2
drop _merge
local n=`n'+1
}

tab em_subgroup_cvd, missing

*Label the em_subgroup_eatdis variable
label define em_subgroup_cvd_lb 1"Atrial Fibrillation / Arrhythmia" 2"Myocardial Infarction" 3"Stroke / TIA" 4"Other"
label values em_subgroup_cvd em_subgroup_cvd_lb 
tab em_subgroup_cvd

*Save final dataset
save sy_eligible_eventlist_icd10_cvd2.dta, replace