**Extract events
*****************

//This cleans the CPRD files to get all the outcome events
*Mel de Lange: 2.4.2024
*Updated 13.8.2024


*******************************************************************************************


*1. Create program to extract events based on medcodes and productcodes
************************************************************************

*All CPRD stata files are saved in the projectdirectory/gold_primary_care_all/stata folder.
*Medcode codelists are saved as anx_diag.dta, anx_symp.dta, cvd.dta, dep_diag.dta, dep_symp, eatdis.dta, rti.dta, selfharm.dta and sleep.dta. They are saved in the projectdirectory/code_lists/data_analysis_codelists/cprd_codelists/med_codelists folder.
*Prodcode codelists are saved as anx.dta, dep.dta and sleep.dta. They are saved in the projectdirectory/code_lists/data_analysis_codelists/cprd_codelists/prod_codelists folder.

*Loop 1: Medcodes: This first 'if' loop searches for Clinica//Referral/Test files within the data directory. It joins them with the codelists so that only records with medcodes matching the codelist are left. It compresses the dataset and renames 'eventdate' 'clinical_eventdate'. It keeps the variables: patid, medcode and clinical_evendate. It then temporarily saves the file and then appends all the files resulting from subsequent loops together to produce one file of medcode records per outcome e.g. eventlist_med_anx_diag.

*Loop 2: Prodcodes. This second 'if' loop searches for Therapy files within the data directory. It joins them with the product codelists so that only records with prodcodes matching the codelist are left. It compresses the dataset and renames evendate 'clinical_eventdate'. It keeps the variables: patid, prodcode and clinical_evendate. It then temporarily saves the file and then appends all the files resulting from subsequent loops together to produce one file of prodcode records per outcome e.g. eventlist_prod_dep. NB we only have product codelists for depression, anxiety & sleep.

*After loops: We then drop any duplicate records & save the appended files to create one medcode file for each of the 9 outcomes and one product code file for the 3 outcomes: depression, anxiety & sleep.

cap prog drop extract_events
prog def extract_events
args type projectdirectory datadirectory outcome // see part 2 for definition of what these are.
cap ssc install fs
if "`type'"=="med"{ 	
	local files "" 
	foreach j in Clinical Referral Test{
		cd "`datadirectory'"
		fs "*`j'*"
		foreach f in `r(files)' {
			cd "`projectdirectory'"
			use "`datadirectory'/`f'", clear
			joinby medcode using "code_lists/data_analysis_codelists/cprd_codelists/med_codelists/`outcome'.dta" 
			compress
			rename eventdate clinical_eventdate
			keep patid medcode clinical_eventdate
			save "tempdata/`f'_eventlist_`outcome'.dta", replace
			local files : list  f | files
			di "`files'"
			}
		}
	foreach i in `files'{
		append using "tempdata/`i'_eventlist_`outcome'.dta"
		rm "tempdata/`i'_eventlist_`outcome'.dta"
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
			joinby prodcode using "code_lists/data_analysis_codelists/cprd_codelists/prod_codelists/`outcome'.dta" 
			compress
			rename eventdate clinical_eventdate
			keep patid prodcode clinical_eventdate
			save "tempdata/`f'_eventlist_`outcome'.dta", replace
			local files : list  f | files
			di "`files'"
			}
		}
	foreach i in `files'{
		append using "tempdata/`i'_eventlist_`outcome'.dta"
		rm "tempdata/`i'_eventlist_`outcome'.dta"
		}
	}
duplicates drop
save "tempdata/eventlist_`type'_`outcome'.dta", replace
end 

**********************************************************************************************************


*2. Run programs to extract all of the events
**********************************************

*The syntax of the program is:
*extract_events [type (med/prod))] [projectdirectory] [datadirectory] [outcome]


foreach i in sleep anx_symp anx_diag cvd dep_symp dep_diag eatdis rti selfharm{	
	extract_events med "projectnumber\" "projectnumber\cprd_data\gold_primary_care_all\stata" `i'
	}

foreach i in sleep anx dep{
	extract_events prod "projectnumber\" "projectnumber\cprd_data\gold_primary_care_all\stata" `i'
}

******************************************************

*3. *Check eventlist files look correct


cd "projectnumber"

*a) Check medcode event lists

foreach outcome in sleep anx_symp anx_diag cvd dep_symp dep_diag eatdis rti selfharm {
	
	use tempdata/eventlist_med_`outcome'.dta, clear
	di "`outcome'"
	count
	unique medcode
	keep medcode
	duplicates drop
	merge 1:1 medcode using "code_lists/data_analysis_codelists/cprd_codelists/med_codelists/`outcome'.dta" 
	count if _merge==1
}

*Sleep: Unique medcodes in event list: 62. 62 matched. 0 unmatched from using (codelist) = 62. 0 unmatched from master (eventlist). 586827 events.
*Anxiety symptom: Unique medcodes in event list: 83. 83 matched. 4 unmatched from using (codelist) = 87. 0 unmatched from master (eventlist). 1469222 events.
*Anxiety diagnosis: Unique medcodes in event list: 35. 35 matched = 35. 122,344 events.
*CVD: Unique medcodes in event list:227. 227 matched. 7 unmatched from using (codelist) = 234. 0 unmatched from master (eventlist).  682,032 events.
*Depression symptom: Unique medcodes in event list:114. 114 matched =114. 2345900.
*Depression diagnosis: Unique medcodes in event list:56. 56 matched = 56. 650140 events.
*Eating disorders: Unique medcodes in event list: 17. 17 matched. 1 unmatched from using (codelist)= 18. 0 unmatched from master (eventlist). 19741 events.
*Road traffic injuries: Unique medcodes in event list: 208. 208 matched. 196 unmatched from using (codelist)=404. 0 unmatched from master (eventlist). 210941 events.
*Self harm: Unique medcodes in event list: 203. 203 matched. 67 unmatched from using (codelist) = 270. 0 unmatched from master (eventlist). 82773 events.

*Compare to number of codes in codelists:
cd "projectnumber"
foreach outcome in sleep anx_symp anx_diag cvd dep_symp dep_diag eatdis rti selfharm {
	use "code_lists/data_analysis_codelists/cprd_codelists/med_codelists/`outcome'.dta" 
	di "`outcome'"
	count // 62 87 35 234 114 56 18 404 270.
}

***********************

*b) Check prodcode event lists:


cd "projectnumber"

foreach outcome in anx dep sleep {
	
use tempdata/eventlist_prod_`outcome'.dta, clear
	di "`outcome'"
	unique prodcode
	keep prodcode
	duplicates drop
	merge 1:1 prodcode using "code_lists/data_analysis_codelists/cprd_codelists/prod_codelists/`outcome'.dta" 
	count if _merge==1	
	
}


*Anxiety: Unique prodcodes in event list:387. 387 matched. 146 unmatched from using (codelist) = 533. 0 unmatched from master (eventlist). 11619605 events.
*Depression: Unique prodcodes in event list:448. 448 matched. 232 unmatched from using (codelist) = 680. 0 unmatched from master (eventlist). 31242958 events.
*Sleep: Unique prodcodes in event list:239. 239 matched. 88 unmatched from using (codelist) = 327. 0 unmatched from master (eventlist). 10020173 events.

*Compare to number of codes in codelists:
cd "projectnumber"
foreach outcome in anx dep sleep {
	use "code_lists/data_analysis_codelists/cprd_codelists/prod_codelists/`outcome'.dta" 
	di "`outcome'"
	count // 533 680 327
}


**************************************************************************

*4. Copy all primary care eventlists from tempdate folder into primary care eventlists folder
ssc install fs
cd "projectnumber\tempdata"
foreach i in eventlist{
	fs "`i'*"
	foreach f in `r(files)' { 
		copy `f'  "projectnumber\cprd_data\gold_primary_care_all\stata\eventlists\"
}
}


************************************************************************************
*5. Cut down anxiety symptom, depression symptom & sleep eventlists to just those with prescription within 90 days either side of the event date.

*In product eventlists rename clinical_eventdate prod_eventdate so don't have 2 variables called the same thing when merge with symptom event lists.
cd "projectnumber\cprd_data\gold_primary_care_all\stata\eventlists"
foreach outcome in anx dep sleep {
use eventlist_prod_`outcome'.dta, clear
rename clinical_eventdate prod_eventdate
save eventlist_prod_`outcome'.dta, replace
}


*Anxiety symptoms
	use "eventlist_med_anx_symp.dta", clear
	unique patid
	joinby patid using "eventlist_prod_anx.dta"
	unique patid
	gen eligible = 0
	replace eligible = 1 if prod_eventdate - clinical_eventdate <=90 & prod_eventdate - clinical_eventdate >= -90
	keep if eligible == 1
	unique patid
	duplicates drop patid medcode clinical_eventdate, force //Need to drop obs where have same person, same clinical eventdate, but multiple prescriptions within the 180 day period
	unique patid
	save eventlist_med_prod_anx_symp.dta, replace

**Depression symptoms
	use "eventlist_med_dep_symp.dta", clear
	unique patid
	joinby patid using "eventlist_prod_dep.dta"
	unique patid
	gen eligible = 0
	replace eligible = 1 if prod_eventdate - clinical_eventdate <=90 & prod_eventdate - clinical_eventdate >= -90
	keep if eligible == 1
	unique patid
	duplicates drop patid medcode clinical_eventdate, force
	unique patid
	save eventlist_med_prod_dep_symp.dta, replace
	
*Sleep diagnoses/symptoms		
	use "eventlist_med_sleep.dta", clear
	unique patid
	joinby patid using "eventlist_prod_sleep.dta"
	unique patid
	gen eligible = 0
	replace eligible = 1 if prod_eventdate - clinical_eventdate <=90 & prod_eventdate - clinical_eventdate >= -90
	keep if eligible == 1
	unique patid
	duplicates drop patid medcode clinical_eventdate, force
	unique patid
	save eventlist_med_prod_sleep.dta, replace

****************************************************************************************************************
*6. Append anxiety & depression symptom + prescription eventlists on to anxiety & depression diagnoses eventlists

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

*************

*7. Create folder with final eventlists following initial extaction process
***************************************************************************

foreach i in eventlist_dep_combined eventlist_anx_combined eventlist_med_prod_sleep eventlist_med_selfharm eventlist_med_rti eventlist_med_eatdis eventlist_med_cvd {
		copy "projectnumber\cprd_data\gold_primary_care_all\stata\eventlists/`i'.dta"  "\projectnumber\cprd_data\gold_primary_care_all\stata\eventlists\extraction\", replace
}