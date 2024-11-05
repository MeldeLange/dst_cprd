*dc_8_season_year_easter
*Mel de Lange 8.10.24

*Create effect modifier/confounder variables for season, year and year that Easter Sunday coincides with Sunday of clock change (2013 and 2016).

cd "projectnumber\cprd_data\combined\combined_eventlists"

foreach outcome in anx cvd dep eatdis psy rti selfharm sleep{
use "eventlist_`outcome'.dta", clear
generate em_year = year(clinical_eventdate) // year of event
generate month = month(clinical_eventdate) // month of event
generate em_season = "" // generate season variable based on month (em stands for effect modifier)
	replace em_season = "Spring" if month ==2
	replace em_season = "Spring" if month ==3 
	replace em_season = "Spring" if month ==4
	replace em_season = "Spring" if month ==5
	replace em_season = "Autumn" if month ==9
	replace em_season = "Autumn" if month ==10
	replace em_season = "Autumn" if month ==11
	replace em_season = "Autumn" if month ==12
	tab em_season, missing
generate conf_easter= 0 // (conf stands for confounder)
	replace conf_easter = 1 if em_year == 2013 & em_season == "Spring" // gen var that is 1 for years where easter Sunday coincides with clock change.
	replace conf_easter = 1 if em_year == 2016 & em_season == "Spring"
save "eventlist_`outcome'_2", replace

}