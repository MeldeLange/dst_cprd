*dc_14_effect_modifiers: year, season

*Create year & season indicator variables
**********************************************************************************

*1. In HES APC & HES A&E files change admidate and arrivaldate to clinical_evendate so can loop through all files in one go. 

*Set working directory
cd "cprd_data\gold_primary_care_all\Stata files\eligible"
clear

*HES APC 
ssc install fs
fs "*icd10*" 
foreach f in `r(files)' {
use "`f'", clear
rename admidate clinical_eventdate
save "`f'", replace
}

*HES A&E
fs "*aepatgroup*" 
foreach f in `r(files)' {
use "`f'", clear
rename arrivaldate clinical_eventdate
save "`f'", replace
}

**************************************************************************************


*Start logging
cd "cprd_data\gold_primary_care_all\Stata files\eligible"
clear
log using season_year.log, replace



*2.Loop to open each eligible eventlist & create year & season indicator variables
ssc install fs
fs "eligible*" 
foreach f in `r(files)' {
use "`f'", clear
*Create year of outcome variable
g year = year(clinical_eventdate)
list clinical_eventdate year in 1/10
tab year, missing
*Create month of outcome variable (needed to create season variable)
g month = month(clinical_eventdate)
list clinical_eventdate month in 1/10
tab month, missing
*Generate season of outcome variable
generate season = ""
	replace season = "Spring" if month ==2
	replace season = "Spring" if month ==3 
	replace season = "Spring" if month ==4
	replace season = "Spring" if month ==5
	replace season = "Autumn" if month ==9
	replace season = "Autumn" if month ==10
	replace season = "Autumn" if month ==11
	replace season = "Autumn" if month ==12
	list clinical_eventdate season in 1/10
	tab season, missing

save "sy_`f'", replace
}


*********************************************************

