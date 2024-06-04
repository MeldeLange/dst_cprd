**Extract HES APC events
**************************

*This cleans the HES diagnosis hospitalisations file to get all the outcome events (based on our code lists)

*Mel de Lange 10.05.2024

*Set working directory
cd "cprd_data\HES APC data"


*1. Loop to save icd10 codelists as stata files, extract outcomes & save as individual files.
foreach outcome in anx cvd dep eatdis rti selfharm sleep {
	import delimited using "`outcome'.txt", varnames(1) clear // import the code lists.
	save "`outcome'.dta", replace
	joinby icd using "hes_apc.dta" // Join with the HES APC file.
	duplicates drop
	save "eventlist_icd10_`outcome'.dta", replace
}

*2. Check IDC10 event lists
foreach outcome in anx cvd dep eatdis selfharm sleep rti {
	use "eventlist_icd10_`outcome'.dta", clear
	di "`outcome'"
	unique icd
	keep icd
	duplicates drop
	merge 1:1 icd using "`outcome'.dta"
	count if _merge==1
}


*Anxiety: 34 codes matched, 6 not = 40. 439,269 obs.
*CVD: 97 codes matched, 20 not = 117. 1,563,716 obs.
*Dep: 18 codes matched, 2 not = 20. 699,677 obs.
*Eat disorders: 8 codes matched, 1 not = 9. 15,949 obs.
*Selfharm: 1 matched. 25 not = 26. 500 obs.
*Sleep disorders: 13 matched 1 not = 14. 16,559 obs.
*RTI: event list has 44,401 obs.