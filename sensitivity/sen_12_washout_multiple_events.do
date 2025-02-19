*Sensitivity multiple events - washout period of 8 weeks before each 8-week study period. 
**********************************************************************************************

*For each 8-week study period (4 weeks before & after each clock change) this script removes the events of anyone with an event in weeks 12-4 before the clock change. Then keep the first event in our 8-week study period for everyone left.

************************************************************

*1. Create correct date of clock change variables

foreach outcome in anx cvd dep eatdis psy rti selfharm sleep{
cd "projectnumber\cprd_data\combined\combined_eventlists"
use eventlist_`outcome'_15.dta, clear
drop if clinical_eventdate ==. // drop any events without an event date.
replace em_season = "Spring" if month ==1 // Include January in Spring as we are going 12 weeks back from the clock changes. 
replace em_season = "Autumn" if month ==8 // Include August in Autumn as we are going 12 weeks back from the clock changes.

*Deal with the fact that 12 weeks back from 25th March 2018 is 31st Dec 2017. So this day only needs to be categorised as Spring 2018 and have the Spring 2018 date for the date of the clock change.
replace em_season = "Spring" if clinical_eventdate == mdy(12,31,2017)
replace em_year = 2018 if clinical_eventdate == mdy(12,31,2017)

*Remove & replace data of clock change variable as won't include Jan as Spring or August as Autumn or 31st Dec as Spring.
drop date_clockchange

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

*Save datasets
save "projectnumber\analysis\sensitivity\washout\raw_datasets/washout_`outcome'_1.dta", replace

}

*****************************************************************************************

*2. Identify patids of people who have events in weeks 12-5 before the clock changes.
**************************************************************************************
ssc install unique

*Set working directory
cd "projectnumber\analysis\sensitivity\washout\raw_datasets"

*Extract datasets
foreach outcome in anx cvd dep eatdis psy rti selfharm sleep{
	foreach season in Spring Autumn {
		foreach year in 2008 2009 2010 2011 2012 2013 2014 2015 2016 2017 2018 2019 {			
use "washout_`outcome'_1.dta", clear
keep if em_season == "`season'"	
keep if em_year == `year'
gen remove = 0
replace remove =1 if clinical_eventdate - date_clockchange >= -84  & clinical_eventdate -date_clockchange < -28 // flag people with an event between 12  and 4 weeks before the clock change.
keep if remove ==1
keep patid
unique patid
duplicates drop
unique patid
save "projectnumber\analysis\sensitivity\washout\remove_patids/`outcome'_`year'_`season'_remove.dta", replace
		}
		}
}

************************************************************************************************************

*3. Merge lists of patids to remove with saved datasets & remove all events for those people for that particular clock change.
*Set working directory
cd "projectnumber\analysis\sensitivity\washout\raw_datasets"
foreach outcome in anx cvd dep eatdis psy rti selfharm sleep{
	foreach season in Spring Autumn {
		foreach year in 2008 2009 2010 2011 2012 2013 2014 2015 2016 2017 2018 2019 {			
use "washout_`outcome'_1.dta", clear
keep if em_season == "`season'"	
keep if em_year == `year'
merge m:1 patid using "projectnumber\analysis\sensitivity\washout\remove_patids/`outcome'_`year'_`season'_remove.dta"
drop if _merge ==3 // drop all events for people whose patids are in the list of patids we want to remove.
save "projectnumber\analysis\sensitivity\washout\culled_datasets/`outcome'_`year'_`season'_culled"
		}
	}
}


***********************************************************************************************

*4. Cut down events to those in the 8 weeks around the clock changes.
cd "projectnumber\analysis\sensitivity\washout\culled_datasets"
foreach outcome in anx cvd dep eatdis psy rti selfharm sleep{
	foreach season in Spring Autumn {
		foreach year in 2008 2009 2010 2011 2012 2013 2014 2015 2016 2017 2018 2019 {	
use "`outcome'_`year'_`season'_culled.dta", clear
drop if date_clockchange == . // only events in the correct years and in Spring or Autumn months have a value in the date_clockchange variable.
gen eligible = 0
replace eligible=1 if clinical_eventdate - date_clockchange <=27 & clinical_eventdate - date_clockchange >= -28 // we want to keep 28 days after the clock change including the Sunday of the clock change, so we want the sunday of the clock change plus 27 other days after the clock change. We want 28 days before the clock change.
keep if eligible ==1  // cut events not in 8 week period
drop eligible
tab em_year, missing // check we've only got 2008-2019
tab em_season, missing // check no missing values
tab month, missing // check correct months
save "`outcome'_`year'_`season'_culled_2.dta", replace
		}
	}
}

************************************************************************

*5. Only keep the first event per person for each 8 week period.
cd "projectnumber\analysis\sensitivity\washout\culled_datasets"
foreach outcome in anx cvd dep eatdis psy rti selfharm sleep{
	foreach season in Spring Autumn {
		foreach year in 2008 2009 2010 2011 2012 2013 2014 2015 2016 2017 2018 2019 {	
use "`outcome'_`year'_`season'_culled_2.dta", clear
bys patid (clinical_eventdate):generate clinicaleventdate_n = _n // for each person generate an event number based on clinical event date.
keep if clinicaleventdate_n ==1 // keep the first event per person in that 8 week period.
save "`outcome'_`year'_`season'_culled_3.dta", replace
		}
	}
}



*6. Cut down GP events to those in a valid gp registration period

*Combine registration data with eventlists.

*Save start_end2 dataset in eventlists folder
copy "projectnumber\cprd_data\gold_primary_care_all\stata\registration/start_end2.dta" "projectnumber\analysis\sensitivity\washout\culled_datasets\"

*Combine start_end2 dataset with eventlists & cut down GP events (only) to events within valid registration period
ssc install unique

cd  "projectnumber\analysis\sensitivity\washout\culled_datasets"
foreach outcome in anx cvd dep eatdis psy rti selfharm sleep{
foreach season in Spring Autumn {
		foreach year in 2008 2009 2010 2011 2012 2013 2014 2015 2016 2017 2018 2019 {		
use "`outcome'_`year'_`season'_culled_3.dta", clear
drop _merge
unique patid
merge m:1 patid using start_end2.dta
drop if _merge ==2 // from using
drop _merge
unique patid
gen eligible = 1
replace eligible = 0 if clinical_eventdate <start_date | clinical_eventdate > end_date // only eligible if event is within eligible GP period
replace eligible =1 if code_type == "icd" // being within valid registration period only applies to primary care events
replace eligible = 1 if code_type == "aepatgroup" // being within valid registration period only applies to primary care events
keep if eligible ==1 
unique patid
drop eligible
save "`outcome'_`year'_`season'_culled_4.dta", replace
}
}
}

**********************************************

*7. Cut down eventlists to only those events where the person is in the correct age range at the time of the clock change.
***********************************************************************************************************************
*>=10 for depression, anxiety, sleep, self-harm & eating disorders, psychological conditions
*All ages for road traffic injuries. (don't need to cut down)
*>=40 for cardiovascular disease.

**Mental health outcomes (anxiety, depression, selfharm, eating disorders) (>=10)
cd "projectnumber\analysis\sensitivity\washout\culled_datasets"
foreach outcome in anx dep eatdis psy selfharm sleep{
	foreach season in Spring Autumn {
		foreach year in 2008 2009 2010 2011 2012 2013 2014 2015 2016 2017 2018 2019 {	
use "`outcome'_`year'_`season'_culled_4.dta", clear
keep if age >=10
save "`outcome'_`year'_`season'_culled_5.dta", replace
}
	}
}


*CVD (aged 40 and over)
cd "projectnumber\analysis\sensitivity\washout\culled_datasets"
foreach season in Spring Autumn {
		foreach year in 2008 2009 2010 2011 2012 2013 2014 2015 2016 2017 2018 2019 {
use "cvd_`year'_`season'_culled_4.dta", clear
keep if age >=40
save "cvd_`year'_`season'_culled_5.dta", replace
		}
}



*RTI's (Don't need to cut down but resave existing dataset so numbering (5) is consistent between datasets)
cd "projectnumber\analysis\sensitivity\washout\culled_datasets"
foreach season in Spring Autumn {
		foreach year in 2008 2009 2010 2011 2012 2013 2014 2015 2016 2017 2018 2019 {
use "rti_`year'_`season'_culled_4.dta", clear
save "rti_`year'_`season'_culled_5.dta", replace
		}
}






*Append datasets to be all years & seasons.
clear
cd "projectnumber\analysis\sensitivity\washout\culled_datasets"
foreach outcome in anx cvd dep eatdis psy rti selfharm sleep{
	local filenames : dir "." files "`outcome'*culled_5.dta"
	clear
    if `"`filenames'"' != "" {
                    append using `filenames'
					save "`outcome'_washout.dta", replace
	}
}

