*Analysis 3: Initial Exploratory Graphs: Number of events per day
****************************************************

*1. Create collapsed datasets of events by day for Spring and Autumn

cd "projectnumber\cprd_data\combined\combined_eventlists"


foreach outcome in anx cvd dep eatdis psy rti selfharm sleep{
	foreach season in Spring Autumn {
use eventlist_`outcome'_18.dta, clear
keep if em_season == "`season'"	


gen day = clinical_eventdate - date_clockchange // generate day of event variable relative to the clock change

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
gen zero = 1 if day ==0
gen plus_1 = 1 if day ==1
gen plus_2 = 1 if day ==2
gen plus_3 = 1 if day ==3
gen plus_4 = 1 if day ==4
gen plus_5 = 1 if day ==5
gen plus_6 = 1 if day ==6
gen plus_7 = 1 if day ==7
gen plus_8 = 1 if day ==8
gen plus_9 = 1 if day ==9
gen plus_10 = 1 if day ==10
gen plus_11 = 1 if day ==11
gen plus_12 = 1 if day ==12
gen plus_13 = 1 if day ==13
gen plus_14 = 1 if day ==14
gen plus_15 = 1 if day ==15
gen plus_16 = 1 if day ==16
gen plus_17 = 1 if day ==17
gen plus_18 = 1 if day ==18
gen plus_19 = 1 if day ==19
gen plus_20 = 1 if day ==20
gen plus_21 = 1 if day ==21
gen plus_22 = 1 if day ==22
gen plus_23 = 1 if day ==23
gen plus_24 = 1 if day ==24
gen plus_25 = 1 if day ==25
gen plus_26 = 1 if day ==26
gen plus_27 = 1 if day ==27




*Create dataset of the counts by day
collapse (count) minus_28 minus_27 minus_26 minus_25 minus_24 minus_23 minus_22 minus_21 minus_20 minus_19 minus_18 minus_17 minus_16 minus_15 minus_14 minus_13 minus_12 minus_11 minus_10 minus_9 minus_8 minus_7 minus_6 minus_5 minus_4 minus_3 minus_2 minus_1 zero plus_1 plus_2 plus_3 plus_4 plus_5 plus_6 plus_7 plus_8 plus_9 plus_10 plus_11 plus_12 plus_13 plus_14 plus_15 plus_16 plus_17 plus_18 plus_19 plus_20 plus_21 plus_22 plus_23 plus_24 plus_25 plus_26 plus_27

*Adjust Sunday of clock change to have 24 hours in it (instead of 23 in Spring & 25 in Autumn)
if "`season'" == "Spring" {
	gen zero_adj = (zero / 23) *24
}
else {
	gen zero_adj = (zero / 25) *24
}

drop zero 
rename zero_adj zero
replace zero = round(zero,1.00)    //round value (no of events) to nearest whole number


save "projectnumber\analysis\datasets/`outcome'_`season'.dta", replace




***********************************************

*2. Reshape datasets from wide to long so can create line graph
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
rename zero count29
rename plus_1 count30
rename plus_2 count31
rename plus_3 count32
rename plus_4 count33
rename plus_5 count34
rename plus_6 count35
rename plus_7 count36
rename plus_8 count37
rename plus_9 count38
rename plus_10 count39
rename plus_11 count40
rename plus_12 count41
rename plus_13 count42
rename plus_14 count43
rename plus_15 count44
rename plus_16 count45
rename plus_17 count46
rename plus_18 count47
rename plus_19 count48
rename plus_20 count49
rename plus_21 count50
rename plus_22 count51
rename plus_23 count52
rename plus_24 count53
rename plus_25 count54
rename plus_26 count55
rename plus_27 count56


gen n =_n

reshape long count, i(n) j(day)


drop n

*Save long version of datasets
save "projectnumber\analysis\datasets/long_`outcome'_`season'.dta", replace


*3. Create line graph of count by day
graph twoway line count day, xtitle("Number of days before/after the clock change", height(5) size(vsmall)) ytitle("Number of events", height(5) size(vsmall)) ///
graphregion(color(white)) plotregion(lc(white)) ylabel(, nogrid) xlabel(, nogrid) ///
xlab(1 "-28" 2 "-27" 3 "-26" 4 "-25" 5 "-24" 6 "-23" 7 "-22" 8 "-21" 9 "-20" 10 "-19" 11 "-18" 12 "-17" 13 "-16" 14 "-15" 15 "-14" 16 "-13" 17 "-12" 18 "-11" 19 "-10" 20 "-9" 21 "-8" 22 "-7" 23 "-6" 24 "-5" 25 "-4" 26 "-3" 27 "-2" 28 "-1" 29 "+1" 30 "+2" 31 "+3" 32 "+4" 33 "+5" 34 "+6" 35 "+7" 36 "+8" 37 "+9" 38 "+10" 39 "+11" 40 "+12" 41 "+13" 42 "+14" 43 "+15" 44 "+16" 45 "+17" 46 "+18" 47 "+19" 48 "+20" 49 "+21" 50 "+22" 51 "+23" 52 "+24" 53 "+25" 54 "+26" 55 "+27" 56 "+28", labsize (tiny)) ///
xline(29, lpattern(shortdash)) ///
lcolor(gs0) ///
ylab(,labsize(vsmall))

graph save "projectnumber\analysis\graphs/`outcome'_`season'_line", replace
graph export "projectnumber\analysis\graphs/`outcome'_`season'_line.wmf", replace
graph export "projectnumber\analysis\graphs/`outcome'_`season'_line.pdf", as(pdf) replace 
graph export "projectnumber\analysis\graphs/`outcome'_`season'_line.eps", replace

	}
}


************************************************
************************************************

