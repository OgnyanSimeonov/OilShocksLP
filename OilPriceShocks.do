clear all
graph drop _all
cap drop all
import excel "\\ptg01\RoamingProfiles\osimeono\Desktop\TSProjectData.xlsx", sheet("Data") firstrow clear
describe
summarize

*
*
*
*

*OIL PRICES ON OIL PRICES

*
*
*
*


*tsset time = _n
tsset time

reg DeflatedOilPrice INDPRO_PC1 UNRATE RealInterestRate Inflation, robust
predict res
gen dres = d.res

gen dDeflatedOilPrice = d.DeflatedOilPrice

* Choose impulse response horizon
local hmax = 24

/* Generate LHS variables for the LPs */

* levels
forvalues h = 0/`hmax' {
	gen res_`h' = f`h'.res
}

* differences
forvalues h = 0/`hmax' {
	gen res`h' = f`h'.res - l.f`h'.res
}

* Cumulative
forvalues h = 0/`hmax' {
	gen resc`h' = f`h'.res - l.res
}

 
/* Run the LPs */
* Levels
eststo clear
cap drop b u d Years Zero
gen Years = _n-1 if _n<=`hmax'
gen Zero =  0    if _n<=`hmax'
gen b=0
gen u=0
gen d=0
forv h = 0/`hmax' {
	* levels
	 newey res_`h' l(0/4).DeflatedOilPrice l(1/12).res, lag(`h')
replace b = _b[DeflatedOilPrice]                    if _n == `h'+1
replace u = _b[DeflatedOilPrice] + 1.645* _se[DeflatedOilPrice]  if _n == `h'+1
replace d = _b[DeflatedOilPrice] - 1.645* _se[DeflatedOilPrice]  if _n == `h'+1
eststo
}
* nois esttab , se nocons keep(gs1)
gen b_level = b

* Differences
eststo clear
cap drop b u d Years Zero
gen Years = _n-1 if _n<=`hmax'
gen Zero =  0    if _n<=`hmax'
gen b=0
gen u=0
gen d=0
forv h = 0/`hmax' {
	 newey res`h' l(0/4).dDeflatedOilPrice l(1/12).dres, lag(`h')
replace b = _b[dDeflatedOilPrice]                     if _n == `h'+1
replace u = _b[dDeflatedOilPrice] + 1.645* _se[dDeflatedOilPrice]  if _n == `h'+1
replace d = _b[dDeflatedOilPrice] - 1.645* _se[dDeflatedOilPrice]  if _n == `h'+1
eststo
}
* nois esttab , se nocons keep(dgs1)

twoway ///
(rarea u d  Years,  ///
fcolor(gs13) lcolor(gs13) lw(none) lpattern(solid)) ///
(line b Years, lcolor(blue) ///
lpattern(solid) lwidth(thick)) ///
(line Zero Years, lcolor(black)), legend(off) ///
title("Impulse response of " " Deflated Oil Price to 1pp shock to Oil Prices", color(black) size(medsmall)) ///
ytitle("Percent", size(medsmall)) xtitle("Year", size(medsmall)) ///
graphregion(color(white)) plotregion(color(white))

gr rename fig_diff, replace

* Cumulative
eststo clear
cap drop b u d Years Zero
gen Years = _n-1 if _n<=`hmax'
gen Zero =  0    if _n<=`hmax'
gen b=0
gen u=0
gen d=0
forv h = 0/`hmax' {
	 newey resc`h' l(0/4).dDeflatedOilPrice l(1/12).dres, lag(`h')
replace b = _b[dDeflatedOilPrice]                     if _n == `h'+1
replace u = _b[dDeflatedOilPrice] + 1.645* _se[dDeflatedOilPrice]  if _n == `h'+1
replace d = _b[dDeflatedOilPrice] - 1.645* _se[dDeflatedOilPrice]  if _n == `h'+1
eststo
}
* nois esttab , se nocons keep(dgs1)

twoway ///
(rarea u d  Years,  ///
fcolor(gs13) lcolor(gs13) lw(none) lpattern(solid)) ///
(line b Years, lcolor(blue) lpattern(solid) lwidth(thick)) ///
(line Zero Years, lcolor(black)), legend(off) ///
title("Cumulative response of" "Deflated Oil Price to 1pp shock to Oil Prices", color(black) size(medsmall)) ///
subtitle("Levels on levels", color(black) size(small)) ///
ytitle("Percent", size(medsmall)) xtitle("Month", size(medsmall)) ///
graphregion(color(white)) plotregion(color(white))

gr rename fig_cum, replace

gr combine fig_diff fig_cum, ///
graphregion(color(white)) plotregion(color(white)) ///
title("Levels and cumulated impulse responses") ///
note("Note: 90% confidence bands displayed")

*
*
*
*
*INDUSTRIAL PRODUCTION
*
*
*
*
clear all
import excel "\\ptg01\RoamingProfiles\osimeono\Desktop\TSProjectData.xlsx", sheet("Data") firstrow clear

*tsset time = _n
tsset time

gen dINDPRO_PC1 = d.INDPRO_PC1
gen dDeflatedOilPrice = d.DeflatedOilPrice

* Choose impulse response horizon
local hmax = 24

/* Generate LHS variables for the LPs */

* levels
forvalues h = 0/`hmax' {
	gen INDPRO_PC1_`h' = f`h'.INDPRO_PC1
}

* differences
forvalues h = 0/`hmax' {
	gen INDPRO_PC1d`h' = f`h'.INDPRO_PC1 - l.f`h'.INDPRO_PC1 
}

* Cumulative
forvalues h = 0/`hmax' {
	gen INDPRO_PC1c`h' = f`h'.INDPRO_PC1 - l.INDPRO_PC1 
}

 
/* Run the LPs */
* Levels
eststo clear
cap drop b u d Years Zero
gen Years = _n-1 if _n<=`hmax'
gen Zero =  0    if _n<=`hmax'
gen b=0
gen u=0
gen d=0
forv h = 0/`hmax' {
	* levels
	 newey INDPRO_PC1_`h' l(0/4).DeflatedOilPrice l(1/3).INDPRO_PC1, lag(`h')
replace b = _b[DeflatedOilPrice]                    if _n == `h'+1
replace u = _b[DeflatedOilPrice] + 1.645* _se[DeflatedOilPrice]  if _n == `h'+1
replace d = _b[DeflatedOilPrice] - 1.645* _se[DeflatedOilPrice]  if _n == `h'+1
eststo
}
* nois esttab , se nocons keep(gs1)
gen b_level = b

* Differences
eststo clear
cap drop b u d Years Zero
gen Years = _n-1 if _n<=`hmax'
gen Zero =  0    if _n<=`hmax'
gen b=0
gen u=0
gen d=0
forv h = 0/`hmax' {
	 newey INDPRO_PC1d`h' l(0/4).dDeflatedOilPrice l(1/3).dINDPRO_PC1, lag(`h')
replace b = _b[dDeflatedOilPrice]                     if _n == `h'+1
replace u = _b[dDeflatedOilPrice] + 1.645* _se[dDeflatedOilPrice]  if _n == `h'+1
replace d = _b[dDeflatedOilPrice] - 1.645* _se[dDeflatedOilPrice]  if _n == `h'+1
eststo
}
* nois esttab , se nocons keep(dgs1)

twoway ///
(rarea u d  Years,  ///
fcolor(gs13) lcolor(gs13) lw(none) lpattern(solid)) ///
(line b Years, lcolor(blue) ///
lpattern(solid) lwidth(thick)) ///
(line Zero Years, lcolor(black)), legend(off) ///
title("Impulse response of " " Industrial Production to 1pp shock to Oil Prices", color(black) size(medsmall)) ///
ytitle("Percent", size(medsmall)) xtitle("Year", size(medsmall)) ///
graphregion(color(white)) plotregion(color(white))

gr rename fig_diff, replace

* Cumulative
eststo clear
cap drop b u d Years Zero
gen Years = _n-1 if _n<=`hmax'
gen Zero =  0    if _n<=`hmax'
gen b=0
gen u=0
gen d=0
forv h = 0/`hmax' {
	 newey INDPRO_PC1c`h' l(0/4).dDeflatedOilPrice l(1/3).dINDPRO_PC1, lag(`h')
replace b = _b[dDeflatedOilPrice]                     if _n == `h'+1
replace u = _b[dDeflatedOilPrice] + 1.645* _se[dDeflatedOilPrice]  if _n == `h'+1
replace d = _b[dDeflatedOilPrice] - 1.645* _se[dDeflatedOilPrice]  if _n == `h'+1
eststo
}
* nois esttab , se nocons keep(dgs1)

twoway ///
(rarea u d  Years,  ///
fcolor(gs13) lcolor(gs13) lw(none) lpattern(solid)) ///
(line b Years, lcolor(blue) lpattern(solid) lwidth(thick)) ///
(line b_level Years, lcolor(red) lpattern(dash) lwidth(vthick)) ///
(line Zero Years, lcolor(black)), legend(off) ///
title("Cumulative response of" "Industrial Production to 1pp shock to Oil Prices", color(black) size(medsmall)) ///
subtitle("Levels on levels (solid blue) vs. Cumulative (dash red)", color(black) size(small)) ///
ytitle("Percent", size(medsmall)) xtitle("Year", size(medsmall)) ///
graphregion(color(white)) plotregion(color(white))

gr rename fig_cum, replace

gr combine fig_diff fig_cum, ///
graphregion(color(white)) plotregion(color(white)) ///
title("Levels and cumulated impulse responses") ///
note("Note: 90% confidence bands displayed")
*
*
*
*

*REAL INTEREST RATE

*
*
*
*
clear all
import excel "\\ptg01\RoamingProfiles\osimeono\Desktop\TSProjectData.xlsx", sheet("Data") firstrow clear

*tsset time = _n
tsset time

gen dDeflatedOilPrice = d.DeflatedOilPrice
gen dRealInterestRate = d.RealInterestRate

* Choose impulse response horizon
local hmax = 24

/* Generate LHS variables for the LPs */

* levels
forvalues h = 0/`hmax' {
	gen RealInterestRate_`h' = f`h'.RealInterestRate
}

* differences
forvalues h = 0/`hmax' {
	gen RealInterestRated`h' = f`h'.RealInterestRate - l.f`h'.RealInterestRate
}

* Cumulative
forvalues h = 0/`hmax' {
	gen RealInterestRatec`h' = f`h'.RealInterestRate - l.RealInterestRate
}

 
/* Run the LPs */
* Levels
eststo clear
cap drop b u d Years Zero
gen Years = _n-1 if _n<=`hmax'
gen Zero =  0    if _n<=`hmax'
gen b=0
gen u=0
gen d=0
forv h = 0/`hmax' {
	* levels
	 newey RealInterestRate_`h' l(0/4).DeflatedOilPrice l(1/3).RealInterestRate, lag(`h')
replace b = _b[DeflatedOilPrice]                    if _n == `h'+1
replace u = _b[DeflatedOilPrice] + 1.645* _se[DeflatedOilPrice]  if _n == `h'+1
replace d = _b[DeflatedOilPrice] - 1.645* _se[DeflatedOilPrice]  if _n == `h'+1
eststo
}
* nois esttab , se nocons keep(gs1)
gen b_level = b

* Differences
eststo clear
cap drop b u d Years Zero
gen Years = _n-1 if _n<=`hmax'
gen Zero =  0    if _n<=`hmax'
gen b=0
gen u=0
gen d=0
forv h = 0/`hmax' {
	 newey RealInterestRated`h' l(0/4).dDeflatedOilPrice l(1/3).dRealInterestRate, lag(`h')
replace b = _b[dDeflatedOilPrice]                     if _n == `h'+1
replace u = _b[dDeflatedOilPrice] + 1.645* _se[dDeflatedOilPrice]  if _n == `h'+1
replace d = _b[dDeflatedOilPrice] - 1.645* _se[dDeflatedOilPrice]  if _n == `h'+1
eststo
}
* nois esttab , se nocons keep(dgs1)

twoway ///
(rarea u d  Years,  ///
fcolor(gs13) lcolor(gs13) lw(none) lpattern(solid)) ///
(line b Years, lcolor(blue) ///
lpattern(solid) lwidth(thick)) ///
(line Zero Years, lcolor(black)), legend(off) ///
title("Impulse response of " " Real Interest Rate to 1pp shock to Oil Prices", color(black) size(medsmall)) ///
ytitle("Percent", size(medsmall)) xtitle("Year", size(medsmall)) ///
graphregion(color(white)) plotregion(color(white))

gr rename fig_diff, replace

* Cumulative
eststo clear
cap drop b u d Years Zero
gen Years = _n-1 if _n<=`hmax'
gen Zero =  0    if _n<=`hmax'
gen b=0
gen u=0
gen d=0
forv h = 0/`hmax' {
	 newey RealInterestRatec`h' l(0/4).dDeflatedOilPrice l(1/3).dRealInterestRate, lag(`h')
replace b = _b[dDeflatedOilPrice]                     if _n == `h'+1
replace u = _b[dDeflatedOilPrice] + 1.645* _se[dDeflatedOilPrice]  if _n == `h'+1
replace d = _b[dDeflatedOilPrice] - 1.645* _se[dDeflatedOilPrice]  if _n == `h'+1
eststo
}
* nois esttab , se nocons keep(dgs1)

twoway ///
(rarea u d  Years,  ///
fcolor(gs13) lcolor(gs13) lw(none) lpattern(solid)) ///
(line b Years, lcolor(blue) lpattern(solid) lwidth(thick)) ///
(line b_level Years, lcolor(red) lpattern(dash) lwidth(vthick)) ///
(line Zero Years, lcolor(black)), legend(off) ///
title("Cumulative response of" "Real Interest Rate to 1pp shock to Oil Prices", color(black) size(medsmall)) ///
subtitle("Levels on levels (solid blue) vs. Cumulative (dash red)", color(black) size(small)) ///
ytitle("Percent", size(medsmall)) xtitle("Year", size(medsmall)) ///
graphregion(color(white)) plotregion(color(white))

gr rename fig_cum, replace

gr combine fig_diff fig_cum, ///
graphregion(color(white)) plotregion(color(white)) ///
title("Levels and cumulated impulse responses") ///
note("Note: 90% confidence bands displayed")

*
*
*
*

*UNEMPLOYMENT RATE

*
*
*
*
clear all
import excel "\\ptg01\RoamingProfiles\osimeono\Desktop\TSProjectData.xlsx", sheet("Data") firstrow clear

*tsset time = _n
tsset time

gen dDeflatedOilPrice = d.DeflatedOilPrice
gen dUNRATE = d.UNRATE

* Choose impulse response horizon
local hmax = 24

/* Generate LHS variables for the LPs */

* levels
forvalues h = 0/`hmax' {
	gen UNRATE_`h' = f`h'.UNRATE
}

* differences
forvalues h = 0/`hmax' {
	gen UNRATE`h' = f`h'.UNRATE - l.f`h'.UNRATE
}

* Cumulative
forvalues h = 0/`hmax' {
	gen UNRATEc`h' = f`h'.UNRATE - l.UNRATE
}

 
/* Run the LPs */
* Levels
eststo clear
cap drop b u d Years Zero
gen Years = _n-1 if _n<=`hmax'
gen Zero =  0    if _n<=`hmax'
gen b=0
gen u=0
gen d=0
forv h = 0/`hmax' {
	* levels
	 newey UNRATE_`h' l(0/4).DeflatedOilPrice l(1/3).UNRATE, lag(`h')
replace b = _b[DeflatedOilPrice]                    if _n == `h'+1
replace u = _b[DeflatedOilPrice] + 1.645* _se[DeflatedOilPrice]  if _n == `h'+1
replace d = _b[DeflatedOilPrice] - 1.645* _se[DeflatedOilPrice]  if _n == `h'+1
eststo
}
* nois esttab , se nocons keep(gs1)
gen b_level = b

* Differences
eststo clear
cap drop b u d Years Zero
gen Years = _n-1 if _n<=`hmax'
gen Zero =  0    if _n<=`hmax'
gen b=0
gen u=0
gen d=0
forv h = 0/`hmax' {
	 newey UNRATE`h' l(0/4).dDeflatedOilPrice l(1/3).dUNRATE, lag(`h')
replace b = _b[dDeflatedOilPrice]                     if _n == `h'+1
replace u = _b[dDeflatedOilPrice] + 1.645* _se[dDeflatedOilPrice]  if _n == `h'+1
replace d = _b[dDeflatedOilPrice] - 1.645* _se[dDeflatedOilPrice]  if _n == `h'+1
eststo
}
* nois esttab , se nocons keep(dgs1)

twoway ///
(rarea u d  Years,  ///
fcolor(gs13) lcolor(gs13) lw(none) lpattern(solid)) ///
(line b Years, lcolor(blue) ///
lpattern(solid) lwidth(thick)) ///
(line Zero Years, lcolor(black)), legend(off) ///
title("Impulse response of " " Unemployment Rate to 1pp shock to Oil Prices", color(black) size(medsmall)) ///
ytitle("Percent", size(medsmall)) xtitle("Year", size(medsmall)) ///
graphregion(color(white)) plotregion(color(white))

gr rename fig_diff, replace

* Cumulative
eststo clear
cap drop b u d Years Zero
gen Years = _n-1 if _n<=`hmax'
gen Zero =  0    if _n<=`hmax'
gen b=0
gen u=0
gen d=0
forv h = 0/`hmax' {
	 newey UNRATEc`h' l(0/4).dDeflatedOilPrice l(1/3).dUNRATE, lag(`h')
replace b = _b[dDeflatedOilPrice]                     if _n == `h'+1
replace u = _b[dDeflatedOilPrice] + 1.645* _se[dDeflatedOilPrice]  if _n == `h'+1
replace d = _b[dDeflatedOilPrice] - 1.645* _se[dDeflatedOilPrice]  if _n == `h'+1
eststo
}
* nois esttab , se nocons keep(dgs1)

twoway ///
(rarea u d  Years,  ///
fcolor(gs13) lcolor(gs13) lw(none) lpattern(solid)) ///
(line b Years, lcolor(blue) lpattern(solid) lwidth(thick)) ///
(line b_level Years, lcolor(red) lpattern(dash) lwidth(vthick)) ///
(line Zero Years, lcolor(black)), legend(off) ///
title("Cumulative response of" "Unemployment Rate to 1pp shock to Oil Prices", color(black) size(medsmall)) ///
subtitle("Levels on levels (solid blue) vs. Cumulative (dash red)", color(black) size(small)) ///
ytitle("Percent", size(medsmall)) xtitle("Year", size(medsmall)) ///
graphregion(color(white)) plotregion(color(white))

gr rename fig_cum, replace

gr combine fig_diff fig_cum, ///
graphregion(color(white)) plotregion(color(white)) ///
title("Levels and cumulated impulse responses") ///
note("Note: 90% confidence bands displayed")

*
*
*
*

*INFLATION

*
*
*
*
clear all
import excel "\\ptg01\RoamingProfiles\osimeono\Desktop\TSProjectData.xlsx", sheet("Data") firstrow clear

*tsset time = _n
tsset time

gen dDeflatedOilPrice = d.DeflatedOilPrice
gen dInflation = d.Inflation

* Choose impulse response horizon
local hmax = 24

/* Generate LHS variables for the LPs */

* levels
forvalues h = 0/`hmax' {
	gen Inflation_`h' = f`h'.Inflation
}

* differences
forvalues h = 0/`hmax' {
	gen Inflation`h' = f`h'.Inflation - l.f`h'.Inflation
}

* Cumulative
forvalues h = 0/`hmax' {
	gen Inflationc`h' = f`h'.Inflation - l.Inflation
}

 
/* Run the LPs */
* Levels
eststo clear
cap drop b u d Years Zero
gen Years = _n-1 if _n<=`hmax'
gen Zero =  0    if _n<=`hmax'
gen b=0
gen u=0
gen d=0
forv h = 0/`hmax' {
	* levels
	 newey Inflation_`h' l(0/4).DeflatedOilPrice l(1/3).Inflation, lag(`h')
replace b = _b[DeflatedOilPrice]                    if _n == `h'+1
replace u = _b[DeflatedOilPrice] + 1.645* _se[DeflatedOilPrice]  if _n == `h'+1
replace d = _b[DeflatedOilPrice] - 1.645* _se[DeflatedOilPrice]  if _n == `h'+1
eststo
}
* nois esttab , se nocons keep(gs1)
gen b_level = b

* Differences
eststo clear
cap drop b u d Years Zero
gen Years = _n-1 if _n<=`hmax'
gen Zero =  0    if _n<=`hmax'
gen b=0
gen u=0
gen d=0
forv h = 0/`hmax' {
	 newey Inflation`h' l(0/4).dDeflatedOilPrice l(1/3).dInflation, lag(`h')
replace b = _b[dDeflatedOilPrice]                     if _n == `h'+1
replace u = _b[dDeflatedOilPrice] + 1.645* _se[dDeflatedOilPrice]  if _n == `h'+1
replace d = _b[dDeflatedOilPrice] - 1.645* _se[dDeflatedOilPrice]  if _n == `h'+1
eststo
}
* nois esttab , se nocons keep(dgs1)

twoway ///
(rarea u d  Years,  ///
fcolor(gs13) lcolor(gs13) lw(none) lpattern(solid)) ///
(line b Years, lcolor(blue) ///
lpattern(solid) lwidth(thick)) ///
(line Zero Years, lcolor(black)), legend(off) ///
title("Impulse response of " " Inflation to 1pp shock to Oil Prices", color(black) size(medsmall)) ///
ytitle("Percent", size(medsmall)) xtitle("Year", size(medsmall)) ///
graphregion(color(white)) plotregion(color(white))

gr rename fig_diff, replace

* Cumulative
eststo clear
cap drop b u d Years Zero
gen Years = _n-1 if _n<=`hmax'
gen Zero =  0    if _n<=`hmax'
gen b=0
gen u=0
gen d=0
forv h = 0/`hmax' {
	 newey Inflationc`h' l(0/4).dDeflatedOilPrice l(1/3).dInflation, lag(`h')
replace b = _b[dDeflatedOilPrice]                     if _n == `h'+1
replace u = _b[dDeflatedOilPrice] + 1.645* _se[dDeflatedOilPrice]  if _n == `h'+1
replace d = _b[dDeflatedOilPrice] - 1.645* _se[dDeflatedOilPrice]  if _n == `h'+1
eststo
}
* nois esttab , se nocons keep(dgs1)

twoway ///
(rarea u d  Years,  ///
fcolor(gs13) lcolor(gs13) lw(none) lpattern(solid)) ///
(line b Years, lcolor(blue) lpattern(solid) lwidth(thick)) ///
(line b_level Years, lcolor(red) lpattern(dash) lwidth(vthick)) ///
(line Zero Years, lcolor(black)), legend(off) ///
title("Cumulative response of" "Inflation to 1pp shock to Oil Prices", color(black) size(medsmall)) ///
subtitle("Levels on levels (solid blue) vs. Cumulative (dash red)", color(black) size(small)) ///
ytitle("Percent", size(medsmall)) xtitle("Year", size(medsmall)) ///
graphregion(color(white)) plotregion(color(white))

gr rename fig_cum, replace

gr combine fig_diff fig_cum, ///
graphregion(color(white)) plotregion(color(white)) ///
title("Levels and cumulated impulse responses") ///
note("Note: 90% confidence bands displayed")

*
*
*
*

*CORE INFLATION

*
*
*
*
clear all
import excel "\\ptg01\RoamingProfiles\osimeono\Desktop\TSProjectData.xlsx", sheet("Data") firstrow clear

*tsset time = _n
tsset time

gen dDeflatedOilPrice = d.DeflatedOilPrice
gen dCoreInflation = d.CoreInflation

* Choose impulse response horizon
local hmax = 24

/* Generate LHS variables for the LPs */

* levels
forvalues h = 0/`hmax' {
	gen CoreInflation_`h' = f`h'.CoreInflation
}

* differences
forvalues h = 0/`hmax' {
	gen CoreInflation`h' = f`h'.CoreInflation - l.f`h'.CoreInflation
}

* Cumulative
forvalues h = 0/`hmax' {
	gen CoreInflationc`h' = f`h'.CoreInflation - l.CoreInflation
}

 
/* Run the LPs */
* Levels
eststo clear
cap drop b u d Years Zero
gen Years = _n-1 if _n<=`hmax'
gen Zero =  0    if _n<=`hmax'
gen b=0
gen u=0
gen d=0
forv h = 0/`hmax' {
	* levels
	 newey CoreInflation_`h' l(0/4).DeflatedOilPrice l(1/3).CoreInflation, lag(`h')
replace b = _b[DeflatedOilPrice]                    if _n == `h'+1
replace u = _b[DeflatedOilPrice] + 1.645* _se[DeflatedOilPrice]  if _n == `h'+1
replace d = _b[DeflatedOilPrice] - 1.645* _se[DeflatedOilPrice]  if _n == `h'+1
eststo
}
* nois esttab , se nocons keep(gs1)
gen b_level = b

* Differences
eststo clear
cap drop b u d Years Zero
gen Years = _n-1 if _n<=`hmax'
gen Zero =  0    if _n<=`hmax'
gen b=0
gen u=0
gen d=0
forv h = 0/`hmax' {
	 newey CoreInflation`h' l(0/4).dDeflatedOilPrice l(1/3).dCoreInflation, lag(`h')
replace b = _b[dDeflatedOilPrice]                     if _n == `h'+1
replace u = _b[dDeflatedOilPrice] + 1.645* _se[dDeflatedOilPrice]  if _n == `h'+1
replace d = _b[dDeflatedOilPrice] - 1.645* _se[dDeflatedOilPrice]  if _n == `h'+1
eststo
}
* nois esttab , se nocons keep(dgs1)

twoway ///
(rarea u d  Years,  ///
fcolor(gs13) lcolor(gs13) lw(none) lpattern(solid)) ///
(line b Years, lcolor(blue) ///
lpattern(solid) lwidth(thick)) ///
(line Zero Years, lcolor(black)), legend(off) ///
title("Impulse response of " " Core Inflation to 1pp shock to Oil Prices", color(black) size(medsmall)) ///
ytitle("Percent", size(medsmall)) xtitle("Year", size(medsmall)) ///
graphregion(color(white)) plotregion(color(white))

gr rename fig_diff, replace

* Cumulative
eststo clear
cap drop b u d Years Zero
gen Years = _n-1 if _n<=`hmax'
gen Zero =  0    if _n<=`hmax'
gen b=0
gen u=0
gen d=0
forv h = 0/`hmax' {
	 newey CoreInflationc`h' l(0/4).dDeflatedOilPrice l(1/3).dCoreInflation, lag(`h')
replace b = _b[dDeflatedOilPrice]                     if _n == `h'+1
replace u = _b[dDeflatedOilPrice] + 1.645* _se[dDeflatedOilPrice]  if _n == `h'+1
replace d = _b[dDeflatedOilPrice] - 1.645* _se[dDeflatedOilPrice]  if _n == `h'+1
eststo
}
* nois esttab , se nocons keep(dgs1)

twoway ///
(rarea u d  Years,  ///
fcolor(gs13) lcolor(gs13) lw(none) lpattern(solid)) ///
(line b Years, lcolor(blue) lpattern(solid) lwidth(thick)) ///
(line b_level Years, lcolor(red) lpattern(dash) lwidth(vthick)) ///
(line Zero Years, lcolor(black)), legend(off) ///
title("Cumulative response of" "Core Inflation to 1pp shock to Oil Prices", color(black) size(medsmall)) ///
subtitle("Levels on levels (solid blue) vs. Cumulative (dash red)", color(black) size(small)) ///
ytitle("Percent", size(medsmall)) xtitle("Year", size(medsmall)) ///
graphregion(color(white)) plotregion(color(white))

gr rename fig_cum, replace

gr combine fig_diff fig_cum, ///
graphregion(color(white)) plotregion(color(white)) ///
title("Levels and cumulated impulse responses") ///
note("Note: 90% confidence bands displayed")


*
*
*
*
*
*Low and High States
*
*
*
*
*
sum DeflatedOilPrice
gen sdShock = 10.57109

gen OilShock_h = 0
replace OilShock_h = res if DeflatedOilPrice > 10.57109


/* THE END */
