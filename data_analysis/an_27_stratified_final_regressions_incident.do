*an_27_stratified_final_regressions_sociodemog: stratified regressions for the first week after the clock changes vs rest of the weeks, stratified by incident vs prevalent cases

log using "projectnumber\analysis\logs/stratified_final_regressions_incident.log", replace // because having to use 'capture' command this doesn't log the regression outputs from part 1.

*1. Run regressions & save results.

*1a) Autumn
**********
clear
foreach mod in incident{
		cd "projectnumber\analysis\stratified\final\datasets/`mod'/years_combined"

foreach outcome in anx cvd dep eatdis psy selfharm sleep{
		foreach category in 0 1 2 3{
			
local filenames: dir "." files "`outcome'_Autumn_allyearsregions_`mod'`category'_2.dta"
 foreach file in `filenames'{
	 	use `file', clear
capture { // For some analyses convergence is not achieved so have to use capture to get whole loop to run.
*Negative Binomial Regression comparing the mean daily number of events in the week after the clock change to all other weeks, adjusting for day of the week & region.
*onewk_after
di "`outcome'" "Autumn: One week after"
eststo model1:nbreg count i.onewk_after i.days i.region, irr vce(cluster region) // count = outcome. onewk_after = exposure. days = covariate. region = covariate.
matrix list r(table) // displays results inc the full p value.
estout model1 using `outcome'_Autumn_oneweek_`mod'`category'.txt, eform replace cells("b(label(IRR) fmt(%9.2f)) ci(label(95% CI) fmt(%9.3f)) p(label(p value) fmt(%9.4f))") label stats(N, labels("n") fmt(%9.0g))
*Import regression results & save as excel spreadsheet
import delimited using `outcome'_Autumn_oneweek_`mod'`category'.txt, clear
export excel using "projectnumber\analysis\stratified\final\regressions/`mod'/`outcome'_Autumn_oneweek_`mod'`category'.xlsx", replace 
 
 }
		}
}
}
}



*1b) Spring
clear

foreach mod in incident {
	cd "projectnumber\analysis\stratified\final\datasets/`mod'/years_combined"

foreach outcome in anx cvd dep eatdis psy selfharm sleep{
		foreach category in 0 1 2 3{
			
local filenames: dir "." files "`outcome'_Spring_allyearsregions_easter_`mod'`category'_2.dta"
 foreach file in `filenames'{
	 	use `file', clear
capture { // For some analyses convergence is not achieved so have to use capture to get whole loop to run.
*Negative Binomial Regression comparing the mean daily number of events in the week after the clock change to all other weeks, adjusting for day of the week & region.
*onewk_after
di "`outcome'" "Spring: One week after"
eststo model1:nbreg count i.onewk_after i.days i.easter_wkend i.region, irr vce(cluster region)  // count = outcome. onewk_after = exposure. days = covariate. region = covariate.
matrix list r(table) // displays results inc the full p value.
estout model1 using `outcome'_Spring_oneweek_`mod'`category'.txt, eform replace cells("b(label(IRR) fmt(%9.2f)) ci(label(95% CI) fmt(%9.3f)) p(label(p value) fmt(%9.4f))") label stats(N, labels("n") fmt(%9.0g))
*Import regression results & save as excel spreadsheet
import delimited using `outcome'_Spring_oneweek_`mod'`category'.txt, clear
export excel using "projectnumber\analysis\stratified\final\regressions/`mod'/`outcome'_Spring_oneweek_`mod'`category'.xlsx", replace 
 
 }
		}
}
}
}


*2. Get the total number of events included in each of the 1 week analyses (use all the days of data)

*2a) Autumn
clear

foreach mod in incident {
	cd "projectnumber\analysis\stratified\final\datasets/`mod'/years_combined"

foreach outcome in anx cvd dep eatdis psy selfharm sleep{
		foreach category in 0 1 2 3{

		local filenames: dir "." files "`outcome'_Autumn_allyearsregions_`mod'`category'_2.dta"
 foreach file in `filenames'{
	 	use `file', clear
		di "`outcome.'" "Autumn: One week after." "`mod':`category'"
total(count)
		
 }
		}
}
}


*2b) Spring
clear

foreach mod in incident{
	cd "projectnumber\analysis\stratified\final\datasets/`mod'/years_combined"

foreach outcome in anx cvd dep eatdis psy selfharm sleep{
		foreach category in 0 1 2 3{

		local filenames: dir "." files "`outcome'_Spring_allyearsregions_easter_`mod'`category'_2.dta"
 foreach file in `filenames'{
	 	use `file', clear
		di "`outcome.'" "Spring: One week after." "`mod':`category'"
total(count)
		
 }
		}
}
}





*Close log
log close
