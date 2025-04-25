*an_31 Coefplots
****************

*Update coefplots with eating disorders including data points with no events and including IRR, LCI & UCI on graph.


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
save "projectnumber\analysis\coefplot/final/autumn_`outcome'.dta", replace
}

*Append the separate outcome datasets together.
clear
cd "projectnumber\analysis\coefplot\final"
fs "autumn*" // if re-run this it will include the combined dataset & spring datasets so delete combined before re-running!!
foreach f in `r(files)' {
	di "`f'"
	append using "`f'"
	save "autumn.dta", replace
}


*********************************************

*1b) Create coefficient plot

cd "projectnumber\analysis\coefplot\final"
use autumn.dta, clear
mkmat irr lci uci , matrix(autumn)
matrix rownames autumn= "Anxiety" "Acute CVD" "Depression" "Eating Disorders" "Psychiatric Conditions" "Road Traffic Injuries" "Self-Harm" "Sleep Disorders"
matrix colnames autumn = irr lci uci
matrix list autumn
matrix autumn=autumn'
matrix list autumn

*Create variables we need to add the number of events to the plot.
gen x = _n 
gen info = "" 
replace info = "0.97 (0.947, 0.984)" if x == 1
replace info = "0.98 (0.958, 0.999)" if x == 2
replace info = "0.96 (0.946, 0.970)" if x == 3
replace info = "0.97 (0.878, 1.082)" if x == 4
replace info = "0.94 (0.902, 0.984)" if x == 5
replace info = "0.97 (0.943, 1.003)" if x == 6
replace info = "0.98 (0.929, 1.023)" if x == 7
replace info = "0.92 (0.870, 0.969)" if x == 8
gen gap = uci +0.025


*Colour individual plot for Autumn
*Vertical code
coefplot matrix(autumn), ci((2 3)) grid(none) ///
xscale(log range(0.85 1.1)) ///
plotregion(lc(white)) ///
plotregion(margin(large)) ///
xline(1, lpattern(shortdash) lwidth(vthin) lcolor(gs10)) ///
msize(small) mcolor(midblue) ///
ciopts(lc(midblue) lwidth(medium)) ///
ylabel(, nogrid labsize(vsmall)) ///
xlabel(, nogrid labsize(vsmall)) ///
xtitle("Incidence Rate Ratio (95% CI)", height(3) size(vsmall)) ///
note("Adjusted for day of the week and region. Control period: 4 weeks before & weeks 2-4 after the clock change", height(6) size(vsmall)) ///
addplot(scatter x gap, mlabel(info) msymbol(none) mlabpos(0) mlabsize(vsmall) mlabcol(black))
graph save "projectnumber\analysis\coefplot\final\graphs\colour_separate/autumn", replace
graph export "projectnumber\analysis\coefplot\final\graphs\colour_separate/autumn.wmf", replace
graph export "projectnumber\analysis\coefplot\final\graphs\colour_separate/autumn.pdf", as(pdf) replace 
graph export "projectnumber\analysis\coefplot\final\graphs\colour_separate/autumn.eps", replace



*Black & white version

coefplot matrix(autumn), ci((2 3)) grid(none) ///
xscale(log range(0.85 1.1)) ///
graphregion(color(white)) ///
plotregion(lc(white)) ///
plotregion(margin(large)) ///
xline(1, lpattern(shortdash) lwidth(vthin) lcolor(gs10)) ///
msize(small) mcolor(black) ///
ciopts(lc(black) lwidth(medium)) ///
ylabel(, nogrid labsize(vsmall)) ///
xlabel(, nogrid labsize(vsmall)) /// 
xtitle("Incidence Rate Ratio (95% CI)", height(3) size(vsmall)) ///
note("Adjusted for day of the week and region. Control period: 4 weeks before & weeks 2-4 after the clock change", height(6) size(vsmall)) ///
addplot(scatter x gap, mlabel(info) msymbol(none) mlabpos(0) mlabsize(vsmall) mlabcol(black)) 
graph save "projectnumber\analysis\coefplot\final\graphs\bw_separate/autumn", replace
graph export "projectnumber\analysis\coefplot\final\graphs\bw_separate/autumn.wmf", replace
graph export "projectnumber\analysis\coefplot\final\graphs\bw_separate/autumn.pdf", as(pdf) replace 
graph export "projectnumber\analysis\coefplot\final\graphs\bw_separate/autumn.eps", replace




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
save "projectnumber\analysis\coefplot/final/spring_`outcome'.dta", replace
}


*Append the separate outcome datasets together.
clear
cd "projectnumber\analysis\coefplot\final"
fs "spring*" // if re-run this it will include the combined dataset & spring datasets so delete combined before re-running!!
foreach f in `r(files)' {
	di "`f'"
	append using "`f'"
	save "spring.dta", replace
}

********************

*2b) Create coefficient plot

cd "projectnumber\analysis\coefplot\final"
use spring.dta, clear
mkmat irr lci uci , matrix(spring)
matrix rownames spring= "Anxiety" "Acute CVD" "Depression" "Eating Disorders" "Psychiatric Conditions" "Road Traffic Injuries" "Self-Harm" "Sleep Disorders"
matrix colnames spring = irr lci uci
matrix list spring
matrix spring=spring'
matrix list spring

*Create variables we need to add the number of events to the plot.
gen x = _n 
gen info = "" 
replace info = "0.99 (0.958, 1.029)" if x == 1
replace info = "1.02 (1.005, 1.030)" if x == 2
replace info = "1.00 (0.978, 1.012)" if x == 3
replace info = "1.00 (0.906, 1.104)" if x == 4
replace info = "0.99 (0.932, 1.044)" if x == 5
replace info = "0.99 (0.951, 1.035)" if x == 6
replace info = "1.02 (0.981, 1.065)" if x == 7
replace info = "1.00 (0.965, 1.032)" if x == 8
gen gap = uci +0.025


*Colour individual plot for Spring
*Vertical code
coefplot matrix(spring), ci((2 3)) grid(none) ///
xscale(log range(0.9 1.15)) ///
plotregion(lc(white)) ///
plotregion(margin(large)) ///
xline(1, lpattern(shortdash) lwidth(vthin) lcolor(gs10)) ///
msize(small) mcolor(midblue) ///
ciopts(lc(midblue) lwidth(medium)) ///
ylabel(, nogrid labsize(vsmall)) ///
xlabel(, nogrid labsize(vsmall)) ///
xtitle("Incidence Rate Ratio (95% CI)", height(3) size(vsmall)) ///
note("Adjusted for day of the week, region & 5-day Easter weekend. Control period: 4 weeks before & weeks 2-4 after the clock change", height(6) size(vsmall)) ///
addplot(scatter x gap, mlabel(info) msymbol(none) mlabpos(0) mlabsize(vsmall) mlabcol(black))
graph save "projectnumber\analysis\coefplot\final\graphs\colour_separate/spring", replace
graph export "projectnumber\analysis\coefplot\final\graphs\colour_separate/spring.wmf", replace
graph export "projectnumber\analysis\coefplot\final\graphs\colour_separate/spring.pdf", as(pdf) replace 
graph export "projectnumber\analysis\coefplot\final\graphs\colour_separate/spring.eps", replace


*Black & white version

coefplot matrix(spring), ci((2 3)) grid(none) ///
xscale(log range(0.9 1.15)) ///
graphregion(color(white)) ///
plotregion(lc(white)) ///
plotregion(margin(large)) ///
xline(1, lpattern(shortdash) lwidth(vthin) lcolor(gs10)) ///
msize(small) mcolor(black) ///
ciopts(lc(black) lwidth(medium)) ///
ylabel(, nogrid labsize(vsmall)) ///
xlabel(, nogrid labsize(vsmall)) /// 
xtitle("Incidence Rate Ratio (95% CI)", height(3) size(vsmall)) ///
note("Adjusted for day of the week, region & 5-day Easter weekend. Control period: 4 weeks before & weeks 2-4 after the clock change", height(6) size(vsmall)) ///
addplot(scatter x gap, mlabel(info) msymbol(none) mlabpos(0) mlabsize(vsmall) mlabcol(black)) 
graph save "projectnumber\analysis\coefplot\final\graphs\bw_separate/spring", replace
graph export "projectnumber\analysis\coefplot\final\graphs\bw_separate/spring.wmf", replace
graph export "projectnumber\analysis\coefplot\final\graphs\bw_separate/spring.pdf", as(pdf) replace 
graph export "projectnumber\analysis\coefplot\final\graphs\bw_separate/spring.eps", replace



******************************************************************

*3. Combined black & white graph for the paper.
***************************************************

*Need to have spring & autumn as same figure, panels A&B - make this one black & white.

*3a)Create Panel A - Spring
cd "projectnumber\analysis\coefplot\final"
use spring.dta, clear
mkmat irr lci uci , matrix(spring)
matrix rownames spring= "Anxiety" "Acute CVD" "Depression" "Eating Disorders" "Psychiatric Conditions" "Road Traffic Injuries" "Self-Harm" "Sleep Disorders"
matrix colnames spring = irr lci uci
matrix list spring
matrix spring=spring'
matrix list spring

*Create variables we need to add the number of events to the plot.
gen x = _n 
gen info = "" 
replace info = "0.99 (0.958, 1.029)" if x == 1
replace info = "1.02 (1.005, 1.030)" if x == 2
replace info = "1.00 (0.978, 1.012)" if x == 3
replace info = "1.00 (0.906, 1.104)" if x == 4
replace info = "0.99 (0.932, 1.044)" if x == 5
replace info = "0.99 (0.951, 1.035)" if x == 6
replace info = "1.02 (0.981, 1.065)" if x == 7
replace info = "1.00 (0.965, 1.032)" if x == 8
gen gap = uci +0.05

*Black & white individual plot for Spring
coefplot matrix(spring), ci((2 3)) grid(none) ///
xscale(log range(0.80 1.15)) ///
graphregion(color(white)) ///
plotregion(lc(white)) ///
plotregion(margin(large)) ///
xline(1, lpattern(shortdash) lwidth(vthin) lcolor(gs10)) ///
msize(small) mcolor(black) ///
ciopts(lc(black) lwidth(medium)) ///
ylabel(, nogrid labsize(vsmall)) ///
xlabel(, nogrid labsize(vsmall)) /// 
xtitle("Incidence Rate Ratio (95% CI)", height(3) size(vsmall)) ///
addplot(scatter x gap, mlabel(info) msymbol(none) mlabpos(0) mlabsize(vsmall) mlabcol(black)) ///
name(panelA) ///
title ("{bf:Spring}", size(vsmall))



*************************************

*3b)Create Panel B - Autumn

cd "projectnumber\analysis\coefplot\final"
use autumn.dta, clear
mkmat irr lci uci , matrix(autumn)
matrix rownames autumn= "Anxiety" "Acute CVD" "Depression" "Eating Disorders" "Psychiatric Conditions" "Road Traffic Injuries" "Self-Harm" "Sleep Disorders"
matrix colnames autumn = irr lci uci
matrix list autumn
matrix autumn=autumn'
matrix list autumn

*Create variables we need to add the number of events to the plot.
gen x = _n 
gen info = "" 
replace info = "0.97 (0.947, 0.984)" if x == 1
replace info = "0.98 (0.958, 0.999)" if x == 2
replace info = "0.96 (0.946, 0.970)" if x == 3
replace info = "0.97 (0.878, 1.082)" if x == 4
replace info = "0.94 (0.902, 0.984)" if x == 5
replace info = "0.97 (0.943, 1.003)" if x == 6
replace info = "0.98 (0.929, 1.023)" if x == 7
replace info = "0.92 (0.870, 0.969)" if x == 8
gen gap = uci +0.05

*Black & white individual plot for Autumn
coefplot matrix(autumn), ci((2 3)) grid(none) ///
xscale(log range(0.80 1.15)) ///
graphregion(color(white)) ///
plotregion(lc(white)) ///
plotregion(margin(large)) ///
xline(1, lpattern(shortdash) lwidth(vthin) lcolor(gs10)) ///
msize(small) mcolor(black) ///
ciopts(lc(black) lwidth(medium)) ///
ylabel(, nogrid labsize(vsmall)) ///
xlabel(, nogrid labsize(vsmall)) ///
xtitle("Incidence Rate Ratio (95% CI)", height(3) size(vsmall)) ///
addplot(scatter x gap, mlabel(info) msymbol(none) mlabpos(0) mlabsize(vsmall) mlabcol(black)) ///
name(panelB) ///
title ("{bf:Autumn}", size(vsmall))


***********************************

*3c) Combine the two graphs vertically
graph combine panelA panelB, col(1) ycommon ysize(10) xcommon ///
graphregion(margin(tiny)) plotregion(margin(zero)) ///
note("Adjusted for day of the week, region (& 5-day Easter weekend in Spring). Control period: 4 weeks before & weeks 2-4 after the clock change.", size(tiny))
graph save "projectnumber\analysis\coefplot\final\graphs\combined/combined", replace
graph export "projectnumber\analysis\coefplot\final\graphs\combined/combined.wmf", replace
graph export "projectnumber\analysis\coefplot\final\graphs\combined/combined.pdf", as(pdf) replace 
graph export "projectnumber\analysis\coefplot\final\graphs\combined/combined.eps", replace