*Convert read codes to medcodes ready to identify our outcomes
**************************************************************

*Mel de Lange 15.3.24

*Read code lists saved as text files with the name as "outcome_read.txt"

*1. Save gold medical file (txt) as stata file
*cd "...final_code_lists\read"
import delimited using medical.txt, clear
save gold_medical, replace
 

*2. Loop to import Read code lists, merge with gold data dictionary, save as list of read, medcode & read term (excel) & save as list of medcodes (txt & stata files).
*cd "...final_code_lists\read"

local myfilelist : dir "." files "*read.txt"

di `myfilelist'

foreach file of local myfilelist{
import delimited using `file', varnames(1) clear
	merge 1:1 readcode using gold_medical.dta
	keep if _merge == 3
	drop _merge
	local outfile = subinstr("`file'","read.txt","",.)
	export excel using "`outfile'read_med_desc.xlsx", firstrow(variables) replace
	keep medcode
	export delimited using "`outfile'medcodes.txt", novarnames replace
	save "`outfile'medcodes", replace
}
