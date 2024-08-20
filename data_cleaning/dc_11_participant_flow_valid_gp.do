*dc_11_participant_flow_valid_gp
*********************************


*1) Primary care eventlists

*1a. Loop through all primary care eventlists, create list of unique patient ids, then append.
cd "projectnumber\cprd_data\gold_primary_care_all\stata\eventlists\valid_gp"

*Create datasets of unique patids for each outcome
ssc install fs
foreach i in eventlist{
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
cd "projectnumber\cprd_data\gold_primary_care_all\stata\eventlists\valid_gp\participant_flow"	
local filenames : dir . files "*"
foreach file of local filenames { 
      di "`file'"
	  append using "`file'"
}

duplicates drop // (430,775 observations deleted)
save pc_flow_valid_gp.dta, replace

**************************************************


*2. Combine participant ids from primary care valid gp records, with clock change stage APC, A&E eventlist. Remove duplicates to get final participant count after sample restricted to eligible those with valid GP records.
***********************************************************************
clear
cd "projectnumber"
use "cprd_data\gold_primary_care_all\stata\eventlists\valid_gp\participant_flow/pc_flow_valid_gp.dta", clear
append using "cprd_data\HES APC data\clockchanges\participant_flow/apc_flow_clock.dta"
append using "cprd_data\HES A&E\clockchanges\participant_flow/ae_flow_clock.dta" //
duplicates drop // (214,750 observations deleted) 749,479. We have 749,479 people with an event +/-4 weeks the clock changes only including valid gp events.
save "cprd_data\flow_diagram/valid_gp_flow.dta", replace