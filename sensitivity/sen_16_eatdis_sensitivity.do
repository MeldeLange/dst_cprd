*Sensitivity 16: Redo eating disorders sensitivity analyses to include years/regions with no events
****************************************************************************************


*1. Multiple events sensitivity
**********************************

*a. Create datasets that are missing.
***************************************

*Create datasets for spring 2013 region 4 and spring 2015 region 1.

cd "projectnumber\analysis\sensitivity\multiple_events\datasets"

use eatdis_Spring_2013_region1.dta, clear
replace region = 4 if region ==1
replace count =0 if count >0
save eatdis_Spring_2013_region4.dta, replace

replace region =1 if region ==4
replace year = 2015 if year ==2013
save eatdis_Spring_2015_region1, replace

**********************************

*Combine all the regions for 2013 and 2015 into one dataset per year
cd "projectnumber\analysis\sensitivity\multiple_events\datasets"

*2013
clear
use eatdis_Spring_2013_region1.dta, clear
foreach region in 2 3 4 5 6 7 8 9{
	append using "eatdis_Spring_2013_region`region'.dta"
		}
		save "projectnumber\analysis\sensitivity\multiple_events\datasets\regions_combined/eatdis_Spring_2013_allregions.dta", replace	

		
*2015		
cd "projectnumber\analysis\sensitivity\multiple_events\datasets"
clear
use eatdis_Spring_2015_region1.dta, clear
foreach region in 2 3 4 5 6 7 8 9{
	append using "eatdis_Spring_2015_region`region'.dta"
		}
		save "projectnumber\analysis\sensitivity\multiple_events\datasets\regions_combined/eatdis_Spring_2015_allregions.dta", replace	
		
**************************

*Combine data for each year into one dataset for all years
cd "projectnumber\analysis\sensitivity\multiple_events\datasets\regions_combined"
clear
use "eatdis_Spring_2008_allregions.dta", clear
foreach num of numlist 2009 2010 2011 2012 2013 2014 2015 2016 2017 2018 2019{
		append using "eatdis_Spring_`num'_allregions.dta"
			}
		save "projectnumber\analysis\sensitivity\multiple_events\datasets\years_combined/eatdis_Spring_allyearsregions.dta", replace	
		

**************************************************
*b)Create extra variables needed for regression analyses
*********************************************************

* In Spring datasets create indicator variable for 5 days of the Easter weekend (inc Maundy Thursday)
cd "projectnumber\analysis\sensitivity\multiple_events\datasets\years_combined"
use eatdis_Spring_allyearsregions.dta, clear

*Generate variable with the date of Easter Sunday for each year
gen easter_date = mdy(3,23,2008)
replace easter_date = mdy(4,12,2009) if year == 2009
replace easter_date = mdy(4,4,2010) if year == 2010
replace easter_date = mdy(4,24,2011) if year == 2011
replace easter_date = mdy(4,8,2012) if year == 2012
replace easter_date = mdy(3,31,2013) if year == 2013
replace easter_date = mdy(4,20,2014) if year == 2014
replace easter_date = mdy(4,5,2015) if year == 2015
replace easter_date = mdy(3,27,2016) if year == 2016
replace easter_date = mdy(4,16,2017) if year == 2017
replace easter_date = mdy(4,1,2018) if year == 2018
replace easter_date = mdy(4,21,2019) if year == 2019
format easter_date %d


*Enter Spring clock change dates
gen spring_clockchange = mdy(3,30,2008)
replace spring_clockchange = mdy(3,29,2009) if year ==2009
replace spring_clockchange = mdy(3,28,2010) if year ==2010
replace spring_clockchange = mdy(3,27,2011) if year ==2011
replace spring_clockchange = mdy(3,25,2012) if year ==2012
replace spring_clockchange = mdy(3,31,2013) if year ==2013
replace spring_clockchange = mdy(3,30,2014) if year ==2014
replace spring_clockchange = mdy(3,29,2015) if year ==2015
replace spring_clockchange = mdy(3,27,2016) if year ==2016
replace spring_clockchange = mdy(3,26,2017) if year ==2017
replace spring_clockchange = mdy(3,25,2018) if year ==2018
replace spring_clockchange = mdy(3,31,2019) if year ==2019
*Format sprint clock change variable to date
format spring_clockchange %d

*Re-generate clinical eventdate
gen clinical_eventdate= spring_clockchange
replace clinical_eventdate = spring_clockchange - 28 if day == 1
replace clinical_eventdate = spring_clockchange - 27 if day == 2
replace clinical_eventdate = spring_clockchange - 26 if day == 3
replace clinical_eventdate = spring_clockchange - 25 if day == 4
replace clinical_eventdate = spring_clockchange - 24 if day == 5
replace clinical_eventdate = spring_clockchange - 23 if day == 6
replace clinical_eventdate = spring_clockchange - 22 if day == 7
replace clinical_eventdate = spring_clockchange - 21 if day == 8
replace clinical_eventdate = spring_clockchange - 20 if day == 9
replace clinical_eventdate = spring_clockchange - 19 if day == 10
replace clinical_eventdate = spring_clockchange - 18 if day == 11
replace clinical_eventdate = spring_clockchange - 17 if day == 12
replace clinical_eventdate = spring_clockchange - 16 if day == 13
replace clinical_eventdate = spring_clockchange - 15 if day == 14
replace clinical_eventdate = spring_clockchange - 14 if day == 15
replace clinical_eventdate = spring_clockchange - 13 if day == 16
replace clinical_eventdate = spring_clockchange - 12 if day == 17
replace clinical_eventdate = spring_clockchange - 11 if day == 18
replace clinical_eventdate = spring_clockchange - 10 if day == 19
replace clinical_eventdate = spring_clockchange - 9 if day == 20
replace clinical_eventdate = spring_clockchange - 8 if day == 21
replace clinical_eventdate = spring_clockchange - 7 if day == 22
replace clinical_eventdate = spring_clockchange - 6 if day == 23
replace clinical_eventdate = spring_clockchange - 5 if day == 24
replace clinical_eventdate = spring_clockchange - 4 if day == 25
replace clinical_eventdate = spring_clockchange - 3 if day == 26
replace clinical_eventdate = spring_clockchange - 2 if day == 27
replace clinical_eventdate = spring_clockchange - 1 if day == 28

replace clinical_eventdate = spring_clockchange + 1 if day == 30
replace clinical_eventdate = spring_clockchange + 2 if day == 31
replace clinical_eventdate = spring_clockchange + 3 if day == 32
replace clinical_eventdate = spring_clockchange + 4 if day == 33
replace clinical_eventdate = spring_clockchange + 5 if day == 34
replace clinical_eventdate = spring_clockchange + 6 if day == 35
replace clinical_eventdate = spring_clockchange + 7 if day == 36
replace clinical_eventdate = spring_clockchange + 8 if day == 37
replace clinical_eventdate = spring_clockchange + 9 if day == 38
replace clinical_eventdate = spring_clockchange + 10 if day == 39
replace clinical_eventdate = spring_clockchange + 11 if day == 40
replace clinical_eventdate = spring_clockchange + 12 if day == 41
replace clinical_eventdate = spring_clockchange + 13 if day == 42
replace clinical_eventdate = spring_clockchange + 14 if day == 43
replace clinical_eventdate = spring_clockchange + 15 if day == 44
replace clinical_eventdate = spring_clockchange + 16 if day == 45
replace clinical_eventdate = spring_clockchange + 17 if day == 46
replace clinical_eventdate = spring_clockchange + 18 if day == 47
replace clinical_eventdate = spring_clockchange + 19 if day == 48
replace clinical_eventdate = spring_clockchange + 20 if day == 49
replace clinical_eventdate = spring_clockchange + 21 if day == 50
replace clinical_eventdate = spring_clockchange + 22 if day == 51
replace clinical_eventdate = spring_clockchange + 23 if day == 52
replace clinical_eventdate = spring_clockchange + 24 if day == 53
replace clinical_eventdate = spring_clockchange + 25 if day == 54
replace clinical_eventdate = spring_clockchange + 26 if day == 55
replace clinical_eventdate = spring_clockchange + 27 if day == 56


format clinical_eventdate %d


*Generate indicator variable which is 1 for Maundy Thursday, Good Friday, Easter Saturday, Easter Sunday, Easter Monday each year
gen easter_wkend = 0
replace easter_wkend = 1 if easter_date - clinical_eventdate == 0 | easter_date - clinical_eventdate == 1 | easter_date - clinical_eventdate == 2 | easter_date - clinical_eventdate == 3 |easter_date - clinical_eventdate == -1 // make 1 for the 5 days of the easter weekend.

*Only keep the variables we need.
keep day count year region easter_wkend 

*Save 
save "eatdis_Spring_allyearsregions_easter.dta", replace

*********************

*c) Create the extra variables we need for the week comparisons
cd "projectnumber\analysis\sensitivity\multiple_events\datasets\years_combined"
use eatdis_Spring_allyearsregions_easter.dta, clear

*Generate onewk_after indicator variable 
gen onewk_after = 0
replace onewk_after = 1 if day == 29 | day == 30 | day == 31 | day == 32 | day == 33 | day == 34 | day == 35

*Create a 'days' variable indicating which day of the week the data is for (Sunday-Monday)
gen days=""
replace days="Sunday" if day==1
replace days="Sunday" if day==8
replace days="Sunday" if day==15
replace days="Sunday" if day==22
replace days="Sunday" if day==29
replace days="Sunday" if day==36
replace days="Sunday" if day==43
replace days="Sunday" if day==50


replace days="Monday" if day==2
replace days="Monday" if day==9
replace days="Monday" if day==16
replace days="Monday" if day==23
replace days="Monday" if day==30
replace days="Monday" if day==37
replace days="Monday" if day==44
replace days="Monday" if day==51

replace days="Tuesday" if day==3
replace days="Tuesday" if day==10
replace days="Tuesday" if day==17
replace days="Tuesday" if day==24
replace days="Tuesday" if day==31
replace days="Tuesday" if day==38
replace days="Tuesday" if day==45
replace days="Tuesday" if day==52

replace days="Wednesday" if day==4
replace days="Wednesday" if day==11
replace days="Wednesday" if day==18
replace days="Wednesday" if day==25
replace days="Wednesday" if day==32
replace days="Wednesday" if day==39
replace days="Wednesday" if day==46
replace days="Wednesday" if day==53

replace days="Thursday" if day==5
replace days="Thursday" if day==12
replace days="Thursday" if day==19
replace days="Thursday" if day==26
replace days="Thursday" if day==33
replace days="Thursday" if day==40
replace days="Thursday" if day==47
replace days="Thursday" if day==54


replace days="Friday" if day==6
replace days="Friday" if day==13
replace days="Friday" if day==20
replace days="Friday" if day==27
replace days="Friday" if day==34
replace days="Friday" if day==41
replace days="Friday" if day==48
replace days="Friday" if day==55


replace days="Saturday" if day==7
replace days="Saturday" if day==14
replace days="Saturday" if day==21
replace days="Saturday" if day==28
replace days="Saturday" if day==35
replace days="Saturday" if day==42
replace days="Saturday" if day==49
replace days="Saturday" if day==56

tab days // days are in alphabetical order.
*Reorder the days variable so that it is ordered according to day of the week rather than alphabetical as need it in the right order to create indicator variables.
label define order 1"Sunday" 2"Monday" 3"Tuesday" 4"Wednesday" 5"Thursday" 6"Friday" 7"Saturday"
encode days, gen(days2) label(order)
tab days2 //FYI days2 is no longer a string variable.
drop days
rename days2 days
save "eatdis_Spring_allyearsregions_easter_2.dta", replace


*******************************

*d) Run regression

**Open log
log using "projectnumber\analysis\logs/multiple_events_eatdis.log", replace


cd "projectnumber\analysis\sensitivity\multiple_events\datasets\years_combined"
use "eatdis_Spring_allyearsregions_easter_2.dta", clear
*Negative Binomial Regression comparing the mean daily number of events in the week after the clock change to all other weeks, adjusting for day of the week & region.
*onewk_after
di "eatdis" "Spring: One week after"
eststo model1:nbreg count i.onewk_after i.days i.easter_wkend i.region, irr vce(cluster region)  // count = outcome. onewk_after = exposure. days = covariate. region = covariate.
matrix list r(table) // displays results inc the full p value.
estout model1 using eatdis_Spring_oneweek.txt, eform replace cells("b(label(IRR) fmt(%9.2f)) ci(label(95% CI) fmt(%9.3f)) p(label(p value) fmt(%9.4f))") label stats(N, labels("n") fmt(%9.0g))
*Import regression results & save as excel spreadsheet
import delimited using eatdis_Spring_oneweek.txt, clear
export excel using "projectnumber\analysis\sensitivity\multiple_events\regressions/eatdis_Spring_oneweek.xlsx", replace 

*Get the total number of events included in each of the 1 week analyses (use all the days of data)
cd "projectnumber\analysis\sensitivity\multiple_events\datasets\years_combined"
use "eatdis_Spring_allyearsregions_easter_2.dta", clear
di "eatdis" "Spring: One week after."
total(count)

*Close log
log close



*****************************************************************************************************************************
*****************************************************************************************************************************

*2. Re-do washout sensitivity analysis for eating disorders
******************************************************

*a) Create datasets
**********************
*We are missing datasets for 2008 region 1, 2012 region 3, 2013 region 4, 2015 region 1 and 2017 region 4 because there were no events in the year/region combinations.

cd "projectnumber\analysis\sensitivity\washout\sum_datasets"

*2008 region 1
use eatdis_Spring_2008_region2.dta, clear
replace region = 1 if region ==2
replace count =0 if count >0
save eatdis_Spring_2008_region1.dta, replace

*2012 region 3
replace region =3 if region ==1
replace year = 2012 if year ==2008
save eatdis_Spring_2012_region3, replace

*2013 region 4
replace region =4 if region ==3
replace year = 2013 if year ==2012
save eatdis_Spring_2013_region4, replace

*2015 region 1
replace region =1 if region ==4
replace year = 2015 if year ==2013
save eatdis_Spring_2015_region1, replace

*2017 region 4
replace region =4 if region ==1
replace year = 2017 if year ==2015
save eatdis_Spring_2017_region4, replace

***************************************************************

*Combine all the regions for 2008, 2012, 2013, 2015 & 2017 into one dataset per year

cd "projectnumber\analysis\sensitivity\washout\sum_datasets"
clear

*2008
clear
use eatdis_Spring_2008_region1.dta, clear
foreach region in 2 3 4 5 6 7 8 9{
	append using "eatdis_Spring_2008_region`region'.dta"
		}
		save "projectnumber\analysis\sensitivity\washout\sum_datasets\regions_combined/eatdis_Spring_2008_allregions.dta", replace


*2012
clear
use eatdis_Spring_2012_region1.dta, clear
foreach region in 2 3 4 5 6 7 8 9{
	append using "eatdis_Spring_2012_region`region'.dta"
		}
		save "projectnumber\analysis\sensitivity\washout\sum_datasets\regions_combined/eatdis_Spring_2012_allregions.dta", replace


*2013
clear
use eatdis_Spring_2013_region1.dta, clear
foreach region in 2 3 4 5 6 7 8 9{
	append using "eatdis_Spring_2013_region`region'.dta"
		}
		save "projectnumber\analysis\sensitivity\washout\sum_datasets\regions_combined/eatdis_Spring_2013_allregions.dta", replace


*2015
clear
use eatdis_Spring_2015_region1.dta, clear
foreach region in 2 3 4 5 6 7 8 9{
	append using "eatdis_Spring_2015_region`region'.dta"
		}
		save "projectnumber\analysis\sensitivity\washout\sum_datasets\regions_combined/eatdis_Spring_2015_allregions.dta", replace

*2017
clear
use eatdis_Spring_2017_region1.dta, clear
foreach region in 2 3 4 5 6 7 8 9{
	append using "eatdis_Spring_2017_region`region'.dta"
		}
		save "projectnumber\analysis\sensitivity\washout\sum_datasets\regions_combined/eatdis_Spring_2017_allregions.dta", replace

***********************************************************************

*Combine data for each year into one dataset for all years
cd "projectnumber\analysis\sensitivity\washout\sum_datasets\regions_combined/"
clear
use "eatdis_Spring_2008_allregions.dta", clear
foreach num of numlist 2009 2010 2011 2012 2013 2014 2015 2016 2017 2018 2019{
		append using "eatdis_Spring_`num'_allregions.dta"
			}
		save "projectnumber\analysis\sensitivity\washout\sum_datasets\years_combined/eatdis_Spring_allyearsregions.dta", replace
		
		
***********************************************************************************************************************

*b)Create extra variables needed for regression analyses
*********************************************************
cd "projectnumber\analysis\sensitivity\washout\sum_datasets\years_combined"
use eatdis_Spring_allyearsregions.dta, clear

*Generate variable with the date of Easter Sunday for each year
gen easter_date = mdy(3,23,2008)
replace easter_date = mdy(4,12,2009) if year == 2009
replace easter_date = mdy(4,4,2010) if year == 2010
replace easter_date = mdy(4,24,2011) if year == 2011
replace easter_date = mdy(4,8,2012) if year == 2012
replace easter_date = mdy(3,31,2013) if year == 2013
replace easter_date = mdy(4,20,2014) if year == 2014
replace easter_date = mdy(4,5,2015) if year == 2015
replace easter_date = mdy(3,27,2016) if year == 2016
replace easter_date = mdy(4,16,2017) if year == 2017
replace easter_date = mdy(4,1,2018) if year == 2018
replace easter_date = mdy(4,21,2019) if year == 2019
format easter_date %d


*Enter Spring clock change dates
gen spring_clockchange = mdy(3,30,2008)
replace spring_clockchange = mdy(3,29,2009) if year ==2009
replace spring_clockchange = mdy(3,28,2010) if year ==2010
replace spring_clockchange = mdy(3,27,2011) if year ==2011
replace spring_clockchange = mdy(3,25,2012) if year ==2012
replace spring_clockchange = mdy(3,31,2013) if year ==2013
replace spring_clockchange = mdy(3,30,2014) if year ==2014
replace spring_clockchange = mdy(3,29,2015) if year ==2015
replace spring_clockchange = mdy(3,27,2016) if year ==2016
replace spring_clockchange = mdy(3,26,2017) if year ==2017
replace spring_clockchange = mdy(3,25,2018) if year ==2018
replace spring_clockchange = mdy(3,31,2019) if year ==2019
*Format sprint clock change variable to date
format spring_clockchange %d

*Re-generate clinical eventdate
gen clinical_eventdate= spring_clockchange
replace clinical_eventdate = spring_clockchange - 28 if day == 1
replace clinical_eventdate = spring_clockchange - 27 if day == 2
replace clinical_eventdate = spring_clockchange - 26 if day == 3
replace clinical_eventdate = spring_clockchange - 25 if day == 4
replace clinical_eventdate = spring_clockchange - 24 if day == 5
replace clinical_eventdate = spring_clockchange - 23 if day == 6
replace clinical_eventdate = spring_clockchange - 22 if day == 7
replace clinical_eventdate = spring_clockchange - 21 if day == 8
replace clinical_eventdate = spring_clockchange - 20 if day == 9
replace clinical_eventdate = spring_clockchange - 19 if day == 10
replace clinical_eventdate = spring_clockchange - 18 if day == 11
replace clinical_eventdate = spring_clockchange - 17 if day == 12
replace clinical_eventdate = spring_clockchange - 16 if day == 13
replace clinical_eventdate = spring_clockchange - 15 if day == 14
replace clinical_eventdate = spring_clockchange - 14 if day == 15
replace clinical_eventdate = spring_clockchange - 13 if day == 16
replace clinical_eventdate = spring_clockchange - 12 if day == 17
replace clinical_eventdate = spring_clockchange - 11 if day == 18
replace clinical_eventdate = spring_clockchange - 10 if day == 19
replace clinical_eventdate = spring_clockchange - 9 if day == 20
replace clinical_eventdate = spring_clockchange - 8 if day == 21
replace clinical_eventdate = spring_clockchange - 7 if day == 22
replace clinical_eventdate = spring_clockchange - 6 if day == 23
replace clinical_eventdate = spring_clockchange - 5 if day == 24
replace clinical_eventdate = spring_clockchange - 4 if day == 25
replace clinical_eventdate = spring_clockchange - 3 if day == 26
replace clinical_eventdate = spring_clockchange - 2 if day == 27
replace clinical_eventdate = spring_clockchange - 1 if day == 28

replace clinical_eventdate = spring_clockchange + 1 if day == 30
replace clinical_eventdate = spring_clockchange + 2 if day == 31
replace clinical_eventdate = spring_clockchange + 3 if day == 32
replace clinical_eventdate = spring_clockchange + 4 if day == 33
replace clinical_eventdate = spring_clockchange + 5 if day == 34
replace clinical_eventdate = spring_clockchange + 6 if day == 35
replace clinical_eventdate = spring_clockchange + 7 if day == 36
replace clinical_eventdate = spring_clockchange + 8 if day == 37
replace clinical_eventdate = spring_clockchange + 9 if day == 38
replace clinical_eventdate = spring_clockchange + 10 if day == 39
replace clinical_eventdate = spring_clockchange + 11 if day == 40
replace clinical_eventdate = spring_clockchange + 12 if day == 41
replace clinical_eventdate = spring_clockchange + 13 if day == 42
replace clinical_eventdate = spring_clockchange + 14 if day == 43
replace clinical_eventdate = spring_clockchange + 15 if day == 44
replace clinical_eventdate = spring_clockchange + 16 if day == 45
replace clinical_eventdate = spring_clockchange + 17 if day == 46
replace clinical_eventdate = spring_clockchange + 18 if day == 47
replace clinical_eventdate = spring_clockchange + 19 if day == 48
replace clinical_eventdate = spring_clockchange + 20 if day == 49
replace clinical_eventdate = spring_clockchange + 21 if day == 50
replace clinical_eventdate = spring_clockchange + 22 if day == 51
replace clinical_eventdate = spring_clockchange + 23 if day == 52
replace clinical_eventdate = spring_clockchange + 24 if day == 53
replace clinical_eventdate = spring_clockchange + 25 if day == 54
replace clinical_eventdate = spring_clockchange + 26 if day == 55
replace clinical_eventdate = spring_clockchange + 27 if day == 56


format clinical_eventdate %d


*Generate indicator variable which is 1 for Maundy Thursday, Good Friday, Easter Saturday, Easter Sunday, Easter Monday each year
gen easter_wkend = 0
replace easter_wkend = 1 if easter_date - clinical_eventdate == 0 | easter_date - clinical_eventdate == 1 | easter_date - clinical_eventdate == 2 | easter_date - clinical_eventdate == 3 |easter_date - clinical_eventdate == -1 // make 1 for the 5 days of the easter weekend.

*Only keep the variables we need.
keep day count year region easter_wkend 

*Save 
save "eatdis_Spring_allyearsregions_easter.dta", replace

*********************
*Generate days & week after the clock change variables 

cd "projectnumber\analysis\sensitivity\washout\sum_datasets\years_combined"
use eatdis_Spring_allyearsregions_easter.dta, clear

*Generate onewk_after indicator variable 
gen onewk_after = 0
replace onewk_after = 1 if day == 29 | day == 30 | day == 31 | day == 32 | day == 33 | day == 34 | day == 35

*Create a 'days' variable indicating which day of the week the data is for (Sunday-Monday)
gen days=""
replace days="Sunday" if day==1
replace days="Sunday" if day==8
replace days="Sunday" if day==15
replace days="Sunday" if day==22
replace days="Sunday" if day==29
replace days="Sunday" if day==36
replace days="Sunday" if day==43
replace days="Sunday" if day==50


replace days="Monday" if day==2
replace days="Monday" if day==9
replace days="Monday" if day==16
replace days="Monday" if day==23
replace days="Monday" if day==30
replace days="Monday" if day==37
replace days="Monday" if day==44
replace days="Monday" if day==51

replace days="Tuesday" if day==3
replace days="Tuesday" if day==10
replace days="Tuesday" if day==17
replace days="Tuesday" if day==24
replace days="Tuesday" if day==31
replace days="Tuesday" if day==38
replace days="Tuesday" if day==45
replace days="Tuesday" if day==52

replace days="Wednesday" if day==4
replace days="Wednesday" if day==11
replace days="Wednesday" if day==18
replace days="Wednesday" if day==25
replace days="Wednesday" if day==32
replace days="Wednesday" if day==39
replace days="Wednesday" if day==46
replace days="Wednesday" if day==53

replace days="Thursday" if day==5
replace days="Thursday" if day==12
replace days="Thursday" if day==19
replace days="Thursday" if day==26
replace days="Thursday" if day==33
replace days="Thursday" if day==40
replace days="Thursday" if day==47
replace days="Thursday" if day==54


replace days="Friday" if day==6
replace days="Friday" if day==13
replace days="Friday" if day==20
replace days="Friday" if day==27
replace days="Friday" if day==34
replace days="Friday" if day==41
replace days="Friday" if day==48
replace days="Friday" if day==55


replace days="Saturday" if day==7
replace days="Saturday" if day==14
replace days="Saturday" if day==21
replace days="Saturday" if day==28
replace days="Saturday" if day==35
replace days="Saturday" if day==42
replace days="Saturday" if day==49
replace days="Saturday" if day==56

tab days // days are in alphabetical order.
*Reorder the days variable so that it is ordered according to day of the week rather than alphabetical as need it in the right order to create indicator variables.
label define order 1"Sunday" 2"Monday" 3"Tuesday" 4"Wednesday" 5"Thursday" 6"Friday" 7"Saturday"
encode days, gen(days2) label(order)
tab days2 //FYI days2 is no longer a string variable.
drop days
rename days2 days
save "eatdis_Spring_allyearsregions_easter_2.dta", replace


**********************************************************************

*Run regression


**Open log
log using "projectnumber\analysis\logs/washout_eatdis.log", replace

clear
cd "projectnumber\analysis\sensitivity\washout\sum_datasets\years_combined"
use eatdis_Spring_allyearsregions_easter_2.dta, clear
di "eatdis" "Spring: One week after"
eststo model1:nbreg count i.onewk_after i.days i.easter_wkend i.region, irr vce(cluster region)  // count = outcome. onewk_after = exposure. days = covariate. region = covariate.
matrix list r(table) // displays results inc the full p value.
estout model1 using eatdis_Spring_oneweek.txt, eform replace cells("b(label(IRR) fmt(%9.2f)) ci(label(95% CI) fmt(%9.3f)) p(label(p value) fmt(%9.4f))") label stats(N, labels("n") fmt(%9.0g))
*Import regression results & save as excel spreadsheet
import delimited using eatdis_Spring_oneweek.txt, clear
export excel using "projectnumber\analysis\sensitivity\washout\regressions/eatdis_Spring_oneweek.xlsx", replace 

*Get total number of events
cd "projectnumber\analysis\sensitivity\washout\sum_datasets\years_combined"
use eatdis_Spring_allyearsregions_easter_2.dta, clear
di "eatdis" "Spring: One week after."
total(count)

*Close log
log close