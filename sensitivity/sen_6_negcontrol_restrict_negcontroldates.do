*Sensitivity 6: Negative control - restrict datasets to 8 weeks around date of negative control
*************************************************************************************************


*Loop to cut eventlists down to events within 28 days of the clock changes
ssc install unique
cd "projectnumber\analysis\sensitivity\negative_control\raw_datasets"
foreach outcome in anx cvd dep eatdis psy rti selfharm sleep{
use negcontrol_`outcome'_1.dta, clear
unique patid
drop if date_negcontrol == . // only events in the correct years and in Spring or Autumn months have a value in the date_negcontrol variable.
unique patid
gen eligible = 0
replace eligible=1 if clinical_eventdate - date_negcontrol <=27 & clinical_eventdate - date_negcontrol >= -28 // we want to keep 28 days after the neg control including the Sunday of the neg control, so we want the sunday of the neg control plus 27 other days after the neg control. We want 28 days before the neg control.
keep if eligible ==1  // cut events not in 8 week period
unique patid
drop eligible
tab em_year, missing // check we've only got 2008-2019
tab em_season, missing // check no missing values
tab month, missing // check correct months.
save "negcontrol_`outcome'_2.dta", replace
}