*Create spines
*****************


*Mel de Lange 21.5.24
*Updated 28.5.24


*1 Combine patient files
*******************************

*1a) Loop to open the 5 patient files, save patid, current registration date & transfer out date.
clear
cd "cprd_data\gold_primary_care_all\Stata files"
ssc install fs
fs "*Patient*"
foreach f in `r(files)' {
	use "`f'", clear
	keep patid crd tod // keep patient id, current reg date, transter out date
	save "tempdata/spine_`f'", replace
			}

*1b) Loop to append the 5 temporary spine files.
clear
cd "cprd_data\gold_primary_care_all\Stata files\tempdata"
fs "*spine*"
foreach f in `r(files)' {
	di "`f'"
	append using "`f'"
	rm "`f'"
}

*1c) Save resulting combined dataset
duplicates drop //	(in terms of all variables) (0 observations deleted)
save "spine.dta", replace	// 1,475,111 obs

*1475111 obs agrees with my flow chart/ info provided by CPRD on data extraction.


****************************************************************************************************************************

*2. Combine pratice files
****************************

*2a) Loop to open the 5 practice files, save practice id, up to standard date & last collection date
clear
cd "cprd_data\gold_primary_care_all\Stata files"
ssc install fs
fs "*Practice*"
foreach f in `r(files)' {
	use "`f'", clear
	drop region // keep practice id, up to standard date, last collection date
	save "tempdata/spine_`f'", replace
			}
			
*2b) Loop to append the 5 temporary practice files
clear
cd "cprd_data\gold_primary_care_all\Stata files\tempdata"
fs "*practice*"
foreach f in `r(files)' {
	di "`f'"
	append using "`f'"
	rm "`f'"
}

*2c) Save combined dataset
duplicates drop //	(in terms of all variables - 1,203 observations deleted)
save "practice.dta", replace	

*391 obs after dropping duplicates.


*************************************************************************************

*3. Merge spine & combined practice file
********************************************

*a) Create pracid varible in spine file by extracting it from patid
clear
cd "cprd_data\gold_primary_care_all\Stata files\tempdata"
use spine.dta, clear
tostring patid, gen(patid_string) format (%12.0f) // turn patid into string var
gen pracid =substr(patid_string,-5,5) // create pracid var from the last 5 characters of patid_string
drop patid_string
destring pracid, replace  // convert pracid to numeric 
save spine2.dta, replace

*b) Merge practice dataset with spine dataset
cd "cprd_data\gold_primary_care_all\Stata files\tempdata"
use practice.dta, clear
merge 1:m pracid using spine2.dta // all 1,475,111 matched
drop _merge
order patid crd tod pracid uts lcd
save spine_practice.dta, replace

*******************************************************************************************************************

*4. Calculate patient start & end dates (eligible period when patient is registered & providing data)
*********************************************************************************************************
*Patient start date = max of practice up to standard date and patient current registration date.
*Patient end date = min of practice last collection date and patient transfer out date.

cd "cprd_data\gold_primary_care_all\Stata files\tempdata"
use spine_practice.dta, clear

*Create start_date variable
gen start_date=crd // crd = patient current reg date
replace start_date=uts if uts>crd // uts = practice up to standard date. 628,859 real changes made.
format start_date %d //format start_date to display date

*Create end_date variable
gen end_date=tod // tod = patient transfer out date.
replace end_date=lcd if end_date==. // lcd= practice last collection date. 999,819 real changes made
replace end_date=lcd if lcd<tod // 0 real changes made
format end_date %d //format end_date to display date

save spine_practice2.dta, replace

*****************************************************************************************************
