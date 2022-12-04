****** set the path************************************************
cap cd "/Users/yeabinmoon/Dropbox (UH-ECON)/yeabin"
cap cd "c:/dropbox (UH-ECON)/yeabin" 
// cd "/Users/yeabinmoon/MyFiles/yeabin"
*******************************************************************
clear all

cd "./job market paper/data/"

//import delimited "./shortrun11.csv", clear
//import delimited "./df_snap4.csv", clear
import delimited "./df_snap7.csv", clear
//import delimited "./df_snap9.csv", clear

drop v1
sort flag
keep if flag == 0
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
drop usa2

gen usa_imp = usa
replace usa_imp = 0 if missing(usa_imp)
gen female_imp = female
replace female_imp = 1 if missing(female_imp)
egen z1u_rate = std(u_o_rate)

label var z1u_rate "unemployment"
label var rank2 "tier"
label define female_imp 1 "female" 0 "male"
label var usa_imp "US bachelor degree"





eststo clear
eststo:reghdfe outcome1 c.z1u_rate i.female_imp i.usa_imp, absorb(college major_field) vce(cluster degree_date)
estadd ysumm
//eststo:reghdfe outcome1 c.z1u_rate i.female_imp i.usa_imp if rank2 == 1, absorb(college major_field) vce(cluster degree_date)
//eststo:reghdfe outcome1 c.z1u_rate i.female_imp i.usa_imp if rank2 != 1, absorb(college major_field) vce(cluster degree_date)
eststo:reghdfe outcome1 c.z1u_rate##i.rank2 i.female_imp i.usa_imp, absorb(major_field) vce(cluster degree_date)
estadd ysumm
test  _b[z1u_rate] + _b[1.rank2#c.z1u_rate] = 0 
test _b[2.rank2#c.z1u_rate] = 0 
test _b[3.rank2#c.z1u_rate] = 0
//di _b[z1u_rate] + _b[2.rank2#c.z1u_rate]

//test  _b[z1u_rate] + _b[3.rank2#c.z1u_rate] = 0 
//di _b[z1u_rate] + _b[3.rank2#c.z1u_rate]

eststo:reghdfe outcome1 c.z1u_rate##c.rank1 i.female_imp i.usa_imp, absorb(major_field) vce(cluster degree_date)
estadd ysumm


eststo:reghdfe outcome1 c.z1u_rate##i.female_imp i.usa_imp, absorb(college major_field) vce(cluster degree_date)
test  _b[z1u_rate] + _b[1.female#c.z1u_rate] = 0 
test  _b[z1u_rate] + _b[1.female#c.z1u_rate] =  _b[z1u_rate]

//di  _b[z1u_rate] + _b[1.female#c.z1u_rate] 

eststo:reghdfe outcome1 c.z1u_rate##i.usa_imp i.female_imp , absorb(college major_field) vce(cluster degree_date)
//di  _b[z1u_rate] + _b[1.usa#c.z1u_rate] 
test  _b[z1u_rate] + _b[1.usa#c.z1u_rate] = 0 
esttab, label replace se r2 ar2 scalars(F) drop(_cons)  star(* 0.10 ** .05 *** .01) interaction("X") nobaselevels


estadd ysumm
estout, label nobaselevels

esttab using "/Users/yeabinmoon/Dropbox (UH-ECON)/JMP/writing/tab/raw_tex/table2.tex", label replace se r2 ar2 scalars(F) drop(_cons) star(* 0.10 ** .05 *** .01) interaction("X") nobaselevels
******************************************
