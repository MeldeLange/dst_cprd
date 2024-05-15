**Extract events
*****************

//This cleans the CPRD files to get all the outcome events
*Mel de Lange: 2.4.2024


*******************************************************************************************


*1. Create program to extract events based on medcodes and productcodes
************************************************************************

*All CPRD data files are saved in the gold_primary_care_all data directory folder.
*Medcode codelists are saved as dep.dta, anx.dta, selfharm.dta, rti.dta, sleep.dta, cvd.dta, eatdis.dta and are saved in the folder medcodelists, within the gold_primary_care_all folder.
*Prodcode codelists are saved as dep.dta, anx.dta, sleep.dta, and saved in the folder prodcodelists, within the gold_primary_care_all folder.

*Loop 1: Medcodes: This first loop searches for Clinica//Referral/Test files within the data directory. It joins them with the codelists so that only records with medcodes matching the codelist are left. It compresses the dataset and renames eventdate clinical_eventdate. It keeps the variables: patid, medocde and clinical_evendate. It then temporarily saves the file and then appends all the files resulting from subsequent loops together to produce one file of medcode records per outcome e.g. eventlist_med_dep

*Loop 2: Prodcodes. This loop searches for Therapy files within the data directory. It joins them with the product codelists so that only records with prodcodes matching the codelist are left. It compresses the dataset and renames evendate clinical_eventdate. It keeps the variables: patid, prodcode and clinical_evendate. It then temporarily saves the file and then appends all the files resulting from subsequent loops together to produce one file of prodcode records per outcome e.g. eventlist_prod_dep. NB we only have product codelists for depression, anxiety & sleep.

*After loops: We then drop any duplicate records & save the appended files to create one medcode file for each of the 7 outcomes and one product code file forthe 3 outcomes: depression, anxiety & sleep.

cap prog drop extract_events
prog def extract_events
args type directory outcome
cap ssc install fs
cd "`directory'"
if "`type'"=="med"{ 	
	local files "" 
	foreach j in Clinical Referral Test{
		fs "*`j'*"
		foreach f in `r(files)' {
			use "`f'", clear
			joinby medcode using "medcodelists/`outcome'.dta" 
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
		fs "*`j'*"	
		foreach f in `r(files)' {
			use "`f'", clear
			joinby prodcode using "prodcodelists/`outcome'.dta" 
			compress
			rename eventdate clinical_eventdate
			keep patid prodcode clinical_eventdate
			save "tempdata/`f'_eventlist_`outcome'.dta", replace
			local files : list  f | files		
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
*extract_events [type (med/prod))] [directory] [outcome]


foreach i in sleep anx cvd dep eatdis rti selfharm{	
	extract_events med "gold_primary_care_all\Stata files" `i'
	

	}

foreach i in sleep anx dep{
	extract_events prod "gold_primary_care_all\Stata files" `i'
	}
	

******************************************************

*3. *Check eventlist files look correct


cd "\gold_primary_care_all\Stata files\tempdata"

*a) Check medcode event lists

foreach outcome in anx cvd dep eatdis rti selfharm sleep {
	
	use eventlist_med_`outcome'.dta, clear
	di "`outcome'"
	count
	unique medcode
	keep medcode
	duplicates drop
	merge 1:1 medcode using final_medcode_lists/`outcome'
	count if _merge==1
}


*Anxiety: Unique medcodes in event list:118. 118 matched. 4 unmatched from using (codelist). 0 unmatched from master (eventlist). 1,591,518 events.
*CVD: Unique medcodes in event list:227. 227 matched. 7 unmatched from using (codelist). 0 unmatched from master (eventlist). 681,900 events.
*Depression: Unique medcodes in event list:170. 170 matched.  0 unmatched from using (codelist). 0 unmatched from master (eventlist). 2,996,643 events.
*Eating disorders: Unique medcodes in event list: 17. 17 matched. 1 unmatched from using (codelist). 0 unmatched from master (eventlist). 19,742 events.
*Road traffic injuries: Unique medcodes in event list: 208. 208 matched. 196 unmatched from using (codelist). 0 unmatched from master (eventlist). 210,962 events.
*Self harm: Unique medcodes in event list: 203. 203 matched. 67 unmatched from using (codelist). 0 unmatched from master (eventlist). 82,778 events.
*Sleep: Unique medcodes in event list: 62. 62 matched. 0 unmatched from using (codelist). 0 unmatched from master (eventlist). 586,821 events.





***********************

*b) Check prodcode event lists:


cd "gold_primary_care_all\Stata files\tempdata"

foreach outcome in anx dep sleep {
	
use eventlist_prod_`outcome'.dta, clear
	di "`outcome'"
	unique prodcode
	keep prodcode
	duplicates drop
	merge 1:1 prodcode using final_prodcode_lists/`outcome'
	count if _merge==1	
	
}


*Anxiety: Unique prodcodes in event list:387. 387 matched. 146 unmatched from using (codelist). 0 unmatched from master (eventlist).
*Depression: Unique prodcodes in event list:448. 448 matched. 232 unmatched from using (codelist). 0 unmatched from master (eventlist).
*Sleep: Unique prodcodes in event list:239. 239 matched. 88 unmatched from using (codelist). 0 unmatched from master (eventlist).

