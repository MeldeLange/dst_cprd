*Sensitivity 7: Negative control - restrict eventlists to those whose GP event is within a valid GP registration period
**************************************************************************************************************************


*1. Combine registration data with eventlists.
**********************************************
*Save start_end2 dataset in negcontrol datasets folder
copy "projectnumber\cprd_data\gold_primary_care_all\stata\registration/start_end2.dta" "\\projectnumber\analysis\sensitivity\negative_control\raw_datasets\"


*Combine start_end2 dataset with negative control eventlists & cut down GP events (only) to events within valid registration period
ssc install unique
cd "projectnumber\analysis\sensitivity\negative_control\raw_datasets"
foreach outcome in anx cvd dep eatdis psy rti selfharm sleep{
use negcontrol_`outcome'_2.dta, clear
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
save "negcontrol_`outcome'_3.dta", replace
}