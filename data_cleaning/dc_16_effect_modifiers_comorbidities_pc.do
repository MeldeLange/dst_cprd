*dc_16_effect_modifiers_comorbidities_pc
*****************************************


	
*1. Extract comorbidity events from GP data using comorbidity codelists
************************************************************************

*2a) Create program to extract events based on medcodes & product codes.

*All CPRD stata files are saved here: projectdirectory/gold_primary_care_all/stata

*Comorbidity medcode lists are saved as anx_diag, anx_symp, asthma_copd, cancer, ckd, dementia, dep_diag, dep_symp, diabetes, majorphys, majorphys_ment, sleep, smi, substance. They are saved here: projectnumber\effect_modifiers\comorbidities\primarycare\comorb_codelists\med_codelists

*Comorbidity prodcode lists are saved as sleep, anx, dep diabetes, hyperlipid, hypertens.dta and saved here: projectnumber\effect_modifiers\comorbidities\primarycare\comorb_codelists\prod_codelists
	
*Loop 1: Medcodes: This first 'if' loop searches for Clinica//Referral/Test files within the data directory. It joins them with the codelists so that only records with medcodes matching the codelist are left. It compresses the dataset and renames 'eventdate' 'comorb_date'. It keeps the variables: patid, medcode and comorb_date. It then temporarily saves the file and then appends all the files resulting from subsequent loops together to produce one file of medcode records per comorbidity e.g. eventlist_med_anx_diag.

*Loop 2: Prodcodes. This second 'if' loop searches for Therapy files within the data directory. It joins them with the product codelists so that only records with prodcodes matching the codelist are left. It compresses the dataset and renames evendate 'comorb_date'. It keeps the variables: patid, prodcode and comorb_date. It then temporarily saves the file and then appends all the files resulting from subsequent loops together to produce one file of prodcode records per comorbidity e.g. eventlist_prod_dep. 

*After loops: We then drop any duplicate records & save the appended files to create one medcode file for each of the 14 comorbidities defined by medcodes and one prodcode file for the 6 comorbidities defined by prod codes.



cap prog drop extract_comorbs
prog def extract_comorbs
args type projectdirectory datadirectory comorbidity // see part 2 for definition of what these are.
cap ssc install fs
if "`type'"=="med"{ 	
	local files "" 
	foreach j in Clinical Referral Test{
		cd "`datadirectory'"
		fs "*`j'*"
		foreach f in `r(files)' {
			cd "`projectdirectory'"
			use "`datadirectory'/`f'", clear
			joinby medcode using "effect_modifiers/comorbidities/primarycare/comorb_codelists/med_codelists/`comorbidity'.dta" 
			compress
			rename eventdate comorb_date
			keep patid medcode comorb_date
			save "effect_modifiers/comorbidities/primarycare/`f'_eventlist_`comorbidity'.dta", replace
			local files : list  f | files
			di "`files'"
			}
		}
	foreach i in `files'{
		append using "effect_modifiers/comorbidities/primarycare/`i'_eventlist_`comorbidity'.dta"
		rm "effect_modifiers/comorbidities/primarycare/`i'_eventlist_`comorbidity'.dta"
		}
	}
	
	
	
if "`type'"=="prod"{
	local files ""
	foreach j in Therapy{
		cd "`datadirectory'"
		fs "*`j'*"	
		foreach f in `r(files)' {
			cd "`projectdirectory'"
			use "`datadirectory'/`f'", clear
			joinby prodcode using "effect_modifiers/comorbidities/primarycare/comorb_codelists/prod_codelists/`comorbidity'.dta" 
			compress
			rename eventdate comorb_date
			keep patid prodcode comorb_date
			save "effect_modifiers/comorbidities/primarycare/`f'_eventlist_`comorbidity'.dta", replace
			local files : list  f | files
			di "`files'"
			}
		}
	foreach i in `files'{
		append using "effect_modifiers/comorbidities/primarycare/`i'_eventlist_`comorbidity'.dta"
		rm "effect_modifiers/comorbidities/primarycare/`i'_eventlist_`comorbidity'.dta"
		}
	}
duplicates drop
save "effect_modifiers/comorbidities/primarycare/eventlist_`type'_`comorbidity'.dta", replace
end 


*****************************

*2b. Run programs to extract all of the events
**********************************************

*The syntax of the program is:
*extract_comorbs [type (med/prod))] [projectdirectory] [datadirectory] [comorbidity]


foreach i in anx_diag anx_symp asthma_copd cancer ckd dementia dep_diag dep_symp diabetes majorphys majorphys_ment sleep smi substance{	
	extract_comorbs med "projectnumber\" "projectnumber\cprd_data\gold_primary_care_all\stata" `i'
	}

foreach i in sleep anx dep diabetes hyperlipid hypertens{
	extract_comorbs prod "projectnumber\" "\\projectnumber\cprd_data\gold_primary_care_all\stata" `i'
}


******************************************************




*3. Deal with complex comorbidities
*3a)Cut down anxiety symptom, depression symptom & sleep comorbidity eventlists to just those with prescription within 90 days either side of the event date.

*In product comorbidity eventlists rename comorb_date comorb_prod_date so don't have 2 variables called the same thing when merge with symptom comorbidity event lists.
cd "projectnumber\effect_modifiers\comorbidities\primarycare"
foreach comorbidity in anx dep sleep {
use eventlist_prod_`comorbidity'.dta, clear
rename comorb_date comorb_prod_date
save eventlist_prod_`comorbidity'.dta, replace
}

*Anxiety symptoms
	use "eventlist_med_anx_symp.dta", clear
	unique patid
	joinby patid using "eventlist_prod_anx.dta"
	unique patid
	gen eligible = 0
	replace eligible = 1 if comorb_prod_date - comorb_date <=90 & comorb_prod_date - comorb_date >= -90
	keep if eligible == 1 
	unique patid
	duplicates drop patid medcode comorb_date, force //Need to drop obs where have same person, same clinical eventdate, but multiple prescriptions within the 180 day period
	unique patid
	save eventlist_med_prod_anx_symp.dta, replace
	
*Depression symptoms
	use "eventlist_med_dep_symp.dta", clear
	unique patid
	joinby patid using "eventlist_prod_dep.dta"
	unique patid
	gen eligible = 0
	replace eligible = 1 if comorb_prod_date - comorb_date <=90 & comorb_prod_date - comorb_date >= -90
	keep if eligible == 1 
	unique patid
	duplicates drop patid medcode comorb_date, force 
	unique patid
	save eventlist_med_prod_dep_symp.dta, replace

*Sleep diagnoses/symptoms		
	use "eventlist_med_sleep.dta", clear
	unique patid
	joinby patid using "eventlist_prod_sleep.dta"
	unique patid
	gen eligible = 0
	replace eligible = 1 if comorb_prod_date - comorb_date <=90 & comorb_prod_date - comorb_date >= -90
	keep if eligible == 1
	unique patid
	duplicates drop patid medcode comorb_date, force 
	unique patid
	save eventlist_med_prod_sleep.dta, replace
	


*3b) Append anxiety & depression symptom + prescription eventlists on to anxiety & depression diagnoses eventlists. 
cd "projectnumber\effect_modifiers\comorbidities\primarycare"
*Depression
use eventlist_med_prod_dep_symp.dta, clear
unique patid
append using eventlist_med_dep_diag.dta
unique patid
save eventlist_dep_combined.dta, replace

*Anxiety
use eventlist_med_prod_anx_symp.dta, clear
unique patid
append using eventlist_med_anx_diag.dta
unique patid
save eventlist_anx_combined.dta, replace


*3c) Create folder with final comorbidity eventlists
foreach i in eventlist_dep_combined eventlist_anx_combined eventlist_med_prod_sleep eventlist_med_asthma_copd eventlist_med_cancer eventlist_med_ckd eventlist_med_dementia eventlist_med_diabetes eventlist_med_majorphys eventlist_med_majorphys_ment eventlist_med_smi eventlist_med_substance eventlist_prod_diabetes eventlist_prod_hyperlipid eventlist_prod_hypertens {
 	copy "projectnumber\effect_modifiers\comorbidities\primarycare/`i'.dta"  "projectnumber\effect_modifiers\comorbidities\primarycare\comorb_eventlists\", replace
}


****************************************************

*4. Cut comorbidity eventlists down to first event for each person
*4a) Only keep patid & earliest comorbidity date.
cd "projectnumber\effect_modifiers\comorbidities\primarycare\comorb_eventlists\"
ssc install fs
fs "eventlist*.dta"
foreach f in `r(files)' {
use `f', clear
bys patid (comorb_date): generate comorb_date_n = _n // order comorbidity events for each person. (individual code doesn't matter)
keep if comorb_date_n ==1
// Only keep the first event (earliest one) for each person as we just want to know if they have *any* of these comorbidity codes *before* the date of the clock change. This gives us an individual-level file.
keep patid comorb_date
save "comorblist_`f'", replace
}

*4b) Rename comorbidity date with name of the comorbidity.
cd "projectnumber\effect_modifiers\comorbidities\primarycare\comorb_eventlists\"
foreach comorbidity in anx dep {
	use "comorblist_eventlist_`comorbidity'_combined.dta", clear
	rename comorb_date comorb_`comorbidity'_date
	save "comorblist_eventlist_med_`comorbidity'.dta", replace // renaming files to be consistent with others so can use in loop.
}


cd "projectnumber\effect_modifiers\comorbidities\primarycare\comorb_eventlists\"
foreach comorbidity in asthma_copd cancer ckd dementia diabetes majorphys majorphys_ment smi substance {
	use "comorblist_eventlist_med_`comorbidity'.dta", clear
	rename comorb_date comorb_`comorbidity'_date
	save, replace
}

cd "projectnumber\effect_modifiers\comorbidities\primarycare\comorb_eventlists\"
foreach comorbidity in sleep {
	use "comorblist_eventlist_med_prod_`comorbidity'.dta", clear
	rename comorb_date comorb_`comorbidity'_date
	save "comorblist_eventlist_med_`comorbidity'.dta", replace // renaming file to be consistent with others so can use in loop.
}

cd "projectnumber\effect_modifiers\comorbidities\primarycare\comorb_eventlists\"
foreach comorbidity in diabetes hyperlipid hypertens {
	use "comorblist_eventlist_prod_`comorbidity'.dta", clear
	rename comorb_date comorb_`comorbidity'_date
	save, replace
}


*****************************************************************************************************************

*5. Merge primary care comorbidity eventlists with study outcome eventlists & replace indicator variable of 0 with 1 if have the comorbidity in their pc record. 

*5a)CVD
*Med codes
cd "projectnumber\cprd_data\combined\combined_eventlists"
use eventlist_cvd_13.dta, clear
foreach comorb in diabetes ckd asthma_copd cancer smi{
	merge m:1 patid using "projectnumber\effect_modifiers\comorbidities\primarycare\comorb_eventlists\comorblist_eventlist_med_`comorb'.dta"
	drop if _merge ==2
replace comorb_`comorb'=1 if _merge ==3 & comorb_`comorb'_date < date_clockchange // Create indicator variable for that comorbidity based on _merge variable & if comorbidity date is before the date of the clock change. 
drop _merge
drop comorb*date
}
save "projectnumber\cprd_data\combined\combined_eventlists\eventlist_cvd_14.dta", replace

*Prod codes
cd "projectnumber\cprd_data\combined\combined_eventlists"
use eventlist_cvd_14.dta, clear
foreach comorb in hypertens hyperlipid diabetes{
	merge m:1 patid using "projectnumber\effect_modifiers\comorbidities\primarycare\comorb_eventlists\comorblist_eventlist_prod_`comorb'.dta"
	drop if _merge ==2
replace comorb_`comorb'=1 if _merge ==3 & comorb_`comorb'_date < date_clockchange // Create indicator variable for that comorbidity based on _merge variable & if comorbidity date is before the date of the clock change. 
drop _merge
drop comorb*date
}
save "projectnumber\cprd_data\combined\combined_eventlists\eventlist_cvd_15.dta", replace


*5b) Depression
*Med codes
cd "projectnumber\cprd_data\combined\combined_eventlists"
use eventlist_dep_13.dta, clear
foreach comorb in anx sleep substance majorphys{
	merge m:1 patid using "projectnumber\effect_modifiers\comorbidities\primarycare\comorb_eventlists\comorblist_eventlist_med_`comorb'.dta"
	drop if _merge ==2
replace comorb_`comorb'=1 if _merge ==3 & comorb_`comorb'_date < date_clockchange // Create indicator variable for that comorbidity based on _merge variable & if comorbidity date is before the date of the clock change. 
drop _merge
drop comorb*date
}
save "projectnumber\cprd_data\combined\combined_eventlists\eventlist_dep_15.dta", replace



*5c) Road traffic injuries
*Med codes
cd "projectnumber\cprd_data\combined\combined_eventlists"
use eventlist_rti_13.dta, clear
foreach comorb in sleep substance majorphys_ment{
	merge m:1 patid using "projectnumber\effect_modifiers\comorbidities\primarycare\comorb_eventlists\comorblist_eventlist_med_`comorb'.dta"
	drop if _merge ==2
replace comorb_`comorb'=1 if _merge ==3 & comorb_`comorb'_date < date_clockchange // Create indicator variable for that comorbidity based on _merge variable & if comorbidity date is before the date of the clock change. 
drop _merge
drop comorb*date
}
save "projectnumber\cprd_data\combined\combined_eventlists\eventlist_rti_15.dta", replace

*5d) Anxiety
*Med codes
cd "projectnumber\cprd_data\combined\combined_eventlists"
use eventlist_anx_13.dta, clear
foreach comorb in dep sleep majorphys{
	merge m:1 patid using "projectnumber\effect_modifiers\comorbidities\primarycare\comorb_eventlists\comorblist_eventlist_med_`comorb'.dta"
	drop if _merge ==2
replace comorb_`comorb'=1 if _merge ==3 & comorb_`comorb'_date < date_clockchange // Create indicator variable for that comorbidity based on _merge variable & if comorbidity date is before the date of the clock change. 
drop _merge
drop comorb*date
}
save "projectnumber\cprd_data\combined\combined_eventlists\eventlist_anx_15.dta", replace

*5e)Sleep disorders
*Med codes
cd "projectnumber\cprd_data\combined\combined_eventlists"
use eventlist_sleep_13.dta, clear
foreach comorb in anx dep dementia majorphys{
	merge m:1 patid using "projectnumber\effect_modifiers\comorbidities\primarycare\comorb_eventlists\comorblist_eventlist_med_`comorb'.dta"
	drop if _merge ==2
replace comorb_`comorb'=1 if _merge ==3 & comorb_`comorb'_date < date_clockchange // Create indicator variable for that comorbidity based on _merge variable & if comorbidity date is before the date of the clock change. 
drop _merge
drop comorb*date
}
save "projectnumber\cprd_data\combined\combined_eventlists\eventlist_sleep_15.dta", replace

*5f) Eating disorders
*Med codes
cd "projectnumber\cprd_data\combined\combined_eventlists"
use eventlist_eatdis_13.dta, clear
foreach comorb in anx dep{
	merge m:1 patid using "projectnumber\effect_modifiers\comorbidities\primarycare\comorb_eventlists\comorblist_eventlist_med_`comorb'.dta"
	drop if _merge ==2
replace comorb_`comorb'=1 if _merge ==3 & comorb_`comorb'_date < date_clockchange // Create indicator variable for that comorbidity based on _merge variable & if comorbidity date is before the date of the clock change. 
drop _merge
drop comorb*date
}
save "projectnumber\cprd_data\combined\combined_eventlists\eventlist_eatdis_15.dta", replace

*5g) Self harm
*Med codes
cd "projectnumber\cprd_data\combined\combined_eventlists"
use eventlist_selfharm_13.dta, clear
foreach comorb in anx dep substance{
	merge m:1 patid using "projectnumber\effect_modifiers\comorbidities\primarycare\comorb_eventlists\comorblist_eventlist_med_`comorb'.dta"
	drop if _merge ==2
replace comorb_`comorb'=1 if _merge ==3 & comorb_`comorb'_date < date_clockchange // Create indicator variable for that comorbidity based on _merge variable & if comorbidity date is before the date of the clock change. 
drop _merge
drop comorb*date
}
save "projectnumber\cprd_data\combined\combined_eventlists\eventlist_selfharm_15.dta", replace

*5h) Psychological conditions (A&E only)
*Med codes
cd "projectnumber\cprd_data\combined\combined_eventlists"
use eventlist_psy_13.dta, clear
foreach comorb in substance sleep majorphys{
	merge m:1 patid using "projectnumber\effect_modifiers\comorbidities\primarycare\comorb_eventlists\comorblist_eventlist_med_`comorb'.dta"
	drop if _merge ==2
replace comorb_`comorb'=1 if _merge ==3 & comorb_`comorb'_date < date_clockchange // Create indicator variable for that comorbidity based on _merge variable & if comorbidity date is before the date of the clock change. 
drop _merge
drop comorb*date
}
save "projectnumber\cprd_data\combined\combined_eventlists\eventlist_psy_15.dta", replace