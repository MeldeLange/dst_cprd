*Script to save product descriptions to product code lists

*Mel de Lange 08/05/2024

*Product code lists saved as text files with the name as "outcome_product.txt"

*1. Save gold product file (txt) as stata file
cd "...final_code_lists\prescriptions"
import delimited using gold_prod.txt, clear
drop if _n == 1 // Drop first prod code as contains non numeric values (& is the build date)
destring prodcode, replace
save gold_prod, replace

*2. Loop to import product code lists, merge with gold product data dictionary, save as list of product codes & product name in excel
cd "...final_code_lists\prescriptions"

local myfilelist : dir "." files "*product.txt"

di `myfilelist'

foreach file of local myfilelist{
import delimited using `file', varnames(1) clear
	merge 1:1 prodcode using gold_prod.dta
	keep if _merge == 3
	keep prodcode productname
	local outfile = subinstr("`file'","product.txt","",.)
	export excel using "`outfile'prod_desc.xlsx", firstrow(variables) replace
}


