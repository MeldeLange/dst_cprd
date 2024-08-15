*dc_10_registration_clockchanges
*********************************

*Create dataset with info on participant's valid GP registration period and the dates of the clock changes which will then be used to cut down the events.

 
*Create registration dataset
*******************************


*1 Combine patient files
*******************************

*1a) Loop to open the 5 patient files, save patid, current registration date & transfer out date.
clear
cd "projectnumber\cprd_data\gold_primary_care_all\stata"
ssc install fs
fs "*Patient*"
foreach f in `r(files)' {
	use "`f'", clear
	keep patid crd tod // keep patient id, current reg date, transter out date
	save "registration/`f'", replace
			}

*1b) Loop to append the 5 temporary spine files.
clear
cd "projectnumber\cprd_data\gold_primary_care_all\stata\registration"
fs "*patient*"
foreach f in `r(files)' {
	di "`f'"
	append using "`f'"
	rm "`f'"
}

*1c) Save resulting combined dataset
duplicates drop //	(in terms of all variables) (0 observations deleted) 
save "patient.dta", replace	// Obs: 1,474,651


********************************************************************************************

*2. Combine pratice files
****************************

*2a) Loop to open the 5 practice files, save practice id, up to standard date & last collection date
clear
cd "projectnumber\cprd_data\gold_primary_care_all\stata"
ssc install fs
fs "*Practice*"
foreach f in `r(files)' {
	use "`f'", clear
	drop region // keep practice id, up to standard date, last collection date
	save "registration/`f'", replace
			}
			
*2b) Loop to append the 5 temporary practice files
clear
cd "projectnumber\cprd_data\gold_primary_care_all\stata\registration"
fs "*practice*"
foreach f in `r(files)' {
	di "`f'"
	append using "`f'"
	rm "`f'"
}

*2c) Save combined dataset
duplicates drop //	(in terms of all variables - 1,203 observations deleted) 

save "practice.dta", replace	// 391 obs.

****************************************************************************

*************************************************************************************

*3. Merge patient & practice files
********************************************

*a) Create pracid varible in patient file by extracting it from patid so that we can merge with practice file on pracid.
clear
cd "projectnumber\cprd_data\gold_primary_care_all\stata\registration"
use patient.dta, clear
tostring patid, gen(patid_string) format (%12.0f) // turn patid into string var
gen pracid =substr(patid_string,-5,5) // create pracid var from the last 5 characters of patid_string
drop patid_string
destring pracid, replace  // convert pracid to numeric 
save patient.dta, replace

*b) Merge practice dataset with spine dataset
clear
cd "projectnumber\cprd_data\gold_primary_care_all\stata\registration"
use practice.dta, clear
merge 1:m pracid using patient.dta // all matched.
drop _merge
order patid crd tod pracid uts lcd
save registration.dta, replace


************************************************

*******************************************************************************************************************

*4. Calculate patient start & end dates (eligible period when patient is registered & providing data)
*********************************************************************************************************
*Patient start date = max of practice up to standard date and patient current registration date.
*Patient end date = min of practice last collection date and patient transfer out date.

cd "projectnumber\cprd_data\gold_primary_care_all\stata\registration"
use registration.dta, clear

*Create start_date variable
gen start_date=crd // crd = patient current reg date
replace start_date=uts if uts>crd // uts = practice up to standard date. real changes made.
format start_date %d //format start_date to display date

*Create end_date variable
gen end_date=tod // tod = patient transfer out date.
replace end_date=lcd if end_date==. // lcd= practice last collection date. real changes made
replace end_date=lcd if lcd<tod // real changes made
format end_date %d //format end_date to display date

save start_end.dta, replace

*****************************************************************************************************

*5. Add dates of clock changes to start_end dataset
****************************************************

cd "projectnumber\cprd_data\gold_primary_care_all\stata\registration"
use start_end.dta, clear

*5a)Add dates of clock changes as 30 variables
gen cc1_spring_2008 = "30.3.2008"
gen cc2_autumn_2008 = "26.10.2008"
gen cc3_spring_2009 = "29.3.2009"
gen cc4_autumn_2009 = "25.10.2009"
gen cc5_spring_2010 = "28.3.2010"
gen cc6_autumn_2010 = "31.10.2010"
gen cc7_spring_2011 = "27.3.2011"
gen cc8_autumn_2011 = "30.10.2011"
gen cc9_spring_2012 = "25.3.2012"
gen cc10_autumn_2012 = "28.10.2012"
gen cc11_spring_2013 = "31.3.2013"
gen cc12_autumn_2013 = "27.10.2013"
gen cc13_spring_2014 = "30.3.2014"
gen cc14_autumn_2014 = "26.10.2014"
gen cc15_spring_2015 = "29.3.2015"
gen cc16_autumn_2015 = "25.10.2015"
gen cc17_spring_2016 = "27.3.2016"
gen cc18_autumn_2016 = "30.10.2016"
gen cc19_spring_2017 = "26.3.2017"
gen cc20_autumn_2017 = "29.10.2017"
gen cc21_spring_2018 = "25.3.2018"
gen cc22_autumn_2018 = "28.10.2018"
gen cc23_spring_2019 = "31.3.2019"
gen cc24_autumn_2019 = "27.10.2019"
gen cc25_spring_2020 = "29.3.2020"
gen cc26_autumn_2020 = "25.10.2020"
gen cc27_spring_2021 = "28.3.2021"
gen cc28_autumn_2021 = "31.10.2021"
gen cc29_spring_2022 = "27.3.2022"
gen cc30_autumn_2022 = "30.10.2022"


*5b)Loop to format clock changes as dates
foreach varname of varlist cc* {
	gen `varname'b = date(`varname',"DMY")
	format `varname'b %d
	drop `varname'
	rename `varname'b `varname'
}

*5c)Save dataset
save start_end_clockchanges.dta, replace


*5d) Cut down to just vars we need.
keep patid start_date end_date cc*
save start_end_clockchanges2.dta, replace