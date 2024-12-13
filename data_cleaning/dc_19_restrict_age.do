*dc_19_restrict_age
********************

*1. Cut down eventlists to only those events where the person is in the correct age range at the time of the clock change.
***********************************************************************************************************************
*>=10 for depression, anxiety, sleep, self-harm & eating disorders, psychological conditions
*All ages for road traffic injuries. (don't need to cut down)
*>=40 for cardiovascular disease.

**Mental health outcomes (anxiety, depression, selfharm, eating disorders) (>=10)
cd "projectnumber\cprd_data\combined\combined_eventlists"
foreach outcome in anx dep eatdis psy selfharm sleep{
use "eventlist_`outcome'_17.dta", clear
keep if age >=10
save eventlist_`outcome'_18.dta, replace
}

*CVD (aged 40 and over)
cd "projectnumber\cprd_data\combined\combined_eventlists"
use eventlist_cvd_17.dta, clear
keep if age >=40
save eventlist_cvd_18.dta, replace

*RTI's (Don't need to cut down but resave existing dataset so numbering (18) is consistent between datasets)
cd "projectnumber\cprd_data\combined\combined_eventlists"
use eventlist_rti_17.dta, clear
save eventlist_rti_18.dta, replace


*2. Calculate participant flow
*****************************

*2a) Loop through eventlists & create list of unique patient ids.
cd "projectnumber\cprd_data\combined\combined_eventlists"
foreach outcome in anx cvd dep eatdis psy rti selfharm sleep{
use "eventlist_`outcome'_18.dta", clear
keep patid
duplicates drop
save "projectnumber\cprd_data\combined\participant_flow/age/flow_`outcome'", replace
}

*2b) Append files into one dataset
clear
cd "projectnumber\cprd_data\combined\participant_flow\age"
local filenames : dir . files "*"
foreach file of local filenames { 
      di "`file'"
	  append using "`file'"
}

duplicates drop // 683809
count
save flow_age.dta, replace


*3. Loop through final eventlists to count how many events we have per outcome
*******************************************************************************
cd "projectnumber\cprd_data\combined\combined_eventlists"
foreach outcome in anx cvd dep eatdis psy rti selfharm sleep{
use "eventlist_`outcome'_18.dta", clear
count
}



*Anxiety:198,939
*CVD:600,298
*Depression:527,500
*Eating disorders:5,489
*Psychological conditions (in A&E only):40,341
*Road traffic injuries:87,560
*Selfharm:40,915
*Sleep:63,990



*4. Loop through final flow datasets to count how many people we have per outcome.
cd "projectnumber\cprd_data\combined\participant_flow\age"
foreach outcome in anx cvd dep eatdis psy rti selfharm sleep{
use "flow_`outcome'.dta", clear
count
}

*Anx: 121,151
*CVD: 260,274
*Dep: 293,109
*Eatdis: 3,110
*Psy: 30,791
*RTI:73,745
*Self harm: 27,752
*Sleep: 48,753
