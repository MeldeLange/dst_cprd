*dc_10 Merge spine & clock changes
*******************************************************

*Mel de Lange 29.5.24 

*Script to combine spine with dates of clock changes


*1. Add dates of clock changes to spine file
cd"cprd_data\gold_primary_care_all\Stata files\tempdata"
use spine_practice2.dta, clear

*1a)Add dates of clock changes as 30 variables
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


*1b)Loop to format clock changes as dates
foreach varname of varlist cc* {
	gen `varname'b = date(`varname',"DMY")
	format `varname'b %d
	drop `varname'
	rename `varname'b `varname'
}

*1c)Save dataset
save spine_clockchanges.dta, replace

******************************************************************


