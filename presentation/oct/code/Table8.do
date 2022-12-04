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



eststo clear
preserve
keep if exp <= 3
egen move_occ = max(move), by(ID)
egen move_job = max(job_switch), by(ID)

eststo a1:reghdfe move_occ c.z1u_rate   female_imp usa_imp if exp == 3, absorb(college major_field category_1) vce(cluster degree_date)
eststo b1:reghdfe move_occ c.z1u_rate##i.category_1  female_imp usa_imp if exp == 3, absorb(college major_field) vce(cluster degree_date)
test  _b[z1u_rate] + _b[2.category_1#c.z1u_rate] = 0 
test  _b[z1u_rate] + _b[3.category_1#c.z1u_rate] = 0 
test  _b[z1u_rate] + _b[4.category_1#c.z1u_rate] = 0 
test  _b[z1u_rate] + _b[5.category_1#c.z1u_rate] = 0 
eststo c1:reghdfe move_job c.z1u_rate female_imp usa_imp if exp == 3, absorb(college major_field category_1) vce(cluster degree_date)
eststo d1:reghdfe move_job c.z1u_rate##i.category_1 female_imp usa_imp if exp == 3, absorb(college major_field) vce(cluster degree_date)
test  _b[z1u_rate] + _b[2.category_1#c.z1u_rate] = 0 
test  _b[z1u_rate] + _b[3.category_1#c.z1u_rate] = 0 
test  _b[z1u_rate] + _b[4.category_1#c.z1u_rate] = 0 
test  _b[z1u_rate] + _b[5.category_1#c.z1u_rate] = 0 
restore



preserve
keep if exp <= 8
egen move_occ = max(move), by(ID)
egen move_job = max(job_switch), by(ID)
eststo a2:reghdfe move_occ c.z1u_rate   female_imp usa_imp if exp == 8, absorb(college major_field category_1) vce(cluster degree_date)
eststo b2:reghdfe move_occ c.z1u_rate##i.category_1  female_imp usa_imp if exp == 8, absorb(college major_field) vce(cluster degree_date)
test  _b[z1u_rate] + _b[2.category_1#c.z1u_rate] = 0 
test  _b[z1u_rate] + _b[3.category_1#c.z1u_rate] = 0 
test  _b[z1u_rate] + _b[4.category_1#c.z1u_rate] = 0 
test  _b[z1u_rate] + _b[5.category_1#c.z1u_rate] = 0 
eststo c2:reghdfe move_job c.z1u_rate female_imp usa_imp if exp == 8, absorb(college major_field category_1) vce(cluster degree_date)
eststo d2:reghdfe move_job c.z1u_rate##i.category_1 female_imp usa_imp if exp == 8, absorb(college major_field) vce(cluster degree_date)
test  _b[z1u_rate] + _b[2.category_1#c.z1u_rate] = 0 
test  _b[z1u_rate] + _b[3.category_1#c.z1u_rate] = 0 
test  _b[z1u_rate] + _b[4.category_1#c.z1u_rate] = 0 
test  _b[z1u_rate] + _b[5.category_1#c.z1u_rate] = 0 
esttab a1 b1 a2 b2 c1 d1  c2 d2, replace se r2 ar2 scalars(F) drop(_cons)  star(* 0.10 ** .05 *** .01) nobaselevels
restore

esttab a1 b1 a2 b2 c1 d1  c2 d2 using "/Users/yeabinmoon/Dropbox (UH-ECON)/JMP/presentations/oct/tables/raw/table8.tex", replace se r2 ar2 scalars(F) drop(_cons)  star(* 0.10 ** .05 *** .01)



esttab a1 b1




eststo clear
preserve
keep if exp <= 2
egen move_occ = max(move), by(ID)
egen move_job = max(job_switch), by(ID)
eststo tab_o_1:reghdfe move_occ z1u_rate female_imp usa_imp ib4.category_1 if exp == 2, absorb(college major_field) vce(cluster degree_date)
eststo tab_j_1:reghdfe move_job z1u_rate female_imp usa_imp ib4.category_1 if exp == 2, absorb(college major_field) vce(cluster degree_date)
restore


preserve
keep if exp <= 4
egen move_occ = max(move), by(ID)
egen move_job = max(job_switch), by(ID)
eststo tab_o_2:reghdfe move_occ z1u_rate female_imp usa_imp ib4.category_1 if exp == 4, absorb(college major_field) vce(cluster degree_date)
eststo tab_j_2:reghdfe move_job z1u_rate female_imp usa_imp ib4.category_1 if exp == 4, absorb(college major_field) vce(cluster degree_date)
restore

preserve
keep if exp <= 6
egen move_occ = max(move), by(ID)
egen move_job = max(job_switch), by(ID)
eststo tab_o_3:reghdfe move_occ z1u_rate female_imp usa_imp ib4.category_1 if exp == 6, absorb(college major_field) vce(cluster degree_date)
eststo tab_j_3:reghdfe move_job z1u_rate female_imp usa_imp ib4.category_1 if exp == 6, absorb(college major_field) vce(cluster degree_date)
restore

preserve
keep if exp <= 8
egen move_occ = max(move), by(ID)
egen move_job = max(job_switch), by(ID)
eststo tab_o_4:reghdfe move_occ z1u_rate female_imp usa_imp ib4.category_1 if exp == 8, absorb(college major_field) vce(cluster degree_date)
eststo tab_j_4:reghdfe move_job z1u_rate female_imp usa_imp ib4.category_1 if exp == 8, absorb(college major_field) vce(cluster degree_date)
restore
esttab tab_o_1 tab_o_2 tab_o_3 tab_o_4 tab_j_1 tab_j_2 tab_j_3 tab_j_4, replace se r2 ar2 scalars(F) drop(_cons)  star(* 0.10 ** .05 *** .01) nobaselevels
esttab tab_o_1 tab_o_2 tab_o_3 tab_o_4 tab_j_1 tab_j_2 tab_j_3 tab_j_4 using "/Users/yeabinmoon/Dropbox (UH-ECON)/JMP/writing/tab/raw_tex/table8.tex", replace se r2 ar2 scalars(F) drop(_cons)  star(* 0.10 ** .05 *** .01)
