*Sensitivity 1: Checking whether (/ how many) each patient has events on more than one day in each 8 week period in our study
******************************************************************************************************************************


*Open log
log using "projectnumber\analysis\logs/obs_per_patient.log", replace


*Loop to look at each 8 week period in our study (8 outcomes x 2 seasons x 12 years = 192 sub-datasets) to see how common it is for one person to have more than one event within one of our 8 week periods.
cd "projectnumber\cprd_data\combined\combined_eventlists"
foreach outcome in anx cvd dep eatdis psy rti selfharm sleep{
	foreach season in Spring Autumn {
		foreach year in 2008 2009 2010 2011 2012 2013 2014 2015 2016 2017 2018 2019 {
use eventlist_`outcome'_22.dta, clear
keep if em_season == "`season'"	
keep if em_year == `year'
di "`outcome'", "`season'", "`year'"
egen obs_per_pat = count (patid), by (patid)
duplicates drop patid, force
tab obs_per_pat
clear
		}
	}
}

log close


***In general, depending on the dataset, 63-95% of people only have 1 event in each 8 week period. 
*CVD datasets have the lowest % of people with just 1 event per 8 week period at 63-73.


*Looking at people with v high number of events in 8-week period to see what the codes are.
cd "projectnumber\cprd_data\combined\combined_eventlists"
use eventlist_eatdis_22.dta, clear
keep if em_season == "Autumn"
keep if em_year == 2011
egen obs_per_pat = count (patid), by (patid)
keep if obs_per_pat == 26 // all 26 are icd 10 codes and the same code (F50.9)


*Looking at people with v high number of events 
cd "projectnumber\cprd_data\combined\combined_eventlists"
use eventlist_anx_22.dta, clear
keep if em_season == "Autumn"
keep if em_year == 2014
egen obs_per_pat = count (patid), by (patid)
keep if obs_per_pat == 47 // all 47 are the same icd 10 code: F41.9

*Looking at people with v high number of events
cd "projectnumber\cprd_data\combined\combined_eventlists"
use eventlist_anx_22.dta, clear
keep if em_season == "Autumn"
keep if em_year == 2016
egen obs_per_pat = count (patid), by (patid)
keep if obs_per_pat == 48 // all 48 are the same icd 10 code: F41.9


*Looking at people with v high number of events
cd "projectnumber\cprd_data\combined\combined_eventlists"
use eventlist_cvd_22.dta, clear
keep if em_season == "Spring"
keep if em_year == 2008
egen obs_per_pat = count (patid), by (patid)
keep if obs_per_pat == 48 // 2 people. each have 2 different ICD10 code repeated across the 8 weeks.



*Looking at people with v high number of events on different days
cd "projectnumber\cprd_data\combined\combined_eventlists"
use eventlist_cvd_22.dta, clear
keep if em_season == "Autumn"
keep if em_year == 2013
egen obs_per_pat = count (patid), by (patid)
keep if obs_per_pat == 49 // 1 person with 3 different ICD codes.