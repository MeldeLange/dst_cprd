*dc_18_valid_gp_registration
*******************

*Create dataset with info on participant's valid GP registration period and the dates of the clock changes which will then be used to cut down the events.

 
*Create registration dataset
*******************************


*1 Combine patient files
*******************************

*1a) Loop to open the 5 patient files, save patid, current registration date & transfer out date.
clear
cd "projectnumber\cprd_data\gold_primary_care_all\stata"
ssc install fs
fs "*Patient*"
foreach f in `r(files)' {
	use "`f'", clear
	keep patid crd tod // keep patient id, current reg date, transter out date
	save "registration/`f'", replace
			}

*1b) Loop to append the 5 temporary spine files.
clear
cd "projectnumber\cprd_data\gold_primary_care_all\stata\registration"
fs "*patient*"
foreach f in `r(files)' {
	di "`f'"
	append using "`f'"
	rm "`f'"
}

*1c) Save resulting combined dataset
duplicates drop //	(in terms of all variables) (0 observations deleted) 
save "patient.dta", replace	// Obs: 1,474,651


********************************************************************************************

*2. Combine pratice files
****************************

*2a) Loop to open the 5 practice files, save practice id, up to standard date & last collection date
clear
cd "projectnumber\cprd_data\gold_primary_care_all\stata"
ssc install fs
fs "*Practice*"
foreach f in `r(files)' {
	use "`f'", clear
	drop region // keep practice id, up to standard date, last collection date
	save "registration/`f'", replace
			}
			
*2b) Loop to append the 5 temporary practice files
clear
cd "projectnumber\cprd_data\gold_primary_care_all\stata\registration"
fs "*practice*"
foreach f in `r(files)' {
	di "`f'"
	append using "`f'"
	rm "`f'"
}

*2c) Save combined dataset
duplicates drop //	(in terms of all variables - 1,203 observations deleted) 

save "practice.dta", replace	// 391 obs.

****************************************************************************

*************************************************************************************

*3. Merge patient & practice files
********************************************

*a) Create pracid varible in patient file by extracting it from patid so that we can merge with practice file on pracid.
clear
cd "projectnumber\cprd_data\gold_primary_care_all\stata\registration"
use patient.dta, clear
tostring patid, gen(patid_string) format (%12.0f) // turn patid into string var
gen pracid =substr(patid_string,-5,5) // create pracid var from the last 5 characters of patid_string
drop patid_string
destring pracid, replace  // convert pracid to numeric 
save patient.dta, replace

*b) Merge practice dataset with spine dataset
clear
cd "projectnumber\cprd_data\gold_primary_care_all\stata\registration"
use practice.dta, clear
merge 1:m pracid using patient.dta // all matched.
drop _merge
order patid crd tod pracid uts lcd
save registration.dta, replace



*******************************************************************************************************************

*4. Calculate patient start & end dates (eligible period when patient is registered & providing data)
*********************************************************************************************************
*Patient start date = max of practice up to standard date and patient current registration date.
*Patient end date = min of practice last collection date and patient transfer out date.

cd "projectnumber\cprd_data\gold_primary_care_all\stata\registration"
use registration.dta, clear

*Create start_date variable
gen start_date=crd // crd = patient current reg date
replace start_date=uts if uts>crd // uts = practice up to standard date. real changes made.
format start_date %d //format start_date to display date

*Create end_date variable
gen end_date=tod // tod = patient transfer out date.
replace end_date=lcd if end_date==. // lcd= practice last collection date. real changes made
replace end_date=lcd if lcd<tod // real changes made
format end_date %d //format end_date to display date

save start_end.dta, replace


*Cut down to just vars we need.
keep patid start_date end_date
save start_end2.dta, replace



*5. Combine registration data with eventlists.
**********************************************
*Save start_end2 dataset in eventlists folder
copy "projectnumber\cprd_data\gold_primary_care_all\stata\registration/start_end2.dta" "projectnumber\cprd_data\combined\combined_eventlists\"


*Combine start_end2 dataset with eventlists & cut down GP events (only) to events within valid registration period
ssc install unique
cd "projectnumber\cprd_data\combined\combined_eventlists"
foreach outcome in anx cvd dep eatdis psy rti selfharm sleep{
use eventlist_`outcome'_16.dta, clear
unique patid
merge m:1 patid using start_end2.dta
drop if _merge ==2 // from using
drop _merge
unique patid
gen eligible = 1
replace eligible = 0 if clinical_eventdate <start_date | clinical_eventdate > end_date // only eligible if event is within eligible GP period
replace eligible =1 if code_type == "icd" // being within valid registration period only applies to primary care events
replace eligible = 1 if code_type == "aepatgroup" // being within valid registration period only applies to primary care events
keep if eligible ==1 
unique patid
drop eligible
save "projectnumber\cprd_data\combined\combined_eventlists\eventlist_`outcome'_17.dta", replace
}

*6. Calculate participant flow
*****************************

*6a) Loop through eventlists & create list of unique patient ids.
cd "projectnumber\cprd_data\combined\combined_eventlists"
foreach outcome in anx cvd dep eatdis psy rti selfharm sleep{
use "eventlist_`outcome'_17.dta", clear
keep patid
duplicates drop
save "projectnumber\cprd_data\combined\participant_flow/validgp/flow_`outcome'", replace
}

*6b) Append files into one dataset
clear
cd "projectnumber\cprd_data\combined\participant_flow\validgp"
local filenames : dir . files "*"
foreach file of local filenames { 
      di "`file'"
	  append using "`file'"
}

duplicates drop
count // 717,662
save flow_validgp.dta, replace
