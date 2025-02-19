*Sensitivity 14: 1-week regression for sensitivity analysis with 8 week washout week and first event per person.
*****************************************************************************************************************


**Open log
log using "projectnumber\analysis\logs/washout_regressions.log", replace // because having to use 'capture' command this doesn't log the regression outputs from part 1.

*1. Run regressions & save results.

*1a) Autumn
**********
clear
cd "projectnumber\analysis\sensitivity\washout\sum_datasets\years_combined"

foreach outcome in anx cvd dep eatdis psy rti selfharm sleep{
			local filenames: dir "." files "`outcome'_Autumn_allyearsregions_2.dta"
 foreach file in `filenames'{
	 	use `file', clear
capture { // For some analyses convergence is not achieved so have to use capture to get whole loop to run.
*Negative Binomial Regression comparing the mean daily number of events in the week after the clock change to all other weeks, adjusting for day of the week & region.
*onewk_after
di "`outcome'" "Autumn: One week after"
eststo model1:nbreg count i.onewk_after i.days i.region, irr vce(cluster region) // count = outcome. onewk_after = exposure. days = covariate. region = covariate.
matrix list r(table) // displays results inc the full p value.
estout model1 using `outcome'_Autumn_oneweek.txt, eform replace cells("b(label(IRR) fmt(%9.2f)) ci(label(95% CI) fmt(%9.3f)) p(label(p value) fmt(%9.4f))") label stats(N, labels("n") fmt(%9.0g))
*Import regression results & save as excel spreadsheet
import delimited using `outcome'_Autumn_oneweek.txt, clear
export excel using "projectnumber\analysis\sensitivity\washout\regressions/`outcome'_Autumn_oneweek.xlsx", replace 
 
 }
		}
}



*1b) Spring
clear
cd "projectnumber\analysis\sensitivity\washout\sum_datasets\years_combined"
foreach outcome in anx cvd dep eatdis psy rti selfharm sleep{
	local filenames: dir "." files "`outcome'_Spring_allyearsregions_easter_2.dta"
 foreach file in `filenames'{
	 	use `file', clear
capture { // For some analyses convergence is not achieved so have to use capture to get whole loop to run.
*Negative Binomial Regression comparing the mean daily number of events in the week after the clock change to all other weeks, adjusting for day of the week & region.
*onewk_after
di "`outcome'" "Spring: One week after"
eststo model1:nbreg count i.onewk_after i.days i.easter_wkend i.region, irr vce(cluster region)  // count = outcome. onewk_after = exposure. days = covariate. region = covariate.
matrix list r(table) // displays results inc the full p value.
estout model1 using `outcome'_Spring_oneweek.txt, eform replace cells("b(label(IRR) fmt(%9.2f)) ci(label(95% CI) fmt(%9.3f)) p(label(p value) fmt(%9.4f))") label stats(N, labels("n") fmt(%9.0g))
*Import regression results & save as excel spreadsheet
import delimited using `outcome'_Spring_oneweek.txt, clear
export excel using "projectnumber\analysis\sensitivity\washout\regressions/`outcome'_Spring_oneweek.xlsx", replace 
 
 }
		}
}


*****************************


*2. Get the total number of events included in each of the 1 week analyses (use all the days of data)

*2a) Autumn
clear
cd "projectnumber\analysis\sensitivity\washout\sum_datasets\years_combined"
foreach outcome in anx cvd dep eatdis psy rti selfharm sleep{
local filenames: dir "." files "`outcome'_Autumn_allyearsregions_2.dta"
 foreach file in `filenames'{
	 	use `file', clear
		di "`outcome.'" "Autumn: One week after.
total(count)
		
 }
		}


*2b) Spring
clear
cd "projectnumber\analysis\sensitivity\washout\sum_datasets\years_combined"
foreach outcome in anx cvd dep eatdis psy rti selfharm sleep{
	local filenames: dir "." files "`outcome'_Spring_allyearsregions_easter_2.dta"
 foreach file in `filenames'{
	 	use `file', clear
		di "`outcome.'" "Spring: One week after."
total(count)
		
 }
		}



*Close log
log close



****************************

*3. Check the actual p values of those that are 0.0000
********************************************************
clear
cd "projectnumber\analysis\sensitivity\washout\sum_datasets\years_combined"

*Depression Autumn
use dep_Autumn_allyearsregions_2.dta, clear
nbreg count i.onewk_after i.days i.region, irr vce(cluster region) 
matrix list r(table) // 1.713e-08