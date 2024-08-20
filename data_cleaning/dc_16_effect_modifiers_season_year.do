*dc_16_effect_modifiers_season_year

*Mel de Lange
*20.8.2024

*Create variables for season, year, covid year, year that Easter Sunday coincides with Sunday of clock change.

*1.Primary care
cd "projectnumber\cprd_data\final_eventlists\primary_care"
ssc install fs
fs "2*" 
foreach f in `r(files)' {
use "`f'", clear
generate em_year = year(clinical_eventdate) // year of event
generate month = month(clinical_eventdate) // month of event
generate em_season = "" // generate season variable based on month
	replace em_season = "Spring" if month ==2
	replace em_season = "Spring" if month ==3 
	replace em_season = "Spring" if month ==4
	replace em_season = "Spring" if month ==5
	replace em_season = "Autumn" if month ==9
	replace em_season = "Autumn" if month ==10
	replace em_season = "Autumn" if month ==11
	replace em_season = "Autumn" if month ==12
	tab em_season, missing
generate em_covid = 0
		replace em_covid = 1 if em_year >= 2020 // generate covid variable that is 1 for 2020 onwards
generate em_easter= 0
		replace em_easter = 1 if em_year == 2013 & em_season == "Spring" // gen var that is 1 for years where easter Sunday coincides with clock change.
		replace em_easter = 1 if em_year == 2016 & em_season == "Spring"
	save "sy_`f'", replace
}

*********************************************************************************


*2.HES APC
cd "projectnumber\cprd_data\final_eventlists\hes_apc"
ssc install fs
fs "2*" 
foreach f in `r(files)' {
use "`f'", clear
generate em_year = year(admidate) // year of event
generate month = month(admidate) // month of event
generate em_season = "" // generate season variable based on month
	replace em_season = "Spring" if month ==2
	replace em_season = "Spring" if month ==3 
	replace em_season = "Spring" if month ==4
	replace em_season = "Spring" if month ==5
	replace em_season = "Autumn" if month ==9
	replace em_season = "Autumn" if month ==10
	replace em_season = "Autumn" if month ==11
	replace em_season = "Autumn" if month ==12
	tab em_season, missing
generate em_covid = 0
		replace em_covid = 1 if em_year >= 2020 // generate covid variable that is 1 for 2020 onwards
generate em_easter= 0
		replace em_easter = 1 if em_year == 2013 & em_season == "Spring" // gen var that is 1 for years where easter Sunday coincides with clock change.
		replace em_easter = 1 if em_year == 2016 & em_season == "Spring"
	save "sy_`f'", replace
}

************************************************************

*2.HES A&E
cd "projectnumber\cprd_data\final_eventlists\hes_ae"
ssc install fs
fs "2*" 
foreach f in `r(files)' {
use "`f'", clear
generate em_year = year(arrivaldate) // year of event
generate month = month(arrivaldate) // month of event
generate em_season = "" // generate season variable based on month
	replace em_season = "Spring" if month ==2
	replace em_season = "Spring" if month ==3 
	replace em_season = "Spring" if month ==4
	replace em_season = "Spring" if month ==5
	replace em_season = "Autumn" if month ==9
	replace em_season = "Autumn" if month ==10
	replace em_season = "Autumn" if month ==11
	replace em_season = "Autumn" if month ==12
	tab em_season, missing
generate em_covid = 0
		replace em_covid = 1 if em_year >= 2020 // generate covid variable that is 1 for 2020 onwards
generate em_easter= 0
		replace em_easter = 1 if em_year == 2013 & em_season == "Spring" // gen var that is 1 for years where easter Sunday coincides with clock change.
		replace em_easter = 1 if em_year == 2016 & em_season == "Spring"
	save "sy_`f'", replace
}
