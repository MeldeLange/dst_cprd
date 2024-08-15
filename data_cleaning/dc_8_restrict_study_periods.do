*dc_8 Restrict eventlists to study periods
*************************************

*HES APC data only goes up to March 2021 (so we don't have a full clock change in 2021), whilst HES A&E data only goes up to March 2020 (so we don't have a full clock change in 2020). 
*Study periods are therefore: primary care 2008-2022. HES APC 2008-2020. HEs A&E 2008-2019.



*1. Primary care (2008-2022)

cd "projectnumber\gold_primary_care_all\stata\eventlists\extraction"

ssc install fs
fs "eventlist*" 
foreach f in `r(files)' {
cd "projectnumber\cprd_data\gold_primary_care_all\stata\eventlists\extraction"
use "`f'", clear
g year = year(clinical_eventdate)
list clinical_eventdate year in 1/10
keep if year >= 2008
keep if year <= 2022
cd "projectnumber\cprd_data\gold_primary_care_all\stata\eventlists\studyperiods"
save "`f'", replace
}

***************************************************
*2. HES APC (create year variable then cut down to 2008-2020)
cd "projectnumber\cprd_data\HES APC data"

ssc install fs
fs "eventlist*" 
foreach f in `r(files)' {
use "`f'", clear
rename admidate clinical_eventdate
g year = year(clinical_eventdate)
list clinical_eventdate year in 1/10
keep if year >= 2008
keep if year <= 2020
save "studyperiods/`f'", replace
}

**************************************************************
*3. HES A&£ (create year variable then cut down to 2008-2019)
cd "projectnumber\cprd_data\HES A&E\extraction"

ssc install fs
fs "eventlist*" 
foreach f in `r(files)' {
cd "projectnumber\cprd_data\HES A&E\extraction"
use "`f'", clear
rename arrivaldate clinical_eventdate
g year = year(clinical_eventdate)
list clinical_eventdate year in 1/10
keep if year >= 2008
keep if year <= 2019
cd "projectnumber\cprd_data\HES A&E\studyperiods"
save "`f'", replace
}

**************************************************

