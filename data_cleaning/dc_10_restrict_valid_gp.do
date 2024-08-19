*dc_10_restrict_valid_gp
************************

*Script removes observations where the GP outcome event occurs outside the person's valid registration period (before valid start date and after valid end date)
*Patient start date = max of practice up to standard date and patient current registration date.
*Patient end date = min of practice last collection date and patient transfer out date.

cd "\\projectnumber\cprd_data\gold_primary_care_all\stata\eventlists\clockchanges"
ssc install fs
fs "clock*"
foreach f in `r(files)' {
use `f', clear
unique patid
gen eligible = 1
replace eligible = 0 if clinical_eventdate <start_date | clinical_eventdate > end_date // only eligible if event is within eligible GP period
keep if eligible ==1 
unique patid
drop eligible
save "projectnumber\cprd_data\gold_primary_care_all\stata\eventlists\valid_gp\validgp_`f'", replace
}

*Anxiety: unique  patid 65,248, records 105308 (9,210 observations deleted) unique patid 59,456, records is 96098.
*Depression: unique values patid 240069, records 405584 (43,215 observations deleted unique values patid 218320, records is 362369.
*CVD: unique  patid 81976, records 15630, (9,851 observations deleted) unique patid 75268, records 105779.
*Eatdis: unique patid 1977. records 2754 (714 observations deleted. unique patid 1454. records 2040.
*Sleep: unique patid 50068. records 66021. 94,524 observations deleted) unique patid 46737,records 61497.
*RTI: unique patid 28277, records 30483, (6,141 observations deleted), unique patid 22654, records 24342.
*Selfharm: unique patid 9381, records 11578, (3,151 observations deleted), unique patid 6886, records 8427.



