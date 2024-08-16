*dc_8_restrict_clockchanges
********************************

*Restrict outcome eventlists to just those events within 28 days (4 weeks) either side of the clock changes.
******************************************************************************************************

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
copy "projectnumber\cprd_data\gold_primary_care_all\stata\registration/start_end_clockchanges2.dta" "\\projectnumber\cprd_data\HES APC data\"

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
gen eligible = 0
foreach var of varlist cc*{
replace eligible =1 if admidate - `var' <= 28 & admidate -`var' >= -28 // only eligible if event is within 28 days either side of clock change
}
keep if eligible ==1 
unique patid
drop eligible
save "projectnumber\cprd_data\HES APC data\clockchanges/clock_`f'", replace
}

*Anx: unique patid 205,949, records  439,198. (307,340 observations deleted) unique patid 85,700, records 131,858.
*CVD: unique patid 427,075, records 1,563,420. (1,141,681 observations deleted).  unique patid  201,342, records  421,739.
*Dep: unique patid 276,666, records is  699,580. (497,811 observations deleted). unique patid 123,784, records 201,769
*Eatdis: unique patid 5,923, records 15943.(11,670 observations deleted) unique  patid  2,335, records 4273.
*RTI: unique patid 41,565,  records 44329. (34,436 observations deleted) unique patid 9,643, records 9893.
*Selfharm: unique patid 288, records 498. (371 observations deleted) unique patid is 93, 127 records.
*Sleep:unique patid 12,401, records 16558. (12,211 observations deleted) unique patid 3,687, records 4347.

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
copy "projectnumber\cprd_data\gold_primary_care_all\stata\registration/start_end_clockchanges2.dta" "\\projectnumber\cprd_data\HES A&E\extraction\"

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
gen eligible = 0
foreach var of varlist cc*{
replace eligible =1 if arrivaldate - `var' <= 28 & arrivaldate -`var' >= -28 // only eligible if event is within 28 days either side of clock change
}
keep if eligible ==1 
unique patid
drop eligible
save "projectnumber\cprd_data\HES A&E\clockchanges/clock_`f'", replace
}


*CVD: unique patid 362,205, records 544418. (375,299 observations deleted) unique patid 139,061, records 169119.
*Psy: unique patid 85,724, records 138815. (96,128 observations deleted) unique patid 32,559, records 42687.
*RTI: unique patid 161,033,records  181223. (126,031 observations deleted) unique patid 52,295, records is 55192.
*Selfharm: unique patid 64,761, records 114346. (80,034 observations deleted) unique patid 24,383, records 34312.


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


