****************************************************************************************************************************

*Patient flow chart count after initial extraction
**********************************************************

*1a. Loop through all primary care eventlists, create list of unique patient ids, then append.
cd "projectnumber\cprd_data\gold_primary_care_all\stata\eventlists\extraction"

*Create datasets of unique patids for each outcome
ssc install fs
foreach i in eventlist{
	fs "`i'*"
	foreach f in `r(files)' { 
		use `f', clear
		keep patid
		duplicates drop
		save "participant_flow/flow_`f'"
		
}
}

*1b. Append the files into one dataset	
clear
cd "projectnumber\cprd_data\gold_primary_care_all\stata\eventlists\extraction\participant_flow"	
local filenames : dir . files "*"
foreach file of local filenames { 
      di "`file'"
	  append using "`file'"
}
*1,528,381 obs
duplicates drop // 508,878 obs deleted. 1,019,503 obs.
save primary_care_flow.dta, replace


*******************************************

*2a. Loop through all APC eventlists,create list of unique patient ids, then append.
cd "projectnumber\cprd_data\HES APC data"
*Create datasets of unique patids for each outcome
ssc install fs
foreach i in eventlist{
	fs "`i'*"
	foreach f in `r(files)' { 
		use `f', clear
		keep patid
		duplicates drop
		save "participant_flow/flow_`f'"
		
}
}


*2b. Append the files into one dataset	
clear
cd "projectnumber\cprd_data\HES APC data\participant_flow"	
local filenames : dir . files "*"
foreach file of local filenames { 
      di "`file'"
	  append using "`file'"
}
*969,867 obs.
duplicates drop // (229,694 observations deleted) 740,173 obs.
save apc_flow.dta, replace


*********************************************

*3a. Loop through all A&E eventlists,create list of unique patient ids, then append.
cd "projectnumber\cprd_data\HES A&E\extraction"
*Create datasets of unique patids for each outcome
ssc install fs
foreach i in eventlist{
	fs "`i'*"
	foreach f in `r(files)' { 
		use `f', clear
		keep patid
		duplicates drop
		save "participant_flow/flow_`f'"
		
}
}


*3b. Append the files into one dataset	
clear
cd "projectnumber\cprd_data\HES A&E\extraction\participant_flow"	
local filenames : dir . files "*"
foreach file of local filenames { 
      di "`file'"
	  append using "`file'"
}
*673,723 obs.
duplicates drop //(68,797 observations deleted) 604,926 obs.

save a&e_flow.dta, replace


**********************************************
*4. Combine participant ids from primary care, APC, A&E and remove duplicates to get final participant count after initial extraction.
***********************************************************************
clear
cd "projectnumber"
use "cprd_data\gold_primary_care_all\stata\eventlists\extraction\participant_flow/primary_care_flow.dta", clear
append using "cprd_data\HES APC data\participant_flow/apc_flow"
append using "cprd_data\HES A&E\extraction\participant_flow/a&e_flow" // 2,364,602
duplicates drop // (907,234 observations deleted). We have 1,457,368 observations (participants) in with in outcome event in the total study period.
save "cprd_data\flow_diagram/extraction_flow.dta", replace
