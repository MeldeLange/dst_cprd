*dc_9 Participant flow
************************



*1) Primary care eventlists

*1a. Loop through all primary care eventlists, create list of unique patient ids, then append.
cd "projectnumber\cprd_data\gold_primary_care_all\stata\eventlists\clockchanges"

*Create datasets of unique patids for each outcome
ssc install fs
foreach i in eventlist{
	fs "*`i'*"
	foreach f in `r(files)' { 
		use `f', clear
		keep patid
		duplicates drop
		save "participant_flow/flow_`f'"
		
}
}

*1b. Append the files into one dataset	
clear
cd "projectnumber\cprd_data\gold_primary_care_all\stata\eventlists\clockchanges\participant_flow"	
local filenames : dir . files "*"
foreach file of local filenames { 
      di "`file'"
	  append using "`file'"
}

duplicates drop // (60,173 observations deleted) 416,823 obs.(people)
save pc_flow_clock.dta, replace


**********************************************************************************

*2 APC eventlists 
*2a) Loop through all APC eventlists,create list of unique patient ids, then append.
cd "projectnumber\cprd_data\HES APC data\clockchanges"
*Create datasets of unique patids for each outcome
ssc install fs
foreach i in eventlist{
	fs "*`i'*"
	foreach f in `r(files)' { 
		use `f', clear
		keep patid
		duplicates drop
		save "participant_flow/flow_`f'"
		
}
}


*2b) Append the files into one dataset	
clear
cd "projectnumber\cprd_data\HES APC data\clockchanges\participant_flow"	
local filenames : dir . files "*"
foreach file of local filenames { 
      di "`file'"
	  append using "`file'"
}

duplicates drop //(76,068 observations deleted) 350,516 obs. (people)
save apc_flow_clock.dta, replace

***************************************************

*3 A&E eventlists
*3a) Loop through all A&E eventlists,create list of unique patient ids, then append.
cd "projectnumber\cprd_data\HES A&E\clockchanges"
*Create datasets of unique patids for each outcome
ssc install fs
foreach i in eventlist{
	fs "*`i'*"
	foreach f in `r(files)' { 
		use `f', clear
		keep patid
		duplicates drop
		save "participant_flow/flow_`f'"
		
}
}


*3b. Append the files into one dataset	
clear
cd "projectnumber\cprd_data\HES A&E\clockchanges\participant_flow"	
local filenames : dir . files "*"
foreach file of local filenames { 
      di "`file'"
	  append using "`file'"
}

duplicates drop // (12,857 observations deleted) 235,441 obs (people)

save ae_flow_clock.dta, replace

**********************************************
*4. Combine participant ids from primary care, APC, A&E and remove duplicates to get final participant count after sample restricted to eligible study periods.
***********************************************************************
clear
cd "projectnumber"
use "cprd_data\gold_primary_care_all\stata\eventlists\clockchanges\participant_flow/pc_flow_clock.dta", clear
append using "cprd_data\HES APC data\clockchanges\participant_flow/apc_flow_clock.dta"
append using "cprd_data\HES A&E\clockchanges\participant_flow/ae_flow_clock.dta" //
duplicates drop // (227,042 observations deleted). 775,738 obs. We have 775,738 people with an outcome event within the eligible study periods.
save "cprd_data\flow_diagram/clockchanges_flow.dta", replace