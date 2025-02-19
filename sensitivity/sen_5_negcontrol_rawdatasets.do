*Sensitivity 5 : Create raw datasets with negative control clock change 4 weeks before the real clock change.
*************************************************************************************************************

*1. Loop to add the negative control clock changes (2008-2019) into the eventlists (prior to the eventlist being cut down based on date of event in relation to clock change)


foreach outcome in anx cvd dep eatdis psy rti selfharm sleep{
cd "projectnumber\cprd_data\combined\combined_eventlists"
use eventlist_`outcome'_15.dta, clear
drop if clinical_eventdate ==.
replace em_season = "Spring" if month ==1 // Include January in Spring neg control analyses
replace em_season = "Autumn" if month ==8 // Include August in Autumn neg control analyses
*Add the negative control dates as individual variables.
gen nc1_spring_2008 = cc1_spring_2008 - 28 
gen nc2_autumn_2008 = cc2_autumn_2008 - 28
gen nc3_spring_2009 = cc3_spring_2009 - 28 
gen nc4_autumn_2009 = cc4_autumn_2009 - 28
gen nc5_spring_2010 = cc5_spring_2010 - 28
gen nc6_autumn_2010 = cc6_autumn_2010 - 28
gen nc7_spring_2011 = cc7_spring_2011 - 28
gen nc8_autumn_2011 = cc8_autumn_2011 - 28
gen nc9_spring_2012 = cc9_spring_2012 - 28
gen nc10_autumn_2012 =cc10_autumn_2012 - 28
gen nc11_spring_2013 = cc11_spring_2013 - 28
gen nc12_autumn_2013 = cc12_autumn_2013 - 28
gen nc13_spring_2014 = cc13_spring_2014 - 28
gen nc14_autumn_2014 = cc14_autumn_2014 - 28
gen nc15_spring_2015 = cc15_spring_2015 - 28
gen nc16_autumn_2015 = cc16_autumn_2015 - 28
gen nc17_spring_2016 = cc17_spring_2016 - 28
gen nc18_autumn_2016 = cc18_autumn_2016 - 28
gen nc19_spring_2017 = cc19_spring_2017 - 28
gen nc20_autumn_2017 = cc20_autumn_2017 - 28
gen nc21_spring_2018 = cc21_spring_2018 - 28
gen nc22_autumn_2018 = cc22_autumn_2018 - 28
gen nc23_spring_2019 = cc23_spring_2019 - 28
gen nc24_autumn_2019 = cc24_autumn_2019 - 28


*Loop to format clock changes as dates
foreach varname of varlist nc* {
	format `varname' %d
}


*Generate date of neg control for each event based on year & season of outcome event.
gen date_negcontrol = "00.0.000"
gen date_negcontrolb  = date(date_negcontrol,"DMY")
format date_negcontrolb %d
drop date_negcontrol
rename date_negcontrolb date_negcontrol
replace date_negcontrol = nc1_spring_2008 if em_year == 2008 & em_season =="Spring"
replace date_negcontrol = nc2_autumn_2008 if em_year == 2008 & em_season =="Autumn"
replace date_negcontrol = nc3_spring_2009 if em_year == 2009 & em_season =="Spring"
replace date_negcontrol = nc4_autumn_2009 if em_year == 2009 & em_season =="Autumn"
replace date_negcontrol = nc5_spring_2010 if em_year == 2010 & em_season =="Spring"
replace date_negcontrol = nc6_autumn_2010 if em_year == 2010 & em_season =="Autumn"
replace date_negcontrol = nc7_spring_2011 if em_year == 2011 & em_season =="Spring"
replace date_negcontrol = nc8_autumn_2011 if em_year == 2011 & em_season =="Autumn"
replace date_negcontrol = nc9_spring_2012 if em_year == 2012 & em_season =="Spring"
replace date_negcontrol = nc10_autumn_2012 if em_year == 2012 & em_season =="Autumn"
replace date_negcontrol = nc11_spring_2013 if em_year == 2013 & em_season =="Spring"
replace date_negcontrol = nc12_autumn_2013 if em_year == 2013 & em_season =="Autumn"
replace date_negcontrol = nc13_spring_2014 if em_year == 2014 & em_season =="Spring"
replace date_negcontrol = nc14_autumn_2014 if em_year == 2014 & em_season =="Autumn"
replace date_negcontrol = nc15_spring_2015 if em_year == 2015 & em_season =="Spring"
replace date_negcontrol = nc16_autumn_2015 if em_year == 2015 & em_season =="Autumn"
replace date_negcontrol = nc17_spring_2016 if em_year == 2016 & em_season =="Spring"
replace date_negcontrol = nc18_autumn_2016 if em_year == 2016 & em_season =="Autumn"
replace date_negcontrol = nc19_spring_2017 if em_year == 2017 & em_season =="Spring"
replace date_negcontrol = nc20_autumn_2017 if em_year == 2017 & em_season =="Autumn"
replace date_negcontrol = nc21_spring_2018 if em_year == 2018 & em_season =="Spring"
replace date_negcontrol = nc22_autumn_2018 if em_year == 2018 & em_season =="Autumn"
replace date_negcontrol = nc23_spring_2019 if em_year == 2019 & em_season =="Spring"
replace date_negcontrol = nc24_autumn_2019 if em_year == 2019 & em_season =="Autumn"

save "projectnumber\analysis\sensitivity\negative_control\raw_datasets/negcontrol_`outcome'_1.dta", replace

}