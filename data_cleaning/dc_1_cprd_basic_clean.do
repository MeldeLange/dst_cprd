*Basic clean of CPRD GOLD DST Files
************************************
*Mel de Lange 14.3.24

cd "gold_primary_care_all"

*1. Write propgram that reformats all date variables
cap prog drop date
prog def date
foreach k in eventdate sysdate chsdate frd crd tod deathdate uts lcd{
	cap{
		gen `k'2 = date(`k', "DMY")
		format %td `k'2
		drop `k'
		rename `k'2 `k'
		replace `k'=. if `k'>150000
		}
	}
end 



*2. Loop though all clinical, consultation, immunisation, referral, test and therapy files. Import, format date, compress & save as stata file.
	
	*Install fs (file specification) which  lists the names of files in compact form
	ssc install fs
	
	*Loop
foreach i in Clinical Consultation Referral Test Therapy Patient Practice Additional{
	local n=1
	fs "*`i'*"	
	foreach f in `r(files)' {
		import delimited using "`f'", clear
		date
		compress
		save "stata_`i'_`n'", replace
		local n=`n'+1
		}
	}
	
	


*3. Check files look ok & dates formated.
use stata_Clinical_26, clear
describe
browse