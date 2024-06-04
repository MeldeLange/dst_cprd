*dc_12 Merge spine & HES admited patient care eventlists to restrict to eligible events
*************************************************************************************

*Mel de Lange 30.5.24 

*Script to combine spine with HES APC outcome events & cut down to those eligible.

*Start logging
cd "cprd_data\HES APC data"
log using hesapc_eligibility.log, replace


*1.Restrict HES APC eventlists to events around clock change
*************************************************************
cd "cprd_data\HES APC data"
clear
ssc install unique

*Loop to merge spine with eventlist & cut down to clock change window.
ssc install fs
fs "eventlist*" 
foreach f in `r(files)' {
use spine_clockchanges.dta, clear
joinby patid using "`f'" // match spine & event list
unique patid
order patid icd admidate
gen eligible = 0
foreach var of varlist cc*{
replace eligible =1 if admidate - `var' <= 28 & admidate -`var' >= -28 // only eligible if event is within 28 days either side of clock change
}
keep if eligible ==1 
unique patid
drop eligible
save "eligible_`f'", replace
}


*2. Check no duplictes of same person with same code on same date.
fs "*eligible*"
foreach f in `r(files)' {
	use "`f'", clear
	duplicates drop patid icd admidate, force // there were no duplicates for any of the files.
	save "`f'", replace
}

*Close log
log close