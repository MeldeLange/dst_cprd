*dc_13_effect_modifiers_disease_sub
***********************************

*Mel de Lange
*18.10.2024

*Script to create an indicator variable for disease subgroups effect modifier for cvd and eating disorders.


*1.CVD
***************

*1a) Primary care data
************************

*Save excel disease subgroup codelist files as Stata files
clear
cd "projectnumber\effect_modifiers\disease_subgroups\primary care\cvd"

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


*Rename medcode variable 'eventcode' so that can combine list with HES APC disease subgroup code list.
cd "projectnumber\effect_modifiers\disease_subgroups\primary care\cvd"
foreach subgroup in af mi other stroke {
use "med_pc_cvd_`subgroup'.dta", clear
rename medcode eventcode
save "code_pc_cvd_`subgroup'.dta"
	
}


*1b) HES APC data
*****************

*Save subgroup codelists as Stata files
cd "projectnumber\effect_modifiers\disease_subgroups\hes_apc\cvd"
fs "*.xlsx" 
foreach f in `r(files)' {
import excel using "`f'", firstrow clear
local outfile = subinstr("`f'",".xlsx","",.)
save "`outfile'.dta", replace
}

*Rename icd variable 'eventcode' so that can combine list with primary care disease subgroup code list.
cd "projectnumber\effect_modifiers\disease_subgroups\hes_apc\cvd"
foreach subgroup in arrhythmia mi other stroke {
use "apc_cvd_`subgroup'.dta", clear
rename icd eventcode
save "code_apc_cvd_`subgroup'.dta"
	
}

*Rename arrhythmia/atrial fibrillation HES APC disease subgroup codelist to be consistent with primary care equivalent
cd "projectnumber\effect_modifiers\disease_subgroups\hes_apc\cvd"
use code_apc_cvd_arrhythmia.dta, clear
save code_apc_cvd_af.dta, replace // save it as a different name
erase code_apc_cvd_arrhythmia.dta // deletes original file.



*1c) Append HES APC codelists to primary care codelists
***********************************************************
*Change format of eventcode from long to string in primary care data
cd "projectnumber\effect_modifiers\disease_subgroups\primary care\cvd"
foreach subgroup in af mi other stroke {
use "code_pc_cvd_`subgroup'.dta", clear
tostring eventcode, replace
save, replace
}


*Append primary & secondary care codelists
cd "projectnumber\effect_modifiers\disease_subgroups\primary care\cvd"
foreach subgroup in af mi other stroke {
use "code_pc_cvd_`subgroup'.dta", clear
append using "projectnumber\effect_modifiers\disease_subgroups\hes_apc\cvd\code_apc_cvd_`subgroup'"
save "projectnumber\effect_modifiers\disease_subgroups\cvd/`subgroup'.dta"
}




*1d) Merge disease subgroup codelists with eventlists
*****************************************************
cd "projectnumber\cprd_data\combined\combined_eventlists"
use eventlist_cvd_10.dta, clear
gen em_subgroup_cvd = .
local n=1
cd "projectnumber\effect_modifiers\disease_subgroups\cvd"
foreach file in af mi stroke other { // doing it this way so numbering of categories is correct as not alphabetical.
merge m:1 eventcode using "`file'.dta"
replace em_subgroup_cvd = `n' if _merge ==3
drop if _merge ==2
drop _merge
local n=`n'+1
}

tab em_subgroup_cvd, missing

*Label the em_subgroup_cvd variable
label define em_subgroup_cvd_lb 1"Atrial Fibrillation / Arrhythmia" 2"Myocardial Infarction" 3"Stroke / TIA" 4"Other"
label values em_subgroup_cvd em_subgroup_cvd_lb 
tab em_subgroup_cvd

*Save final dataset
save "projectnumber\cprd_data\combined\combined_eventlists\eventlist_cvd_11.dta", replace




**************************************************************************************************

*2. Eating disorders
********************


*2a) Primary care data
************************

*Save excel disease subgroup codelist files (read codes) as Stata files
clear
cd "projectnumber\effect_modifiers\disease_subgroups\primary care\eat_dis"

ssc install fs
fs "*.xlsx" 
foreach f in `r(files)' {
import excel using "`f'", firstrow clear
local outfile = subinstr("`f'",".xlsx","",.)
save "`outfile'.dta", replace
}


*Merge disease subgroup code lists with readcode & medcodes file to create list of medcodes
cd "projectnumber\effect_modifiers\disease_subgroups\primary care\eat_dis"
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


*Rename medcode variable 'eventcode' so that can combine list with HES APC disease subgroup code list.
cd "projectnumber\effect_modifiers\disease_subgroups\primary care\eat_dis"
foreach subgroup in anorexia bulimia other {
use "med_pc_eatdis_`subgroup'.dta", clear
rename medcode eventcode 
tostring eventcode, replace // reformat eventcode variable to string format so the same as HES APC data.
save "code_pc_eatdis_`subgroup'.dta"
	
}


*2b) HES APC data
*****************

*Save subgroup codelists as Stata files
cd "projectnumber\effect_modifiers\disease_subgroups\hes_apc\eat_dis"
fs "*.xlsx" 
foreach f in `r(files)' {
import excel using "`f'", firstrow clear
local outfile = subinstr("`f'",".xlsx","",.)
save "`outfile'.dta", replace
}

*Rename icd variable 'eventcode' so that can combine list with primary care disease subgroup code list.
cd "projectnumber\effect_modifiers\disease_subgroups\hes_apc\eat_dis"
foreach subgroup in anorexia bulimia other {
use "apc_eatdis_`subgroup'.dta", clear
rename icd eventcode
save "code_apc_eatdis_`subgroup'.dta"
	
}


*2c) Append HES APC to primary care data
****************************************
cd "projectnumber\effect_modifiers\disease_subgroups\primary care\eat_dis"
foreach subgroup in anorexia bulimia other {
use "code_pc_eatdis_`subgroup'.dta", clear
append using "projectnumber\effect_modifiers\disease_subgroups\hes_apc\eat_dis\code_apc_eatdis_`subgroup'"
save "projectnumber\effect_modifiers\disease_subgroups\eat_dis/`subgroup'.dta"
}


*2d) Merge disease subgroup codelists with eventlist
*****************************************************
cd "projectnumber\cprd_data\combined\combined_eventlists"
use eventlist_eatdis_10.dta, clear
gen em_subgroup_eatdis = .
local n=1
cd "projectnumber\effect_modifiers\disease_subgroups\eat_dis"
foreach file in anorexia bulimia other {
merge m:1 eventcode using "`file'.dta"
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
save "projectnumber\cprd_data\combined\combined_eventlists\eventlist_eatdis_11.dta", replace
