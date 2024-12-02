*dc_17_restrict_clockchanges
********************************

*Restrict outcome eventlists to just those events within 28 days (4 weeks) either side of the clock changes.
******************************************************************************************************

*There are 24 clock changes during the study period (2008-2019).

*Loop to cut eventlists down to events within 28 days of the clock changes
ssc install unique
cd "\\ads.bris.ac.uk\filestore\HealthSci SafeHaven\CPRD Projects UOB\Projects\22_002468\cprd_data\combined\combined_eventlists"
foreach outcome in anx cvd dep eatdis psy rti selfharm sleep{
use eventlist_`outcome'_15.dta, clear
unique patid
drop if clinical_eventdate ==.  // cut events without an event date.
unique patid
drop if date_clockchange == . // only events in the correct years and in Spring or Autumn months have a value in the date_clockchange variable.
unique patid
gen eligible = 0
replace eligible=1 if clinical_eventdate - date_clockchange <=27 & clinical_eventdate - date_clockchange >= -28 // we want to keep 28 days after the clock change including the Sunday of the clock change, so we want the sunday of the clock change plus 27 other days after the clock change. We want 28 days before the clock change.
keep if eligible ==1  // cut events not in 8 week period
unique patid
drop eligible
tab em_year, missing // check we've only got 2008-2019
tab em_season, missing // check no missing values
tab month, missing // check correct months.
save "\\ads.bris.ac.uk\filestore\HealthSci SafeHaven\CPRD Projects UOB\Projects\22_002468\cprd_data\combined\combined_eventlists/eventlist_`outcome'_16.dta", replace
}


*2. Calculate participant flow
*****************************

*2a) Loop through eventlists & create list of unique patient ids.
cd "\\ads.bris.ac.uk\filestore\HealthSci SafeHaven\CPRD Projects UOB\Projects\22_002468\cprd_data\combined\combined_eventlists"
foreach outcome in anx cvd dep eatdis psy rti selfharm sleep{
use eventlist_`outcome'_16.dta, clear
keep patid
duplicates drop
save "\\ads.bris.ac.uk\filestore\HealthSci SafeHaven\CPRD Projects UOB\Projects\22_002468\cprd_data\combined\participant_flow/clockchanges/flow_`outcome'", replace
}

*2b) Append files into one dataset
clear
cd "\\ads.bris.ac.uk\filestore\HealthSci SafeHaven\CPRD Projects UOB\Projects\22_002468\cprd_data\combined\participant_flow\clockchanges"
local filenames : dir . files "*"
foreach file of local filenames { 
      di "`file'"
	  append using "`file'"
}

duplicates drop // 
count
save flow_clock.dta, replace