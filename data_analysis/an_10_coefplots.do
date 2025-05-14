*Analysis 10: Coefplots
**************************

*Create coefficient plots for all outcomes for the one week results.


*1. Autumn
*************

*1a) Create the datasets needed
*Extract data for each outcome
cd "projectnumber\analysis\datasets\comparisons\region"
foreach outcome in anx cvd dep eatdis psy rti selfharm sleep{
use "`outcome'_Autumn_allyearsregions2.dta", clear
nbreg count i.onewk_after i.days i.region, irr vce(cluster region)
matrix list r(table) 
matrix irr= r(table)[1, 2] 
matrix lci = r(table)[5,2]
matrix uci = r(table)[6,2]
svmat irr
svmat lci
svmat uci
keep irr1 uci1 lci1
drop if irr1 ==.
rename irr1 irr
rename uci1 uci
rename lci1 lci
gen outcome = "`outcome'"
order outcome irr lci uci
save "projectnumber\analysis\coefplot/autumn_`outcome'.dta", replace
}

*Append the separate outcome datasets together.
clear
cd "projectnumber\analysis\coefplot"
fs "autumn*" // if re-run this it will include the combined dataset & spring datasets so delete combined before re-running!!
foreach f in `r(files)' {
	di "`f'"
	append using "`f'"
	save "autumn.dta", replace
}


*****************************************************************************

*1b) Create coefficient plot

cd "projectnumber\analysis\coefplot"
use autumn.dta, clear
mkmat irr lci uci , matrix(autumn)
matrix rownames autumn= "Anxiety" "Acute CVD" "Depression" "Eating Disorders" "Psychiatric Conditions" "Road Traffic Injuries" "Self-harm" "Sleep Disorders"
matrix colnames autumn = irr lci uci
matrix list autumn
matrix autumn=autumn'
matrix list autumn

*Create variables we need to add the number of events to the plot.
gen x = _n 
gen events = "" 
replace events = "104,004" if x == 1
replace events = "301,509" if x == 2
replace events = "269,065" if x == 3
replace events = "2,754" if x == 4
replace events = "21,073" if x == 5
replace events = "45,864" if x == 6
replace events = "20,414" if x == 7
replace events = "32,146" if x == 8
gen gap = uci +0.012

*Colour individual plot for Autumn
*Vertical code
coefplot matrix(autumn), ci((2 3)) grid(none) ///
plotregion(lc(white)) ///
xline(1, lpattern(shortdash) lwidth(vthin)) ///
msize(small) mcolor(midblue) ///
ciopts(lc(midblue) lwidth(medium)) ///
ylabel(, nogrid labsize(vsmall)) ///
xlabel(, nogrid labsize(vsmall)) ///
xtitle("Incidence Rate Ratio (95% CI)", height(3) size(vsmall)) ///
note(Numbers show total events per outcome in the week after DST transition and control weeks, height(6) size(vsmall)) ///
addplot(scatter x gap, mlabel(events) msymbol(none) mlabpos(0) mlabsize(vsmall) mlabcol(black))
graph save "projectnumber\analysis\coefplot\graphs\colour_separate/autumn", replace
graph export "projectnumber\analysis\coefplot\graphs\colour_separate/autumn.wmf", replace
graph export "projectnumber\analysis\coefplot\graphs\colour_separate/autumn.pdf", as(pdf) replace 
graph export "projectnumber\analysis\coefplot\graphs\colour_separate/autumn.eps", replace

*Black & white version

coefplot matrix(autumn), ci((2 3)) grid(none) ///
graphregion(color(white)) ///
plotregion(lc(white)) ///
xline(1, lpattern(shortdash) lwidth(vthin)) ///
msize(small) ///
ciopts(lwidth(medium)) ///
ylabel(, nogrid labsize(vsmall)) ///
xlabel(, nogrid labsize(vsmall)) /// 
xtitle("Incidence Rate Ratio (95% CI)", height(3) size(vsmall)) ///
note(Numbers show total events per outcome in the week after DST transition and control weeks, height(6) size(vsmall)) ///
addplot(scatter x gap, mlabel(events) msymbol(none) mlabpos(0) mlabsize(vsmall)) 
graph save "projectnumber\analysis\coefplot\graphs\colour_separate/autumn_bw", replace
graph export "projectnumber\analysis\coefplot\graphs\colour_separate/autumn_bw.wmf", replace
graph export "projectnumber\analysis\coefplot\graphs\colour_separate/autumn_bw.pdf", as(pdf) replace 
graph export "projectnumber\analysis\coefplot\graphs\colour_separate/autumn_bw.eps", replace



****************************
*2. Spring
***************
*2a) Create the datasets needed

*Extract data for each outcome
cd "projectnumber\analysis\datasets\comparisons\region"
foreach outcome in anx cvd dep eatdis psy rti selfharm sleep{
use "`outcome'_Spring_regions_easter2.dta", clear
nbreg count i.onewk_after i.days i.easter_wkend i.region, irr vce(cluster region)
matrix list r(table) 
matrix irr= r(table)[1, 2] 
matrix lci = r(table)[5,2]
matrix uci = r(table)[6,2]
svmat irr
svmat lci
svmat uci
keep irr1 uci1 lci1
drop if irr1 ==.
rename irr1 irr
rename uci1 uci
rename lci1 lci
gen outcome = "`outcome'"
order outcome irr lci uci
save "projectnumber\analysis\coefplot/spring_`outcome'.dta", replace
}

*Append the separate outcome datasets together.
clear
cd "projectnumber\analysis\coefplot"
fs "spring*" // if re-run this it will include the combined dataset so delete combined before re-running!!
foreach f in `r(files)' {
	di "`f'"
	append using "`f'"
	save "spring.dta", replace
}

**************************************

*2b) Create coefficient plot
cd "projectnumber\analysis\coefplot"
use spring.dta, clear
mkmat irr lci uci , matrix(spring)
matrix rownames spring= "Anxiety" "Acute CVD" "Depression" "Eating Disorders" "Psychiatric Conditions" "Road Traffic Injuries" "Self-harm" "Sleep Disorders"
matrix colnames spring = irr lci uci
matrix list spring
matrix spring=spring'
matrix list spring

*Create variables we need to ad the number of events to the plot.
gen x = _n 
gen events = "" 
replace events = "94,928" if x == 1
replace events = "298,803" if x == 2
replace events = "258,431" if x == 3
replace events = "2,735" if x == 4
replace events = "19,268" if x == 5
replace events = "41,695" if x == 6
replace events = "20,500" if x == 7
replace events = "31,844" if x == 8
gen gap = uci +0.012

*Colour individual plot for Spring
coefplot matrix(spring), ci((2 3)) grid(none) ///
plotregion(lc(white)) ///
xline(1, lpattern(shortdash) lwidth(vthin)) ///
msize(small) mcolor(midblue) ///
ciopts(lc(midblue) lwidth(medium)) ///
ylabel(, nogrid labsize(vsmall)) ///
xlabel(, nogrid labsize(vsmall)) ///
xtitle("Incidence Rate Ratio (95% CI)", height(3) size(vsmall)) ///
note(Numbers show total events per outcome in the week after DST transition and control weeks, height(6) size(vsmall)) ///
addplot(scatter x gap, mlabel(events) msymbol(none) mlabpos(0) mlabsize(vsmall) mlabcol(black))
graph save "projectnumber\analysis\coefplot\graphs\colour_separate/spring", replace
graph export "projectnumber\analysis\coefplot\graphs\colour_separate/spring.wmf", replace
graph export "projectnumber\analysis\coefplot\graphs\colour_separate/spring.pdf", as(pdf) replace 
graph export "projectnumber\analysis\coefplot\graphs\colour_separate/spring.eps", replace

*Black & white version
coefplot matrix(spring), ci((2 3)) grid(none) ///
graphregion(color(white)) ///
plotregion(lc(white)) ///
xline(1, lpattern(shortdash) lwidth(vthin)) ///
msize(small) ///
ciopts(lwidth(medium)) ///
ylabel(, nogrid labsize(vsmall)) ///
xlabel(, nogrid labsize(vsmall)) /// 
xtitle("Incidence Rate Ratio (95% CI)", height(3) size(vsmall)) ///
note(Numbers show total events per outcome in the week after DST transition and control weeks, height(6) size(vsmall)) ///
addplot(scatter x gap, mlabel(events) msymbol(none) mlabpos(0) mlabsize(vsmall)) 
graph save "projectnumber\analysis\coefplot\graphs\colour_separate/spring_bw", replace
graph export "projectnumber\analysis\coefplot\graphs\colour_separate/spring_bw.wmf", replace
graph export "projectnumber\analysis\coefplot\graphs\colour_separate/spring_bw.pdf", as(pdf) replace 
graph export "projectnumber\analysis\coefplot\graphs\colour_separate/spring_bw.eps", replace



****************************************************************************

*3. Combined black & white graph for the paper.
***************************************************

*Need to have spring & autumn as same figure, panels A&B - make this one black & white.

*3a)Create Panel A - Spring


*Create coefficient plot
cd "projectnumber\analysis\coefplot"
use spring.dta, clear
mkmat irr lci uci , matrix(spring)
matrix rownames spring= "Anxiety" "Acute CVD" "Depression" "Eating Disorders" "Psychiatric Conditions" "Road Traffic Injuries" "Self-harm" "Sleep Disorders"
matrix colnames spring = irr lci uci
matrix list spring
matrix spring=spring'
matrix list spring

*Create variables we need to ad the number of events to the plot.
gen x = _n 
gen events = "" 
replace events = "94,928" if x == 1
replace events = "298,803" if x == 2
replace events = "258,431" if x == 3
replace events = "2,735" if x == 4
replace events = "19,268" if x == 5
replace events = "41,695" if x == 6
replace events = "20,500" if x == 7
replace events = "31,844" if x == 8
gen gap = uci +0.012

*Black & white individual plot for Spring
coefplot matrix(spring), ci((2 3)) grid(none) ///
graphregion(color(white)) ///
plotregion(lc(white)) ///
xline(1, lpattern(shortdash) lwidth(vthin)) ///
msize(small) ///
ciopts(lwidth(medium)) ///
ylabel(, nogrid labsize(vsmall)) ///
xlabel(, nogrid labsize(vsmall)) /// 
xtitle("Incidence Rate Ratio (95% CI)", height(3) size(vsmall)) ///
addplot(scatter x gap, mlabel(events) msymbol(none) mlabpos(0) mlabsize(vsmall)) ///
name(panelA) ///
title ("{bf:Spring}", size(vsmall)) ///
scheme (s2mono)

*************************************

*3b)Create Panel B - Autumn


*Create coefficient plot
cd "projectnumber\analysis\coefplot"
use autumn.dta, clear
mkmat irr lci uci , matrix(autumn)
matrix rownames autumn= "Anxiety" "Acute CVD" "Depression" "Eating Disorders" "Psychiatric Conditions" "Road Traffic Injuries" "Self-harm" "Sleep Disorders"
matrix colnames autumn = irr lci uci
matrix list autumn
matrix autumn=autumn'
matrix list autumn

*Create variables we need to ad the number of events to the plot.
gen x = _n 
gen events = "" 
replace events = "104,004" if x == 1
replace events = "301,509" if x == 2
replace events = "269,065" if x == 3
replace events = "2,754" if x == 4
replace events = "21,073" if x == 5
replace events = "45,864" if x == 6
replace events = "20,414" if x == 7
replace events = "32,146" if x == 8
gen gap = uci +0.012

*Black & white individual plot for Autumn
coefplot matrix(autumn), ci((2 3)) grid(none) ///
graphregion(color(white)) ///
plotregion(lc(white)) ///
xline(1, lpattern(shortdash) lwidth(vthin)) ///
msize(small) ///
ciopts(lwidth(medium)) ///
ylabel(, nogrid labsize(vsmall)) ///
xlabel(, nogrid labsize(vsmall)) /// 
xtitle("Incidence Rate Ratio (95% CI)", height(3) size(vsmall)) ///
addplot(scatter x gap, mlabel(events) msymbol(none) mlabpos(0) mlabsize(vsmall)) ///
name(panelB) ///
title ("{bf:Autumn}", size(vsmall)) ///
scheme (s2mono)

******************************

*Combine the two graphs horizontally

//graph combine panelA panelB, ycommon iscale(1) ///
//note(Numbers represent the total number of events per outcome in the week after DST transition and control weeks, size(vsmall))
//graph save "projectnumber\analysis\coefplot\graphs\combined/combined_horiz", replace
//graph export "projectnumber\analysis\coefplot\graphs\combined/combined_horiz.wmf", replace
//graph export "projectnumber\analysis\coefplot\graphs\combined/combined_horiz.pdf", as(pdf) replace 
//graph export "projectnumber\analysis\coefplot\graphs\combined/combined_horiz.eps", replace

*3c) Combine the two graphs vertically
graph combine panelA panelB, col(1) ycommon ysize(8) ///
note(Numbers show total events per outcome in the week after DST transition and control weeks, size(tiny))
graph save "projectnumber\analysis\coefplot\graphs\combined/combined_vert", replace
graph export "projectnumber\analysis\coefplot\graphs\combined/combined_vert.wmf", replace
graph export "projectnumber\analysis\coefplot\graphs\combined/combined_vert.pdf", as(pdf) replace 
graph export "projectnumber\analysis\coefplot\graphs\combined/combined_vert.eps", replace

