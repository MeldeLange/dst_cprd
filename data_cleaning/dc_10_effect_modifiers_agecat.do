*dc_10_effect_modifiers_agecat
********************************

*Mel de Lange 09.10.24
*Here we are creating an effect modifier variable for 10-year age categories at the *time of the clock change* (exposure)
*NB All participants have had day of birth inputted as 1. All participants without a month of birth (those aged 16 & over) have had month inputted as July.
*All ages are therefore approximate.
*To calculate age at clock change we need to add clock change variables to the eventlists.


*1.Loop to add the clock changes (2008-2019) into the eventlists.

cd "projectnumber\cprd_data\combined\combined_eventlists"
foreach outcome in anx cvd dep eatdis psy rti selfharm sleep{
use "eventlist_`outcome'_3.dta", clear

gen cc1_spring_2008 = "30.3.2008" // add the dates of the clock changes as individual variables.
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

*Loop to format clock changes as dates
foreach varname of varlist cc* {
	gen `varname'b  = date(`varname',"DMY")
	format `varname'b %d
	drop `varname'
	rename `varname'b `varname'
}

*Generate date of the correct clock change variable for each event based on year & season of outcome event
gen date_clockchange = "00.0.000"
gen date_clockchangeb  = date(date_clockchange,"DMY")
format date_clockchangeb %d
drop date_clockchange
rename date_clockchangeb date_clockchange
replace date_clockchange = cc1_spring_2008 if em_year == 2008 & em_season =="Spring"
replace date_clockchange = cc2_autumn_2008 if em_year == 2008 & em_season =="Autumn"
replace date_clockchange = cc3_spring_2009 if em_year == 2009 & em_season =="Spring"
replace date_clockchange = cc4_autumn_2009 if em_year == 2009 & em_season =="Autumn"
replace date_clockchange = cc5_spring_2010 if em_year == 2010 & em_season =="Spring"
replace date_clockchange = cc6_autumn_2010 if em_year == 2010 & em_season =="Autumn"
replace date_clockchange = cc7_spring_2011 if em_year == 2011 & em_season =="Spring"
replace date_clockchange = cc8_autumn_2011 if em_year == 2011 & em_season =="Autumn"
replace date_clockchange = cc9_spring_2012 if em_year == 2012 & em_season =="Spring"
replace date_clockchange = cc10_autumn_2012 if em_year == 2012 & em_season =="Autumn"
replace date_clockchange = cc11_spring_2013 if em_year == 2013 & em_season =="Spring"
replace date_clockchange = cc12_autumn_2013 if em_year == 2013 & em_season =="Autumn"
replace date_clockchange = cc13_spring_2014 if em_year == 2014 & em_season =="Spring"
replace date_clockchange = cc14_autumn_2014 if em_year == 2014 & em_season =="Autumn"
replace date_clockchange = cc15_spring_2015 if em_year == 2015 & em_season =="Spring"
replace date_clockchange = cc16_autumn_2015 if em_year == 2015 & em_season =="Autumn"
replace date_clockchange = cc17_spring_2016 if em_year == 2016 & em_season =="Spring"
replace date_clockchange = cc18_autumn_2016 if em_year == 2016 & em_season =="Autumn"
replace date_clockchange = cc19_spring_2017 if em_year == 2017 & em_season =="Spring"
replace date_clockchange = cc20_autumn_2017 if em_year == 2017 & em_season =="Autumn"
replace date_clockchange = cc21_spring_2018 if em_year == 2018 & em_season =="Spring"
replace date_clockchange = cc22_autumn_2018 if em_year == 2018 & em_season =="Autumn"
replace date_clockchange = cc23_spring_2019 if em_year == 2019 & em_season =="Spring"
replace date_clockchange = cc24_autumn_2019 if em_year == 2019 & em_season =="Autumn"


save "eventlist_`outcome'_4.dta", replace // save updated datsets.
}


******************************************************************************************

*2. Generate age at time of clock change variable
***************************************************

*2a) Loop to create age in years at clock change variable (10-year age categories)
cd "projectnumber\cprd_data\combined\combined_eventlists"
foreach outcome in anx cvd dep eatdis psy rti selfharm sleep{
use "eventlist_`outcome'_4.dta", clear
gen difference = date_clockchange - dob // number of days between dob & clock change = age in days
gen age = difference / 365.25 //turn days into age in years
drop difference

gen em_age_cat=. // generate 10-year age category effect modifier variable
replace em_age_cat=1 if age <10 
replace em_age_cat=2 if age >=10 & age <20
replace em_age_cat=3 if age >=20 & age <30
replace em_age_cat=4 if age >=30 & age <40
replace em_age_cat=5 if age >=40 & age <50
replace em_age_cat=6 if age >=50 & age <60
replace em_age_cat=7 if age >=60 & age <70
replace em_age_cat=8 if age >=70 & age <80
replace em_age_cat=9 if age >=80 & age <90
replace em_age_cat=10 if age >=90 & age <.
label define em_age_cat_lb 1 "<10" 2 "10-19" 3 "20-29" 4 "30-39" 5"40-49" 6"50-59" 7"60-69" 8 "70-79" 9 "80-89" 10 ">=90"
label values em_age_cat em_age_cat_lb 

save "eventlist_`outcome'_5.dta", replace // save updated datsets.

}