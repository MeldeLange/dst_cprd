*Analysis 5 - Initial look at residuals
**************************************

*Script creates a graph for each outcome & season with residuals of the number of events per day vs the predicted number of events per day (based on each day of the week).

*Open log
log using "projectnumber\analysis\logs/residuals.log", replace

*1. Prepare datasets
cd "projectnumber\analysis\datasets"

foreach outcome in anx cvd dep eatdis psy rti selfharm sleep{
	foreach season in Spring Autumn {
use long_`outcome'_`season'.dta, clear // Long dataset with 2 variables: "day" (1-57 (day 29=clock change Sunday)) and "count" (number of events that day)

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
replace days="Sunday" if day==57


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

tab days, gen(day_) // this generates indicator variables for each day (day_1 to day_7) (day_1 is Sunday).

******************

*2. Negative binomial regression
di "`outcome'" "`season'"
glm count day_1-day_6, family(nb) link(log) vce(robust)
*Equivalent code for poisson regression: glm count day_1-day_6, family(poisson) vce(robust) // poisson regression of the days Sunday-Friday (with Saturday as the constant) on count (no of events). vce(robust) means we have relaxed the assumption that our residuals are normally distributed.
predict resid_count, res 
*So I now have a dataset with 11 variables: day (1-56), count (no of events per day), days (Sun-Mon), day_1-day_7 (0/1 indicators), resid_count

***************

*3. Create & save line graph of residuals
graph twoway line resid_count day, ///
xtitle("Number of days before/after the clock change", height(5) size(vsmall)) ///
ytitle("Residual of count of events", height(5) size(vsmall)) ///
graphregion(color(white)) plotregion(lc(white)) ylabel(, nogrid) xlabel(, nogrid) ///
xlab(1 "-28" 2 "-27" 3 "-26" 4 "-25" 5 "-24" 6 "-23" 7 "-22" 8 "-21" 9 "-20" 10 "-19" 11 "-18" 12 "-17" 13 "-16" 14 "-15" 15 "-14" 16 "-13" 17 "-12" 18 "-11" 19 "-10" 20 "-9" 21 "-8" 22 "-7" 23 "-6" 24 "-5" 25 "-4" 26 "-3" 27 "-2" 28 "-1" 29 "+1" 30 "+2" 31 "+3" 32 "+4" 33 "+5" 34 "+6" 35 "+7" 36 "+8" 37 "+9" 38 "+10" 39 "+11" 40 "+12" 41 "+13" 42 "+14" 43 "+15" 44 "+16" 45 "+17" 46 "+18" 47 "+19" 48 "+20" 49 "+21" 50 "+22" 51 "+23" 52 "+24" 53 "+25" 54 "+26" 55 "+27" 56 "+28", labsize (tiny)) ///
xline(29, lpattern(shortdash)) ///
yline(0, lpattern(dot)) ///
lcolor(gs0) ///
ylab(,labsize(vsmall)) ///
legend(off)
graph save "projectnumber\analysis\graphs\residuals/`outcome'_`season'_residuals", replace
graph export "projectnumber\analysis\graphs\residuals/`outcome'_`season'_residuals.wmf", replace
graph export "projectnumber\analysis\graphs\residuals/`outcome'_`season'_residuals.pdf", as(pdf) replace 
graph export "projectnumber\analysis\graphs\residuals/`outcome'_`season'_residuals.eps", replace
	}
}

*Close log
log close