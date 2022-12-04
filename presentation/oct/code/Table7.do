****** set the path************************************************
cap cd "/Users/yeabinmoon/Dropbox (UH-ECON)/yeabin"
cap cd "c:/dropbox (UH-ECON)/yeabin" 
// cd "/Users/yeabinmoon/MyFiles/yeabin"
*******************************************************************
clear all

cd "./job market paper/data/"

//import delimited "./df_long3.csv", clear
import delimited "./df_long7.csv", clear

drop v1


tab flag
keep if flag == 0
count
tab degree_date

keep if degree_date >= 2004
encode university, gen(college)
encode name_correct, gen(ID)

encode jel_code, gen(major_field)

label define female 0 "male"
encode gender, gen(female)
replace female = 0 if female == 2

rename usa usa2
label define usa 0 "no"
label define usa 1 "yes", add
encode usa2, gen(usa)
replace usa = 0 if usa == 2
replace usa = 1 if usa == 3

gen usa_imp = usa
replace usa_imp = 0 if missing(usa_imp)

gen female_imp = female
replace female_imp = 1 if missing(female_imp)

egen z1u_rate = std(u_o_rate)
egen flag4 = max(pubs), by(ID)
egen flag1 = max(exp), by(ID)
egen flag2 = max(exp_5), by(ID)
gen flag3 = flag2 / flag1

replace pubs = 0 if missing(pubs)

gen long_outcome1 = 0
replace long_outcome1 = 1 if occupation == 1 & !missing(occupation)

keep if exp == 0 | exp == 2 | exp == 4 | exp == 6 | exp == 8

gen exp0 = 1 if exp == 0
replace exp0 = 0 if missing(exp0)
gen exp2 = 1 if exp == 2
replace exp2 = 0 if missing(exp2)
gen exp4 = 1 if exp == 4
replace exp4 = 0 if missing(exp4)
gen exp6 = 1 if exp == 6
replace exp6 = 0 if missing(exp6)
gen exp8 = 1 if exp == 8
replace exp8 = 0 if missing(exp8)


eststo clear

eststo: reghdfe long_outcome    c.z1u_rate#c.exp0 c.z1u_rate#c.exp2  /*
					 */ c.z1u_rate#c.exp4 c.z1u_rate#c.exp6 /*
					 */ c.z1u_rate#c.exp8 /*
					 */ female_imp usa_imp if exp <= 8, absorb(college major_field exp) vce(cluster degree_date)
eststo: reghdfe long_outcome    c.z1u_rate#c.exp0 c.z1u_rate#c.exp2  /*
					 */ c.z1u_rate#c.exp4 c.z1u_rate#c.exp6 /*
					 */ c.z1u_rate#c.exp8 /*
					 */ female_imp usa_imp outcome1 if exp <= 8, absorb(college major_field exp) vce(cluster degree_date)
esttab, replace se r2 ar2 scalars(F) drop(_cons)  star(* 0.10 ** .05 *** .01) interaction("X") nobaselevels

					 
esttab using "/Users/yeabinmoon/Dropbox (UH-ECON)/JMP/presentations/oct/tables/raw/app1.tex", replace se r2 ar2 scalars(F) drop(_cons) star(* 0.10 ** .05 *** .01) interaction("X") nobaselevels
