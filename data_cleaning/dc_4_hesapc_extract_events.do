**Extract HES APC events
**************************

*This cleans the HES diagnosis hospitalisations file to get all the outcome events (based on our code lists)

*Mel de Lange 10.05.2024
*Updated 18.7.2024

*Set working directory
cd "projectnumber"


*1. Loop to save icd10 codelists as stata files, extract outcomes & save as individual files.
foreach outcome in anx cvd dep eatdis rti selfharm sleep {
	import delimited using "code_lists/data_analysis_codelists/hes_apc_codelists/`outcome'.txt", varnames(1) clear // import the code lists.
	save "code_lists/data_analysis_codelists/hes_apc_codelists/`outcome'.dta", replace
	joinby icd using "cprd_data/HES APC data/hes_apc.dta" // Join with the HES APC file.
	duplicates drop
	save "cprd_data/HES APC data/eventlist_icd10_`outcome'.dta", replace
}



*2. Check IDC10 event lists
cd "projectnumber"
foreach outcome in anx cvd dep eatdis selfharm sleep rti {
	use "cprd_data/HES APC data/eventlist_icd10_`outcome'.dta", clear
	di "`outcome'"
	unique icd
	keep icd
	duplicates drop
	merge 1:1 icd using "code_lists/data_analysis_codelists/hes_apc_codelists/`outcome'.dta"
	count if _merge==1
}

*Anxiety: 34 codes matched, 6 unmatched from using (codelist) = 40. 0 unmatched from master (eventlist). 439198 events.
*CVD: 97 codes matched, 20 unmatched from using (codelist) = 117. 0 unmatched from master (eventlist). 1563420 events.
*Dep: 18 codes matched, 2 unmatched from using (codelist) = 20. 0 unmatched from master (eventlist). 699580 events.
*Eat disorders: 8 codes matched, 1 unmatched from using (codelist) = 9. 0 unmatched from master (eventlist). 15943 events.
*Selfharm: 1 matched. 25 unmatched from using (codelist)  = 26. 0 unmatched from master (eventlist). 498 events.
*Sleep disorders: 13 matched 1 unmatched from using (codelist)  = 14. 0 unmatched from master (eventlist). 16558 events.
*RTI:  242 matched. 114 unmatched from using (codelist) = 356. 0 unmatched from master (eventlist). 44329 events.

*Compare to number of codes in codelists:
cd "projectnumber"
foreach outcome in anx cvd dep eatdis selfharm sleep rti {
	use "code_lists/data_analysis_codelists/hes_apc_codelists/`outcome'.dta"
	di "`outcome'"
	count // 40 117 20 9 26 14 356
}
