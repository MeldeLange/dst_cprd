**Extract HES A&E events
**************************

*This cleans the HES A&E attendance & diagnosis files to get all the outcome events (based on our code lists)

*Mel de Lange 14.05.2024
*Updated 14.8.2024

*Set working directory
cd "projectnumber"
ssc install unique

*1a) Loop to extract self-harm, road traffic inuries, CVD & psychological outcomes from the attendance file & save as individual files. 
///AEPATGROUP codes: 10= RTA. 30=Deliberate self-harm. 70=Brought in dead. 80=Other. 99=Not known.

foreach outcome in rti_aepatgroup selfharm_aepatgroup cvd_psy_aepatgroup {
	import delimited using "code_lists/data_analysis_codelists/hes_ae_codelists/`outcome'.txt", varnames(1) clear // import codelist
	save "code_lists/data_analysis_codelists/hes_ae_codelists/`outcome'.dta", replace
	joinby aepatgroup using "cprd_data/HES A&E/hes_ae_attendance.dta"
	unique patid
	duplicates drop // none of them had complete duplicate records
	unique patid
	save "cprd_data/HES A&E/eventlist_`outcome'.dta", replace
}



*1b) Check eventlists have the right codes.
cd "projectnumber"
foreach outcome in rti_aepatgroup selfharm_aepatgroup cvd_psy_aepatgroup {
	use "cprd_data/HES A&E/eventlist_`outcome'.dta", clear
	di "`outcome'"
	unique aepatgroup
	keep aepatgroup
	duplicates drop
	merge 1:1 aepatgroup using "code_lists/data_analysis_codelists/hes_ae_codelists/`outcome'.dta"
	count if _merge==1
}


* RTIs: 185003 obs. 1 aepatgroup code.
*Self harm:  119664 obs. 1 aepatgroup code.
*cvd_psy: 6716451. 3 aepatgroup codes.


*1c) Check for duplicates codes on same day in self harm & road traffic files & drop any duplicate records.
cd "projectnumber"
foreach outcome in rti_aepatgroup selfharm_aepatgroup {
	use "cprd_data/HES A&E/eventlist_`outcome'.dta", clear
	unique patid
	duplicates drop patid aepatgroup arrivaldate, force // drop same aepatgroup code, in same person on same day.
	unique patid
	save "cprd_data/HES A&E/eventlist_`outcome'.dta", replace
}



*Road traffic injuries: 3,780  duplicates deleted. 181223 obs.
*Self harm: 5,318 duplicates deleted. 114346 obs.


********************************************************************

*2a). Loop to extract events for diagnosis codes needed for CVD and psychological outcomes from diagnosis file into two individual files.
*Psy diagnosis code: 35.
*CVD diagnosis codes:20,21,22

*Set working directory
cd "projectnumber"

foreach outcome in psy_diag2 cvd_diag2 {
	import delimited using "code_lists/data_analysis_codelists/hes_ae_codelists/`outcome'.txt", varnames(1) clear // import codelist
	tostring diag2, replace // turn diag2 variable into a string variable so can join with diagnosis file.
	save "code_lists/data_analysis_codelists/hes_ae_codelists/`outcome'.dta", replace
	joinby diag2 using "cprd_data/HES A&E/hes_ae_diagnosis.dta"
	duplicates drop // this will drop observations with the same patid, aekey and diag2 code. 
	save "cprd_data/HES A&E/eventlist_`outcome'.dta", replace
}

*psy_diag2: 5,420 obs deleted
*cvd_diag2: 14,847  obs deleted.

*2b) Check eventlists look ok.
cd "projectnumber"
foreach outcome in psy_diag2 cvd_diag2 {
	use "cprd_data/HES A&E/eventlist_`outcome'.dta", clear
	di "`outcome'"
	unique diag2
	keep diag2
	duplicates drop
	merge 1:1 diag2 using "code_lists/data_analysis_codelists/hes_ae_codelists/`outcome'.dta"
	count if _merge==1
}

*Psychiatric conditions: Unique diag2 codes in event list:1. 1 matched. 0 unmatched. 177,767 observations.
*CVD: Unique diag2 codes in event list:3. 3 matched. 0 unmatched. 631,219 observations.


***************************************************************************************

*3a) Loop to merge CVD and psych attendance & diagnosis datasets using patid and aekey. (we only want people with the right aepatgroup *and* diag2 code)
cd "projectnumber\cprd_data\HES A&E"
foreach eventlist in eventlist_psy_diag2 eventlist_cvd_diag2 {
	use "eventlist_cvd_psy_aepatgroup.dta", clear
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
	duplicates drop patid aepatgroup diag2 arrivaldate, force // drop records with same diag2 code & aepagroup, in same person on same day (but different aekey).
	unique patid
	save "`eventlist'.dta", replace
}

*Psychiatric conditions: aepatgroup: 70, 80, 99. diag2: 35.    Observations:  150,074
*CVD: aepatgroup: 70, 80, 99. diag2:20,21,22.    Observations:  569744.

*Psy: 11,259  duplicates deleted. Number of unique values of patid is  85724. Number of records is  138815.
*CVD 25,326 duplicates deleted. Number of unique values of patid is  362205 Number of records is  544418.

******************************************************************************

*3d) Create folder with final eventlists following initial extaction process
***************************************************************************

foreach i in eventlist_cvd_diag2_aepatgroup eventlist_psy_diag2_aepatgroup eventlist_rti_aepatgroup eventlist_selfharm_aepatgroup {
		copy "projectnumber\cprd_data\HES A&E/`i'.dta"  "projectnumber\cprd_data\HES A&E/extraction\", replace
}





