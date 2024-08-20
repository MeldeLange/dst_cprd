*dc_14_participant_flow_age
*****************************
*Mel de Lange
*20.08.2024

*Calculate sample size after restricting eventlists to those within age criteria.

*1)Primary care eventlists

*1a. Loop through all primary care eventlists, create list of unique patient ids, then append.
cd "projectnumber\cprd_data\final_eventlists\primary_care"

*Create datasets of unique patids for each outcome
ssc install fs
foreach i in pc{
	fs "*`i'*"
	foreach f in `r(files)' { 
		use `f', clear
		keep patid
		duplicates drop
		save "participant_flow/flow_`f'", replace
		
}
}

*1b. Append the files into one dataset	
clear
cd "projectnumber\cprd_data\final_eventlists\primary_care\participant_flow"	
local filenames : dir . files "*"
foreach file of local filenames { 
      di "`file'"
	  append using "`file'"
}

duplicates drop // 428,585 (52,207 observations deleted) 376,378
save pc_flow_final.dta, replace


**********************************************

*2)HES APC eventlists

*2a. Loop through all HES APC eventlists, create list of unique patient ids, then append.
cd "projectnumber\cprd_data\final_eventlists\hes_apc"

*Create datasets of unique patids for each outcome
ssc install fs
foreach i in hesapc{
	fs "*`i'*"
	foreach f in `r(files)' { 
		use `f', clear
		keep patid
		duplicates drop
		save "participant_flow/flow_`f'", replace
		
}
}

*2b. Append the files into one dataset	
clear
cd "projectnumber\cprd_data\final_eventlists\hes_apc\participant_flow"	
local filenames : dir . files "*"
foreach file of local filenames { 
      di "`file'"
	  append using "`file'"
}

duplicates drop // (70,405 observations deleted) 332,946
save hesapc_flow_final.dta, replace


********************************************************

*3)HES A&E eventlists

*3a. Loop through all HES APC eventlists, create list of unique patient ids, then append.
cd "projectnumber\cprd_data\final_eventlists\hes_ae"

*Create datasets of unique patids for each outcome
ssc install fs
foreach i in hesae{
	fs "*`i'*"
	foreach f in `r(files)' { 
		use `f', clear
		keep patid
		duplicates drop
		save "participant_flow/flow_`f'", replace
		
}
}

*3b. Append the files into one dataset	
clear
cd "projectnumber\cprd_data\final_eventlists\hes_ae\participant_flow"	
local filenames : dir . files "*"
foreach file of local filenames { 
      di "`file'"
	  append using "`file'"
}

duplicates drop // 214,878 (9,646 observations deleted) 205,232 people.
save hesae_flow_final.dta, replace

*************************************************************************************************************

**4. Combine participant ids from primary care, APC, A&E and remove duplicates to get final participant count after sample restricted to eligible age periods.
***********************************************************************
clear
cd "projectnumber"
use "cprd_data\final_eventlists\primary_care/participant_flow/pc_flow_final.dta", clear
append using "cprd_data\final_eventlists\hes_apc\participant_flow/hesapc_flow_final.dta"
append using "cprd_data\final_eventlists\hes_ae\participant_flow/hesae_flow_final.dta" // 914,556
duplicates drop // (203,057 observations deleted) 711,499. We have 711,499 people in our study.
save "cprd_data\flow_diagram/final_flow.dta", replace