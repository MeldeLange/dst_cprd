*dc_9 Participant flow2.
************************



*1) Primary care eventlists

*1a. Loop through all primary care eventlists, create list of unique patient ids, then append.
cd "projectnumber\cprd_data\gold_primary_care_all\stata\eventlists\studyperiods"

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
cd "projectnumber\cprd_data\gold_primary_care_all\stata\eventlists\studyperiods\participant_flow"	
local filenames : dir . files "*"
foreach file of local filenames { 
      di "`file'"
	  append using "`file'"
}

duplicates drop // (226,833 observations deleted) 845,320 obs.
save primary_care_flow2.dta, replace


**********************************************************************************

*2 APC eventlists 
*2a) Loop through all APC eventlists,create list of unique patient ids, then append.
cd "projectnumber\cprd_data\HES APC data\studyperiods"
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


*2b) Append the files into one dataset	
clear
cd "projectnumber\cprd_data\HES APC data\studyperiods\participant_flow"	
local filenames : dir . files "*"
foreach file of local filenames { 
      di "`file'"
	  append using "`file'"
}

duplicates drop //(201,451 observations deleted) 697,421 obs.
save apc_flow2.dta, replace

***************************************************

*3 A&E eventlists
*3a) Loop through all A&E eventlists,create list of unique patient ids, then append.
cd "projectnumber\cprd_data\HES A&E\studyperiods"
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
cd "projectnumber\cprd_data\HES A&E\studyperiods\participant_flow"	
local filenames : dir . files "*"
foreach file of local filenames { 
      di "`file'"
	  append using "`file'"
}

duplicates drop // (63,879 observations deleted)  586,611 obs.

save ae_flow2.dta, replace

**********************************************
*4. Combine participant ids from primary care, APC, A&E and remove duplicates to get final participant count after sample restricted to eligible study periods.
***********************************************************************
clear
cd "projectnumber"
use "cprd_data\gold_primary_care_all\stata\eventlists\studyperiods\participant_flow/primary_care_flow2.dta", clear
append using "cprd_data\HES APC data\studyperiods\participant_flow/apc_flow2.dta"
append using "cprd_data\HES A&E\studyperiods\participant_flow/ae_flow2.dta" //
duplicates drop // (697,746 observations deleted). 1,431,606 obs. We have 1,431,606 people with an outcome event within the eligible study periods.
save "cprd_data\flow_diagram/studyperiods_flow.dta", replace