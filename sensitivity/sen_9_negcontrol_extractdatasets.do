*Sensitivity 9: Negative control - extract summary datasets.
*************************************************************


*1. Merge region data with eventlist
*************************************
*1a)Create region variable in eventlist
cd "projectnumber\analysis\sensitivity\negative_control\raw_datasets"
foreach outcome in anx cvd dep eatdis psy rti selfharm sleep{
use negcontrol_`outcome'_4.dta, clear
tostring patid, gen(patid_string) format (%12.0f) // turn patid into string var
gen pracid =substr(patid_string,-5,5) // create pracid var from the last 5 characters of patid_string
drop patid_string
destring pracid, replace  // convert pracid to numeric 
save negcontrol_`outcome'_5.dta, replace
}

*1b)Merge region data with eventlist
cd "projectnumber\cprd_data\gold_primary_care_all\stata\region"
foreach outcome in anx cvd dep eatdis psy rti selfharm sleep{
use practice.dta, clear
merge 1:m pracid using "projectnumber\analysis\sensitivity\negative_control\raw_datasets/negcontrol_`outcome'_5.dta"
drop if _merge ==1 
drop _merge
save "projectnumber\analysis\sensitivity\negative_control\raw_datasets/negcontrol_`outcome'_6.dta", replace
}



*2. Extract the datasets, then combine year & region data for each outcome / season.
***********************************************************************************************************************************

*2a) Extact datasets by outcome, season, year and region.

*Set working directory
cd "projectnumber\analysis\sensitivity\negative_control\raw_datasets"

*Extract datasets
foreach outcome in anx cvd dep eatdis psy rti selfharm sleep{
	foreach season in Spring Autumn {
		foreach year in 2008 2009 2010 2011 2012 2013 2014 2015 2016 2017 2018 2019 {
			foreach region in 1 2 3 4 5 6 7 8 9{ // we only have regions 1-9 as England-only study
capture{
use negcontrol_`outcome'_6.dta, clear
keep if em_season == "`season'"	
keep if em_year == `year'
keep if region == `region'

gen day = clinical_eventdate - date_negcontrol // generate day of event variable relative to the negative control

gen minus_28 = 1 if day ==-28
gen minus_27 = 1 if day ==-27
gen minus_26 = 1 if day ==-26
gen minus_25 = 1 if day ==-25
gen minus_24 = 1 if day ==-24
gen minus_23 = 1 if day ==-23
gen minus_22 = 1 if day ==-22
gen minus_21 = 1 if day ==-21
gen minus_20 = 1 if day ==-20
gen minus_19 = 1 if day ==-19
gen minus_18 = 1 if day ==-18
gen minus_17 = 1 if day ==-17
gen minus_16 = 1 if day ==-16
gen minus_15 = 1 if day ==-15
gen minus_14 = 1 if day ==-14
gen minus_13 = 1 if day ==-13
gen minus_12 = 1 if day ==-12
gen minus_11 = 1 if day ==-11
gen minus_10 = 1 if day ==-10
gen minus_9 = 1 if day ==-9
gen minus_8 = 1 if day ==-8
gen minus_7 = 1 if day ==-7
gen minus_6 = 1 if day ==-6
gen minus_5 = 1 if day ==-5
gen minus_4 = 1 if day ==-4
gen minus_3 = 1 if day ==-3
gen minus_2 = 1 if day ==-2
gen minus_1 = 1 if day ==-1
gen plus_1 = 1 if day ==0
gen plus_2= 1 if day ==1
gen plus_3 = 1 if day ==2
gen plus_4 = 1 if day ==3
gen plus_5 = 1 if day ==4
gen plus_6 = 1 if day ==5
gen plus_7 = 1 if day ==6
gen plus_8= 1 if day ==7
gen plus_9 = 1 if day ==8
gen plus_10  = 1 if day ==9
gen plus_11= 1 if day ==10
gen plus_12 = 1 if day ==11
gen plus_13 = 1 if day ==12
gen plus_14 = 1 if day ==13
gen plus_15 = 1 if day ==14
gen plus_16 = 1 if day ==15
gen plus_17 = 1 if day ==16
gen plus_18 = 1 if day ==17
gen plus_19 = 1 if day ==18
gen plus_20 = 1 if day ==19
gen plus_21 = 1 if day ==20
gen plus_22 = 1 if day ==21
gen plus_23 = 1 if day ==22
gen plus_24 = 1 if day ==23
gen plus_25 = 1 if day ==24
gen plus_26 = 1 if day ==25
gen plus_27 = 1 if day ==26
gen plus_28 = 1 if day ==27




*Create dataset of the counts by day
collapse (count) minus_28 minus_27 minus_26 minus_25 minus_24 minus_23 minus_22 minus_21 minus_20 minus_19 minus_18 minus_17 minus_16 minus_15 minus_14 minus_13 minus_12 minus_11 minus_10 minus_9 minus_8 minus_7 minus_6 minus_5 minus_4 minus_3 minus_2 minus_1 plus_1 plus_2 plus_3 plus_4 plus_5 plus_6 plus_7 plus_8 plus_9 plus_10 plus_11 plus_12 plus_13 plus_14 plus_15 plus_16 plus_17 plus_18 plus_19 plus_20 plus_21 plus_22 plus_23 plus_24 plus_25 plus_26 plus_27 plus_28

*NB - Don't need to adjust for the Sunday of the negative control having a different number of hours in it than other days...



*Reshape dataset from wide to long
rename minus_28 count1
rename minus_27 count2
rename minus_26 count3
rename minus_25 count4
rename minus_24 count5
rename minus_23 count6
rename minus_22 count7
rename minus_21 count8
rename minus_20 count9
rename minus_19 count10
rename minus_18 count11
rename minus_17 count12
rename minus_16 count13
rename minus_15 count14
rename minus_14 count15
rename minus_13 count16
rename minus_12 count17
rename minus_11 count18
rename minus_10 count19
rename minus_9 count20
rename minus_8 count21
rename minus_7 count22
rename minus_6 count23
rename minus_5 count24
rename minus_4 count25
rename minus_3 count26
rename minus_2 count27
rename minus_1 count28
rename plus_1 count29
rename plus_2 count30
rename plus_3 count31
rename plus_4 count32
rename plus_5 count33
rename plus_6 count34
rename plus_7 count35
rename plus_8 count36
rename plus_9 count37
rename plus_10 count38
rename plus_11 count39
rename plus_12 count40
rename plus_13 count41
rename plus_14 count42
rename plus_15 count43
rename plus_16 count44
rename plus_17 count45
rename plus_18 count46
rename plus_19 count47
rename plus_20 count48
rename plus_21 count49
rename plus_22 count50
rename plus_23 count51
rename plus_24 count52
rename plus_25 count53
rename plus_26 count54
rename plus_27 count55
rename plus_28 count56


gen n =_n

reshape long count, i(n) j(day)


drop n

gen year = `year'
gen region =`region'

*Save datasets
save "projectnumber\analysis\sensitivity\negative_control\sum_datasets/`outcome'_`season'_`year'_`region'.dta", replace
}
}
}
		
}
}


***************************************************

*3. Append the collapsed datasets so all years & regions together for each outcome by level of age, seasons separately.
clear
*3a) Combine the regions for each year into one dataset
	cd "projectnumber\analysis\sensitivity\negative_control\sum_datasets"
foreach outcome in anx cvd dep eatdis psy rti selfharm sleep {
    foreach season in Spring Autumn {
        foreach year in 2008 2009 2010 2011 2012 2013 2014 2015 2016 2017 2018 2019 {
                local filenames: dir "." files "`outcome'_`season'_`year'_*.dta"
                clear
                if `"`filenames'"' != "" {
                    append using `filenames'
                    save "projectnumber\analysis\sensitivity\negative_control\sum_datasets\regions_combined/`outcome'_`season'_`year'_allregions.dta", replace
    
            }    
        }
    }
}


*3 b)Combine the years for each outcome/season/effet modifier category into one dataset
clear
cd "projectnumber\analysis\sensitivity\negative_control\sum_datasets\regions_combined"
foreach outcome in anx cvd dep eatdis psy rti selfharm sleep{
	foreach season in Spring Autumn{
                local filenames: dir "." files "`outcome'_`season'_*_allregions.dta"
                clear
                if `"`filenames'"' != "" {
                    append using `filenames'
                    save "projectnumber\analysis\sensitivity\negative_control\sum_datasets\years_combined/`outcome'_`season'_allyearsregions.dta", replace
                }  
            }    
        }
   

   
********************************************************

*4. Create indicator variables needed for analysis
***************************************************
*4a) In Spring datasets create indicator variable for 5 days of the Easter weekend (inc Maundy Thursday)
clear
	cd "projectnumber\analysis\sensitivity\negative_control\sum_datasets\years_combined"
foreach outcome in anx cvd dep eatdis psy rti selfharm sleep{
	use "`outcome'_Spring_allyearsregions.dta", clear

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


*Enter Spring negative control dates
gen spring_negcontrol = mdy(3,2,2008)
replace spring_negcontrol= mdy(3,1,2009) if year ==2009
replace spring_negcontrol = mdy(2,28,2010) if year ==2010
replace spring_negcontrol = mdy(2,27,2011) if year ==2011
replace spring_negcontrol = mdy(2,26,2012) if year ==2012
replace spring_negcontrol = mdy(3,3,2013) if year ==2013
replace spring_negcontrol = mdy(3,2,2014) if year ==2014
replace spring_negcontrol = mdy(3,1,2015) if year ==2015
replace spring_negcontrol = mdy(2,28,2016) if year ==2016
replace spring_negcontrol = mdy(2,26,2017) if year ==2017
replace spring_negcontrol = mdy(2,25,2018) if year ==2018
replace spring_negcontrol = mdy(3,3,2019) if year ==2019
*Format spring negative control variable to date
format spring_negcontrol %d


*Re-generate clinical eventdate
gen clinical_eventdate= spring_negcontrol
replace clinical_eventdate = spring_negcontrol - 28 if day == 1
replace clinical_eventdate = spring_negcontrol - 27 if day == 2
replace clinical_eventdate = spring_negcontrol - 26 if day == 3
replace clinical_eventdate = spring_negcontrol - 25 if day == 4
replace clinical_eventdate = spring_negcontrol - 24 if day == 5
replace clinical_eventdate = spring_negcontrol- 23 if day == 6
replace clinical_eventdate = spring_negcontrol - 22 if day == 7
replace clinical_eventdate = spring_negcontrol - 21 if day == 8
replace clinical_eventdate = spring_negcontrol - 20 if day == 9
replace clinical_eventdate = spring_negcontrol - 19 if day == 10
replace clinical_eventdate = spring_negcontrol - 18 if day == 11
replace clinical_eventdate = spring_negcontrol - 17 if day == 12
replace clinical_eventdate = spring_negcontrol - 16 if day == 13
replace clinical_eventdate = spring_negcontrol - 15 if day == 14
replace clinical_eventdate = spring_negcontrol - 14 if day == 15
replace clinical_eventdate = spring_negcontrol - 13 if day == 16
replace clinical_eventdate = spring_negcontrol - 12 if day == 17
replace clinical_eventdate = spring_negcontrol - 11 if day == 18
replace clinical_eventdate = spring_negcontrol - 10 if day == 19
replace clinical_eventdate = spring_negcontrol - 9 if day == 20
replace clinical_eventdate = spring_negcontrol - 8 if day == 21
replace clinical_eventdate = spring_negcontrol - 7 if day == 22
replace clinical_eventdate = spring_negcontrol - 6 if day == 23
replace clinical_eventdate = spring_negcontrol - 5 if day == 24
replace clinical_eventdate = spring_negcontrol - 4 if day == 25
replace clinical_eventdate = spring_negcontrol - 3 if day == 26
replace clinical_eventdate = spring_negcontrol - 2 if day == 27
replace clinical_eventdate = spring_negcontrol - 1 if day == 28

replace clinical_eventdate = spring_negcontrol + 1 if day == 30
replace clinical_eventdate = spring_negcontrol + 2 if day == 31
replace clinical_eventdate = spring_negcontrol + 3 if day == 32
replace clinical_eventdate = spring_negcontrol + 4 if day == 33
replace clinical_eventdate = spring_negcontrol + 5 if day == 34
replace clinical_eventdate = spring_negcontrol + 6 if day == 35
replace clinical_eventdate = spring_negcontrol + 7 if day == 36
replace clinical_eventdate = spring_negcontrol + 8 if day == 37
replace clinical_eventdate = spring_negcontrol + 9 if day == 38
replace clinical_eventdate = spring_negcontrol + 10 if day == 39
replace clinical_eventdate = spring_negcontrol + 11 if day == 40
replace clinical_eventdate = spring_negcontrol + 12 if day == 41
replace clinical_eventdate = spring_negcontrol + 13 if day == 42
replace clinical_eventdate = spring_negcontrol + 14 if day == 43
replace clinical_eventdate = spring_negcontrol + 15 if day == 44
replace clinical_eventdate = spring_negcontrol + 16 if day == 45
replace clinical_eventdate = spring_negcontrol + 17 if day == 46
replace clinical_eventdate = spring_negcontrol + 18 if day == 47
replace clinical_eventdate = spring_negcontrol + 19 if day == 48
replace clinical_eventdate = spring_negcontrol + 20 if day == 49
replace clinical_eventdate = spring_negcontrol + 21 if day == 50
replace clinical_eventdate = spring_negcontrol + 22 if day == 51
replace clinical_eventdate = spring_negcontrol + 23 if day == 52
replace clinical_eventdate = spring_negcontrol + 24 if day == 53
replace clinical_eventdate = spring_negcontrol + 25 if day == 54
replace clinical_eventdate = spring_negcontrol + 26 if day == 55
replace clinical_eventdate = spring_negcontrol + 27 if day == 56


format clinical_eventdate %d


*Generate indicator variable which is 1 for Maundy Thursday, Good Friday, Easter Saturday, Easter Sunday, Easter Monday each year
gen easter_wkend = 0
replace easter_wkend = 1 if easter_date - clinical_eventdate == 0 | easter_date - clinical_eventdate == 1 | easter_date - clinical_eventdate == 2 | easter_date - clinical_eventdate == 3 |easter_date - clinical_eventdate == -1 // make 1 for the 5 days of the easter weekend.

*Only keep the variables we need.
keep day count year easter_wkend region

*Save 
save "`outcome'_Spring_allyearsregions_easter.dta", replace

}


***********************************************************


*4b) Create the extra variables we need for the week comparisons in all datasets

cd "projectnumber\analysis\sensitivity\negative_control\sum_datasets\years_combined"
foreach outcome in anx cvd dep eatdis psy rti selfharm sleep{
	foreach dataset in Spring_allyearsregions_easter Autumn_allyearsregions{
use "`outcome'_`dataset'.dta", clear

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

*Create week variables we need

*onewk_after
gen onewk_after = 0
replace onewk_after = 1 if day == 29 | day == 30 | day == 31 | day == 32 | day == 33 | day == 34 | day == 35

*Save datasets
save "`outcome'_`dataset'_2", replace
	}
}
