*an_32_absolute_values

*Open log
log using "projectnumber\analysis\logs/absolute_values.log", replace


cd "projectnumber\analysis\datasets\comparisons\region"

****Main analysis: 1 wk after.

foreach outcome in anx cvd dep eatdis psy rti selfharm sleep{
	
	use "`outcome'_Spring_regions_easter2.dta", clear
	
*Negative binomial regression comparing the mean daily number of events in the week after the clock change to all other weeks, adjusting for day of the week & the Easter weekend.
*onewk_after
di "`outcome'" "Spring: One week after"
nbreg count i.onewk_after i.days i.easter_wkend i.region, irr vce(cluster region)
predict fitted_counts
tabstat fitted_counts, by(onewk_after) stats(mean sd)

}


foreach outcome in anx cvd dep eatdis psy rti selfharm sleep{
	
use "`outcome'_Autumn_allyearsregions2.dta", clear
	
*Negative binomial regression comparing the mean daily number of events in the week after the clock change to all other weeks, adjusting for day of the week & the Easter weekend.
*onewk_after
di "`outcome'" "Autumn: One week after"
nbreg count i.onewk_after i.days i.region, irr vce(cluster region)
predict fitted_counts
tabstat fitted_counts, by(onewk_after) stats(mean sd)

}

*Secondary analysis - 2 wk analysis - Autumn

cd "projectnumber\analysis\datasets\comparisons\region"
foreach outcome in anx cvd dep eatdis psy rti selfharm sleep{
use "`outcome'_Autumn_allyearsregions2.dta", clear
di "`outcome'" "Autumn: Two weeks after"
nbreg count i.twowk_after i.days i.region, irr vce(cluster region) 
predict fitted_counts
tabstat fitted_counts, by(twowk_after) stats(mean sd)

}


*Secondary analysis - 4 wk analysis - Autumn
cd "projectnumber\analysis\datasets\comparisons\region"
foreach outcome in anx cvd dep eatdis psy rti selfharm sleep{
use "`outcome'_Autumn_allyearsregions2.dta", clear
di "`outcome'" "Autumn: Fourweeks after"
nbreg count i.fourwk_after i.days i.region, irr vce(cluster region) 
predict fitted_counts
tabstat fitted_counts, by(fourwk_after) stats(mean sd)

}

*Secondary analysis - sunday - spring

cd "projectnumber\analysis\datasets\comparisons\region"
foreach outcome in anx cvd dep eatdis psy rti selfharm sleep{
		use "`outcome'_Spring_regions_easter2.dta", clear 
di "`outcome'" "Spring: Sun"
nbreg count i.sun_after i.easter_wkend i.region, irr vce(cluster region)
predict fitted_counts
tabstat fitted_counts, by(sun_after) stats(mean sd)

}


*Secondary analysis - Autumn - Psyc stratified by age,sex, alc


*Sex
clear
cd "projectnumber\analysis\stratified\final\datasets/gender/years_combined"

foreach category in 1 2{
use "psy_Autumn_allyearsregions_gender`category'_2.dta", clear
di "Psy" "Autumn: sex:category `category'"
nbreg count i.onewk_after i.days i.region, irr vce(cluster region)
predict fitted_counts
tabstat fitted_counts, by(onewk_after) stats(mean sd)


}


*Age
clear
cd "projectnumber\analysis\stratified\final\datasets/age/years_combined"

foreach category in 0 1 {
use "psy_Autumn_allyearsregions_age`category'_2.dta", clear
di "Psy" "Autumn: age:category `category'"
nbreg count i.onewk_after i.days i.region, irr vce(cluster region)
predict fitted_counts
tabstat fitted_counts, by(onewk_after) stats(mean sd)


}

*Alcohol
clear
cd "projectnumber\analysis\stratified\final\datasets/alc/years_combined"

foreach category in 1 2 3 {
use "psy_Autumn_allyearsregions_alc`category'_2.dta", clear
di "Psy" "Autumn: alc:category `category'"
nbreg count i.onewk_after i.days i.region, irr vce(cluster region)
predict fitted_counts
tabstat fitted_counts, by(onewk_after) stats(mean sd)


}

*Close log
log close