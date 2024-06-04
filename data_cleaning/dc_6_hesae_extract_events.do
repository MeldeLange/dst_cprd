**Extract HES A&E events
**************************

*This cleans the HES A&E attendance & diagnosis files to get all the outcome events (based on our code lists)

*Mel de Lange 14.05.2024

*Set working directory
cd "cprd_data\HES A&E"
ssc install unique

*1a) Loop to extract self-harm, road traffic inuries, CVD & psychological outcomes from the attendance file & save as individual files. 
///AEPATGROUP codes: 10= RTA. 30=Deliberate self-harm. 70=Brought in dead. 80=Other. 99=Not known.

foreach outcome in rti_aepatgroup selfharm_aepatgroup cvd_psy_aepatgroup {
	import delimited using "`outcome'.txt", varnames(1) clear // import codelist
	save "`outcome'.dta", replace
	joinby aepatgroup using "hes_ae_attendance.dta"
	unique patid
	duplicates drop // none of them had complete duplicate records
	unique patid
	save "eventlist_`outcome'.dta", replace
}



*1b) Check eventlists have the right codes.
foreach outcome in rti_aepatgroup selfharm_aepatgroup cvd_psy_aepatgroup {
	use "eventlist_`outcome'.dta", clear
	di "`outcome'"
	unique aepatgroup
	keep aepatgroup
	duplicates drop
	merge 1:1 aepatgroup using "`outcome'.dta"
	count if _merge==1
}


*1c) Check for duplicates codes on same day in self harm & road traffic files
foreach outcome in rti_aepatgroup selfharm_aepatgroup {
	use "eventlist_`outcome'.dta", clear
	unique patid
	duplicates drop patid aepatgroup arrivaldate, force // drop same aepatgroup code, in same person on same day.
	unique patid
	save "eventlist_`outcome'.dta", replace
}


*RTIS: Unique aepatgroup codes in event list:1. 1 matched. 0 unmatched.  185,069 obs.
*selfharm: Unique aepatgroup codes in event list:1. 1 matched. 0 unmatched. 119,676  obs.
*CVD/psychiatric conditions: Unique aepatgroup codes in event list:3. 3 matched. 0 unmatched. 6,767,964 observations.

*Road traffic injuries: 3,780  duplicates deleted. 
*Self harm: 5,318 duplicates deleted.
********************************************************************
*2a). Loop to extract events for diagnosis codes needed for CVD and psychological outcomes from diagnosis file into two individual files.

foreach outcome in psy_diag2 cvd_diag2 {
	import delimited using "`outcome'.txt", varnames(1) clear // import codelists
	tostring diag2, replace // turn diag2 variable into a string variable so can join with diagnosis file.
	save "`outcome'.dta", replace
	joinby diag2 using "hes_ae_diagnosis.dta"
	duplicates drop // this will drop observations with the same patid, aekey and diag2 code. 
	save "eventlist_`outcome'.dta", replace
}


*2b) Check eventlists look ok.
foreach outcome in psy_diag2 cvd_diag2 {
	use "eventlist_`outcome'.dta", clear
	di "`outcome'"
	unique diag2
	keep diag2
	duplicates drop
	merge 1:1 diag2 using "`outcome'.dta"
	count if _merge==1
}

*Psychiatric conditions: Unique diag2 codes in event list:1. 1 matched. 0 unmatched. 177,767 observations.
*CVD: Unique diag2 codes in event list:3. 3 matched. 0 unmatched. 631,219 observations.


***************************************************************************************

*3a) Loop to merge CVD and psych attendance & diagnosis datasets using patid and aekey. 
foreach eventlist in eventlist_psy_diag2 eventlist_cvd_diag2 {
	use eventlist_cvd_psy_aepatgroup.dta, clear
	merge 1:m patid aekey using "`eventlist'.dta" // the master dataset has no duplicates. The using datasets have no complete duplicates but the cvd eventlist does have duplicates of patid and aekey (the person had more than one diag2 code per attendance).
	keep if _merge ==3
	drop _merge
	order patid aekey arrivaldate aepatgroup diag2
	duplicates drop 
	save "`eventlist'_aepatgroup.dta", replace
	
}


*3b) Check eventlists look ok.
foreach eventlist in eventlist_psy_diag2_aepatgroup eventlist_cvd_diag2_aepatgroup {
use "`eventlist'.dta", clear
di "`eventlist'"
count 
tab aepatgroup
tab diag2
}


*3c) *1c) Check for duplicates diag2 codes on same day in cvd & psyc files
foreach eventlist in eventlist_psy_diag2_aepatgroup eventlist_cvd_diag2_aepatgroup {
	use "`eventlist'.dta", clear
	unique patid
	duplicates drop patid aepatgroup diag2 arrivaldate, force // drop same aepatgroup code, in same person on same day.
	unique patid
	save "`eventlist'.dta", replace
}

*Psychiatric conditions: aepatgroup: 70, 80, 99. diag2: 35.    Observations:  150,101.
*CVD: aepatgroup: 70, 80, 99. diag2:20,21,22.    Observations:  569,790.

*Psych: 11,262 duplicates deleted. Number of unique values of patid is  85741. Number of records is  138839.
*CVD 25,328 duplicates deleted. Number of unique values of patid is  362243 Number of records is  544462







