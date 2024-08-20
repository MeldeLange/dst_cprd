*dc_15_effect_modifiers_agegroup
*********************************************

*Mel de Lange
*20.8.2024

*Create effect modifier variable for 10-year age group categories.



*Primary care data
cd "projectnumber\cprd_data\final_eventlists\primary_care"
ssc install fs
foreach i in pc{
	fs "*`i'*"
	foreach f in `r(files)' { 
		use `f', clear
gen em_age_cat=.
replace em_age_cat=1 if age <10 
replace em_age_cat=2 if age >=10 & age <20
replace em_age_cat=3 if age >=20 & age <30
replace em_age_cat=4 if age >=30 & age <40
replace em_age_cat=5 if age >=40 & age <50
replace em_age_cat=6 if age >=50 & age <60
replace em_age_cat=7 if age >=60 & age <70
replace em_age_cat=8 if age >=70 & age <80
replace em_age_cat=9 if age >=80 & age <90
replace em_age_cat=10 if age >=90 & age <.
label define em_age_cat_lb 1 "<10" 2 "10-19" 3 "20-29" 4 "30-39" 5"40-49" 6"50-59" 7"60-69" 8 "70-79" 9 "80-89" 10 ">=90"
label values em_age_cat em_age_cat_lb
save "2_`f'", replace
}
}

*******************************************


*HES APC
cd "projectnumber\cprd_data\final_eventlists\hes_apc"
ssc install fs
foreach i in hesapc{
	fs "*`i'*"
	foreach f in `r(files)' { 
		use `f', clear
gen em_age_cat=.
replace em_age_cat=1 if age <10 
replace em_age_cat=2 if age >=10 & age <20
replace em_age_cat=3 if age >=20 & age <30
replace em_age_cat=4 if age >=30 & age <40
replace em_age_cat=5 if age >=40 & age <50
replace em_age_cat=6 if age >=50 & age <60
replace em_age_cat=7 if age >=60 & age <70
replace em_age_cat=8 if age >=70 & age <80
replace em_age_cat=9 if age >=80 & age <90
replace em_age_cat=10 if age >=90 & age <.
label define em_age_cat_lb 1 "<10" 2 "10-19" 3 "20-29" 4 "30-39" 5"40-49" 6"50-59" 7"60-69" 8 "70-79" 9 "80-89" 10 ">=90"
label values em_age_cat em_age_cat_lb
save "2_`f'", replace
}
}



******************************************

*HES A&E
cd "projectnumber\cprd_data\final_eventlists\hes_ae"
ssc install fs
foreach i in hesae{
	fs "*`i'*"
	foreach f in `r(files)' { 
		use `f', clear
gen em_age_cat=.
replace em_age_cat=1 if age <10 
replace em_age_cat=2 if age >=10 & age <20
replace em_age_cat=3 if age >=20 & age <30
replace em_age_cat=4 if age >=30 & age <40
replace em_age_cat=5 if age >=40 & age <50
replace em_age_cat=6 if age >=50 & age <60
replace em_age_cat=7 if age >=60 & age <70
replace em_age_cat=8 if age >=70 & age <80
replace em_age_cat=9 if age >=80 & age <90
replace em_age_cat=10 if age >=90 & age <.
label define em_age_cat_lb 1 "<10" 2 "10-19" 3 "20-29" 4 "30-39" 5"40-49" 6"50-59" 7"60-69" 8 "70-79" 9 "80-89" 10 ">=90"
label values em_age_cat em_age_cat_lb
save "2_`f'", replace
}
}