*dc_8_restrict_clockchanges
********************************

*Restrict outcome eventlists to just those events within 28 days (4 weeks) either side of the clock changes.
******************************************************************************************************

*NB
*Primary care data: We are looking at the 4 weeks before & after the Spring & Autumn clock changes between 2008-2022 (30 clock changes). 
*However, HES APC data only goes up to March 2021 (so we can't use any 2021 data as we don' t have the full period over the Spring clock change) and HES A&E data only goes up to March 2020 (se we can't use 2020 data).
*So: HES APC study period: 2008-2020 (26 clock changes).
*HES A&E study period: 2008-2019 (24 clock changes).

*1. Primary care data
**********************

*Save start_end_clockchanges dataset in extraction folder
copy "projectnumber\cprd_data\gold_primary_care_all\stata\registration/start_end_clockchanges2.dta" "projectnumber\cprd_data\gold_primary_care_all\stata\eventlists\extraction\"

*Drop eligible flag already in anxiety, depression & sleep eventlists
cd "projectnumber\cprd_data\gold_primary_care_all\stata\eventlists\extraction"
foreach file in eventlist_anx_combined eventlist_dep_combined eventlist_med_prod_sleep{
	use "`file'.dta", clear
	drop eligible
	save "`file'", replace
}


*Loop to merge clock change dates with eventlists & cut down to events within 28 days
cd "projectnumber\cprd_data\gold_primary_care_all\stata\eventlists\extraction"
clear
ssc install unique

fs "eventlist*"
foreach f in `r(files)' {
use start_end_clockchanges2.dta, clear
unique patid
joinby patid using "`f'" // match clock changes & event list
unique patid
order patid medcode clinical_eventdate
gen eligible = 0
foreach var of varlist cc*{
replace eligible =1 if clinical_eventdate - `var' <= 28 & clinical_eventdate -`var' >= -28 // only eligible if event is within 28 days either side of clock change
}
keep if eligible ==1 
unique patid
drop eligible
save "projectnumber\cprd_data\gold_primary_care_all\stata\eventlists\clockchanges/clock_`f'", replace
}


*Anxiety: unique patid 219,207, records 646596. Then (541,288 observations deleted). unique patid: 65,248. records: 105308.
*Dep: unique patid 621,178, 2461792 records. Then (2,056,208 observations deleted). unique patid: 240,069. records: 405584
*CVD: unique patid 277,038, 682032 records. Then (566,402 observations deleted). unique patid: 81,976. records: 115630.
*Eatdis: unique patid 11,085, 19741 records. Then (16,987 observations deleted). unique patid 1,977. records: 2754.
*Sleep: unique patid 175,752, 376624 records. Then (310,603 observations deleted). unique patid 50,068. records: 66021.
*RTI: unique patid 170,447, 210941 records. Then (180,458 observations deleted). unique patid 28,277,  records: 30483.
*Selfharm: unique patid 53,674, 82773 records. Then (71,195 observations deleted). unique patid 9,381, records:  11578.


*********************************************************************************************
*2. APC data
***********************

*Save start_end_clockchanges dataset in HES APC folder
copy "projectnumber\cprd_data\gold_primary_care_all\stata\registration/start_end_clockchanges2.dta" "projectnumber\cprd_data\HES APC data\"

*Loop to merge clock change dates with eventlists & cut down to events within 28 days
cd "projectnumber\cprd_data\HES APC data\"
clear
ssc install unique

fs "eventlist*"
foreach f in `r(files)' {
use start_end_clockchanges2.dta, clear
unique patid
joinby patid using "`f'" // match clock changes & event list
unique patid
order patid icd admidate
drop cc27_spring_2021 cc28_autumn_2021 cc29_spring_2022 cc30_autumn_2022
gen eligible = 0
foreach var of varlist cc*{
replace eligible =1 if admidate - `var' <= 28 & admidate -`var' >= -28 // only eligible if event is within 28 days either side of clock change
}
keep if eligible ==1 
unique patid
drop eligible
save "projectnumber\cprd_data\HES APC data\clockchanges/clock_`f'", replace
}

*Anx: unique patid 205,949, records  439,198. (313,633 observations deleted) unique patid  82,203, records  125,565.
*CVD: unique patid 427,075, records 1,563,420. (1,148,001 observations deleted).  unique patid  198143, records  415419.
*Dep: unique patid 276,666, records is  699,580. (504,521 observations deleted). unique patid 120317, records 195059.
*Eatdis: unique patid 5,923, records 15943.(11,851 observations deleted) unique  patid  2236, records 4092.
*RTI: unique patid 41,565,  records 44329. (34,537 observations deleted) unique patid 9546, records 9792.
*Selfharm: unique patid 288, records 498. (373 observations deleted) unique patid is 92, 125records.
*Sleep:unique patid 12,401, records 16558. (12,359 observations deleted) unique patid 3562, records 4199.


*Check no duplictes of same person with same code on same date.
cd "projectnumber\cprd_data\HES APC data\clockchanges"
fs "*clock*"
foreach f in `r(files)' {
	use "`f'", clear
	duplicates drop patid icd admidate, force // there were no duplicates for any of the files.
	save "`f'", replace
}


**************************************************************************************************

*3. HES A&E data
*************************************************************

*Save start_end_clockchanges dataset in HES A&E extraction folder
copy "projectnumber\cprd_data\gold_primary_care_all\stata\registration/start_end_clockchanges2.dta" "projectnumber\cprd_data\HES A&E\extraction\"

*Raw eventlist files we have are:
*eventlist_rti_aepatgroup
*eventlist_selfharm_aepatgroup
*eventlist_psy_diag2_aepatgroup
*eventlist_cvd_diag2_aepatgroup


*Loop to merge clock change dates with eventlists & cut down to events within 28 days
cd "projectnumber\cprd_data\HES A&E\extraction"
clear
ssc install unique

fs "eventlist*"
foreach f in `r(files)' {
use start_end_clockchanges2.dta, clear
unique patid
joinby patid using "`f'" // match clock changes & event list
unique patid
order patid aekey arrivaldate
drop cc25_spring_2020 cc26_autumn_2020 cc27_spring_2021 cc28_autumn_2021 cc29_spring_2022 cc30_autumn_2022
gen eligible = 0
foreach var of varlist cc*{
replace eligible =1 if arrivaldate - `var' <= 28 & arrivaldate -`var' >= -28 // only eligible if event is within 28 days either side of clock change
}
keep if eligible ==1 
unique patid
drop eligible
save "projectnumber\cprd_data\HES A&E\clockchanges/clock_`f'", replace
}


*CVD: unique patid 362,205, records 544418. (379,427  observations deleted) unique patid 135782, records 164991.
*Psy: unique patid 85,724, records 138815. (97,471 observations deleted) unique patid 31507, records 41344.
*RTI: unique patid 161,033,records  181223. (126,056 observations deleted) unique patid 52270, records is 55167.
*Selfharm: unique patid 64,761, records 114346. (80,498 observations deleted) unique patid 24051, records 33848.


*Check for duplicates
*a)Check no duplictes of same person with same aepatgroup code on same date in self harm & rti lists.
cd "projectnumber\cprd_data\HES A&E\clockchanges"
foreach list in clock_eventlist_rti_aepatgroup clock_eventlist_selfharm_aepatgroup {
	use "`list'", clear
	duplicates drop patid arrivaldate aepatgroup, force // there are no duplicates in either file.
	save "`list'", replace
}


*b) Check no duplictes of same person with same aepatgroup & diag2 code on same date in cvd & psyc lists.
foreach list in clock_eventlist_psy_diag2_aepatgroup clock_eventlist_cvd_diag2_aepatgroup  {
	use "`list'", clear
	duplicates drop patid arrivaldate aepatgroup diag2, force // there are no duplicates in either file.
	save "`list'", replace
}


