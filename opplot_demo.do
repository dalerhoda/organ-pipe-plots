*! opplot_demo version 2.01 - Biostat Global Consulting - 2026-10-21
*******************************************************************************
* Change log
* 				Updated
*				version
* Date 			number 	Name			What Changed
* 2016-07-22	1.00	Dale Rhoda		Original version (date may be wrong)
* 2018-07-03	1.01	Dale Rhoda		Added plotn option (date may be wrong)
* 2020-10-29	1.02	Caitlin Clary	Vary respondents per cluster in faux
*										data; reload faux data after Demo 7;
*										demo plotting all strata; demo saving
* 										.tif; add comments throughout
* 2023-12-22	1.03	Dale Rhoda		Updated with examples of high, medium,
*                                       and low coverage categories
* 2025-06-18	1.04	MK Trimner		Added comments to the plots so user knows what options were used.
*										Added examples for each category
* 2026-10-21	2.00	Dale Rhoda		Updated for opplot 2.00: output folder
*                       & Claude        is created for you; fixed the Demo7b
*                                       savedata/use mismatch; new sections
*                                       show a report-style three-color plot,
*                                       the saved dataset and r() results,
*                                       missing outcomes, a loop over strata,
*                                       labels in another language, cluster ID
*                                       labels, many clusters, and text options
* 2026-10-21	2.01	Dale Rhoda		Fixed French typo (dans la grappe); the
*                       & Claude        syntax listing at the end now includes
*                                       BARLABSize() and NOWARNings
*******************************************************************************
*
* Program to illustrate making organ pipe plots with opplot
*
* opplot needs nothing but official Stata (version 14.1 or later).
*
* Dale Rhoda
* Dale.Rhoda@biostatglobal.com
*
********************************************************************************

clear all
set more off

* All output goes into a sub-folder of the current working directory.
* Change this line if you would like it to go somewhere else.
local demofolder "`c(pwd)'/opplot_demo_output"                // <--- Edit this line if you wish
capture mkdir "`demofolder'"
cd "`demofolder'"

* If necessary, add the folder that holds the opplot program to your adopath
* (Not necessary if you installed it from SSC or put it in a folder that is
*  already in the adopath, like c:/ado/personal or c:/ado/plus/o)

* adopath + "C:/folder/that/holds/opplot"                    // <--- Edit this line if needed

which opplot

********************************************************************************
* PART 1: The basics
********************************************************************************

* Make fake data with 2 strata with 10 clusters each with varying respondents per cluster

clear

set seed 8675309

set obs 200
gen clusterid = round(runiform(1, 20))
gen stratumid = 0
replace stratumid = 1 if clusterid > 10

* Generate an ID for clusters within strata (used when generating outcome below)
gen csindex = clusterid
replace csindex = clusterid-10 if clusterid > 10

* The yes/no outcome variable here is y.  It can take values of 0, 1, or missing(.).
* If it takes any other values, opplot will complain and stop.
* (Missing values are counted as 0 -- see Part 3 below.)
gen y = 0
replace y = 1 if runiform() > csindex/10
drop csindex

* Boost coverage in stratum 1
replace y = 1 if runiform() > .5 & stratumid == 1

* Basic demo: two plots, one for each stratum
opplot y , clustvar(clusterid) stratvar(stratumid) stratum(0) title(Stratum 0) name(Demo0a, replace) note("Basic plot using all default values for Stratum 0")
opplot y , clustvar(clusterid) stratvar(stratumid) stratum(1) title(Stratum 1) name(Demo1, replace) note("Basic plot using all default values for Stratum 1")

* Without the stratvar and stratum arguments, all strata are plotted
opplot y , clustvar(clusterid) title(All Strata) name(Demo2, replace) note("Plotted all strata") caption("Input options left out stratum and stratvar arguments", size(vsmall))

* Change bar colors (barcolor1, barcolor2)
opplot y , clustvar(clusterid) stratvar(stratumid) ///
		stratum(1) title(Stratum 1) name(Demo3, replace) ///
		barcolor1(ebblue) barcolor2(gs12) ///
		note("Changed bar colors") caption("Relevant input options: barcolor1(ebblue) barcolor2(gs12)", size(vsmall))

* Demo different bar widths if weights differ (weightvar)
* Give additional weight to cluster 11 in stratum 1
gen weight = 1
replace weight = 2 if clusterid == 11
save fauxdata, replace

opplot y , clustvar(clusterid) stratvar(stratumid) ///
		weightvar(weight) ///
		stratum(1) title(Stratum 1) name(Demo4, replace) ///
		barcolor1(ebblue) barcolor2(gs12)	///
		note("Showed different bar width for Clusterid 11 due to different weights")


* Change line colors (linecolor1, linecolor2)
opplot y , clustvar(clusterid) stratvar(stratumid) ///
		weightvar(weight) ///
		stratum(1) title(Stratum 1) name(Demo5, replace) ///
		barcolor1(ebblue) barcolor2(gs12)	///
		linecolor1(white) linecolor2(pink) ///
		note("Changed line colors") caption("Relevant input options: linecolor1(white) linecolor2(pink)", size(vsmall))


* Demo Y axis breaks (ylabel) and text options (xtitle ytitle subtitle footnote)
* Demo export to save as a PNG
opplot y , clustvar(clusterid) stratvar(stratumid) ///
		weightvar(weight) ///
		stratum(1) title(Stratum 1) name(Demo6, replace) ///
		barcolor1(lavender) barcolor2(white) ///
		ylabel(0(25)100, angle(0)) ///
		xtitle(XTitle) ytitle(YTitle) ///
		subtitle(Subtitle) footnote(Footnote) ///
		export(Stratum_1.png) ///
		note("Added footnote, y axis breaks, text options and exported to save as a PNG.") ///
		caption("Relevant input options: ylabel(0(25)100, angle(0)) xtitle(XTitle) ytitle(YTitle)" "subtitle(Subtitle) footnote(Footnote) export(Stratum_1.png)", size(vsmall))


* The exportstratumname option saves you the trouble of coming
* up with the export filename. Saves as <stratum name>.png
opplot y , clustvar(clusterid) stratvar(stratumid) ///
		stratum(0) title(Stratum 0) name(Demo0b, replace) ///
		exportstratumname ///
		note("Basic plot exported using exportstratumname option") ///
		caption("Relevant input options: exportstratumname", size(vsmall))


* The exportwidth options lets you specify that a larger file is saved
* with better resolution for some purposes
opplot y , clustvar(clusterid) stratvar(stratumid) ///
		stratum(0) title(Stratum 0) name(Demo0c, replace) ///
		export(0_higherres.png) exportwidth(3000) ///
		note("Changed exportwidth for a better resolution") ///
		caption("Relevant input options: exportwidth(3000)", size(vsmall))


* Demo saving as .tif file
opplot y , clustvar(clusterid) stratvar(stratumid) ///
           stratum(0) title(Stratum 0) name(Demo0d, replace) ///
           export(Stratum_0.tif) ///
	   	   note("Saving as .tif file") ///
		   caption("Relevant input options: export(Stratum_0.tif)", size(vsmall))


* Demo changing the aspect ratio of the figure using xsize and ysize
opplot y , clustvar(clusterid) stratvar(stratumid) ///
		stratum(0) title(Stratum 0) name(Demo7a, replace) ///
		barcolor1(dkorange) barcolor2(eggshell)	///
		xsize(20) ysize(6) export(Stratum_0_wide.png) ///
   	   note("Changed the aspect ratio of the figure using xsize and ysize") ///
	   caption("Relevant input options: xsize(20) ysize(6)", size(vsmall))


* Demo saving the accompanying dataset (savedata) and having a look at it
opplot y , clustvar(clusterid) stratvar(stratumid) ///
        stratum(0) title(Stratum 0) name(Demo7b,replace) ///
		barcolor1(dkorange) barcolor2(eggshell)	///
        xsize(20) ysize(6) savedata(Demo7b) ///
   	   note("Changed bar colors, plot size and saved accompanying dataset") ///
	   caption("Relevant input options: savedata(Demo7b) xsize(20) ysize(6)", size(vsmall))

use Demo7b, clear
describe
list, noobs abbreviate(20)
notes
* (Type -browse- to look at the dataset in the Data Editor.)

* Load faux data again
use fauxdata, clear

* Demo plotting the number of respondents (plotn)
opplot y , clustvar(clusterid) stratvar(stratumid) ///
           stratum(0) title(Stratum 0) name(Demo8, replace) ///
           plotn ///
		   note("Plotted the number of respondents (N)") ///
		 caption("Relevant input options: plotn", size(vsmall))

* Demo plotting the number of respondents using all related options
* plotn nlinecolor nlinewidth nlinepattern ytitle2 yround2
opplot y , clustvar(clusterid) stratvar(stratumid) ///
           stratum(0) title(Stratum 0) name(Demo9, replace) ///
           plotn nlinecolor(red) nlinewidth(*2) ///
           nlinepattern(dash) ytitle2(Number of Respondents (N)) ///
           yround2(2) ///
		   note("Plotted the number of respondents (N) using all related options. ") ///
		   caption("Relevant input options: plotn nlinecolor(red) nlinewidth(*2) nlinepattern(dash)" "ytitle2(Number of Respondents (N)) yround2(2)", size(vsmall))

********************************************************************************
* PART 2: Coverage categories (high, middle and low)
********************************************************************************

 * Demo adding high, medium and low coverage categories.
 * Only specify the lcthreshold. All other values will use defaults.

opplot y , clustvar(clusterid) stratvar(stratumid) ///
       stratum(1) title(Stratum 1) name(Demo10,replace) lcthreshold(50) ///
       note("Different colors for clusters with a) 100% coverage, b) >50% and < 100%, and c) <= 50%.") ///
	   caption("Relevant input options: lcthreshold(50)" "Light blue, dark blue and orange are the default colors", size(vsmall))

 * The catlegend option adds a legend that names each category and counts
 * the clusters in it

opplot y , clustvar(clusterid) stratvar(stratumid) ///
       stratum(1) title(Stratum 1) name(Demo10b,replace) lcthreshold(50) catlegend ///
	   caption("Relevant input options: lcthreshold(50) catlegend", size(vsmall))

 * Demo adding high, medium and low coverage categories.
 * Specify both the lcthreshold (slightly lower than previous run) and hcthreshold. All other values will use defaults.

opplot y , clustvar(clusterid) stratvar(stratumid) ///
        stratum(0) title(Stratum 0) name(Demo11,replace) ///
        lcthreshold(20) hcthreshold(80) ///
		note("Different colors for clusters with a) >= 80% coverage, b) >20% and < 80%, and c) <= 20%.") ///
		caption("Relevant input options: lcthreshold(20) hcthreshold(80)", size(vsmall))

 * Thresholds do not need to be whole numbers

opplot y , clustvar(clusterid) stratvar(stratumid) ///
        stratum(0) title(Stratum 0) name(Demo11b,replace) ///
        lcthreshold(33.3) hcthreshold(66.7) catlegend ///
		caption("Relevant input options: lcthreshold(33.3) hcthreshold(66.7) catlegend", size(vsmall))

 * Demo adding high, medium and low coverage categories with specified barcolor options.
 * Change both the lcthreshold and hcthreshold. Define barcolors for high, medium and low coverage categories.

opplot y , clustvar(clusterid) stratvar(stratumid) ///
        stratum(0) title(Stratum 0) name(Demo12a,replace) ///
        lcthreshold(35) hcthreshold(80) ///
        barcolorhigh1(67 162 202) barcolormid1(123 204 196) barcolorlow1(186 228 188) ///
		note("Specified colors for clusters with a) >= 80% coverage, b) >35% and < 80%, and c) <= 35%.") ///
		caption("Relevant input options: lcthreshold(35) hcthreshold(80)" "barcolorhigh1(67 162 202) barcolormid1(123 204 196) barcolorlow1(186 228 188)", size(vsmall))

* Demo the previous example but add a line at lcthreshold and hcthreshold values.

* lcthreshold only
* note this will only show if the lcthreshold is set
opplot y , clustvar(clusterid) stratvar(stratumid) ///
        stratum(0) title(Stratum 0) name(Demo12b,replace) ///
        lcthreshold(35) hcthreshold(80) ///
        barcolorhigh1(67 162 202) barcolormid1(123 204 196) barcolorlow1(186 228 188) ///
		lcline ///
		note("Different colors for clusters with a) >= 80% coverage, b) >35% and < 80%, and c) <= 35%" ) ///
		caption("Added dashed line at LCTHRESHOLD." "Relevant input options: lcthreshold(35) lcline", size(vsmall))


	* hcline only shows if hcthreshold < 100
		opplot y , clustvar(clusterid) stratvar(stratumid) ///
        stratum(0) title(Stratum 0) name(Demo12c,replace) ///
        lcthreshold(35) hcthreshold(80) ///
        barcolorhigh1(67 162 202) barcolormid1(123 204 196) barcolorlow1(186 228 188) ///
		hcline ///
		note("Different colors for clusters with a) >= 80% coverage, b) >35% and < 80%, and c) <= 35%" ) ///
		caption( "Added dashed line at HCTHRESHOLD" "Relevant input options: hcthreshold(80) hcline", size(vsmall))

		* Show both lcthreshold and hcthreshold lines
		opplot y , clustvar(clusterid) stratvar(stratumid) ///
        stratum(0) title(Stratum 0) name(Demo12d,replace) ///
        lcthreshold(35) hcthreshold(80) ///
        barcolorhigh1(67 162 202) barcolormid1(123 204 196) barcolorlow1(186 228 188) ///
		lcline hcline ///
		note("Different colors for clusters with a) >= 80% coverage, b) >35% and < 80%, and c) <= 35%" ) ///
		caption("Added dashed line at LCTHRESHOLD and HCTHRESHOLD cutoff point." "Relevant input options: lcthreshold(35) hcthreshold(80) lcline hcline", size(vsmall))

		* Demo adding footnotes with the COVG, DEFF, and ICC
		opplot y , clustvar(clusterid) stratvar(stratumid) ///
        stratum(0) title(Stratum 0) name(Demo13a,replace) ///
        footnotecovg footnotedeff footnoteicc ///
		caption("Showed footnotes with COVG, DEFF and ICC" "Relevant input options: footnotecovg footnotedeff footnoteicc", size(vsmall))

		* Demo adding regular footnote and COVG, DEFF, and ICC footnotes
		opplot y , clustvar(clusterid) stratvar(stratumid) ///
        stratum(0) title(Stratum 0) name(Demo13b,replace) ///
        footnotecovg footnotedeff footnoteicc footnote("Footnote") ///
		caption("Showed user specified Footnote and footnotes with COVG, DEFF and ICC" `"Relevant input options: footnotecovg footnotedeff footnoteicc footnote("Footnote")"', size(vsmall))



 * Demo portraying only two categories by setting lcthreshold == hcthreshold.
 * Note that in this case, any clusters exactly equal to the threshold are
 * shown in the *lower* color.

opplot y , clustvar(clusterid) stratvar(stratumid) ///
        stratum(0) title(Stratum 0) name(Demo14,replace) ///
        lcthreshold(50) hcthreshold(50) ///
		note("Showed only two categories by having LCTHRESHOLD = HCTHRESHOLD: Different colors for clusters with a) > 50% coverage and b) <= 50%.")	///
		caption("Relevant input options: lcthreshold(50) hcthreshold(50)", size(vsmall))

 * Specifying only hcthreshold (below 100) also gives two categories, but
 * here clusters exactly AT the threshold are in the *higher* category.

opplot y , clustvar(clusterid) stratvar(stratumid) ///
        stratum(0) title(Stratum 0) name(Demo14b,replace) ///
        hcthreshold(50) catlegend ///
		caption("Relevant input options: hcthreshold(50) catlegend (no lcthreshold)", size(vsmall))

********************************************************************************
* PART 3: Missing values of the outcome
********************************************************************************

* opplot counts a missing outcome as 0 (no evidence of the outcome) in both
* the bars and the coverage/DEFF/ICC footnotes.  If missing values mean
* "not part of the denominator", leave them out with an if condition.

use fauxdata, clear
replace y = . if clusterid == 3 & runiform() < .5

opplot y , clustvar(clusterid) stratvar(stratumid) stratum(0) ///
	title("Stratum 0: missing values counted as 0") name(Demo15a, replace) ///
	footnotecovg savedata(Demo15a)
di "Respondents with missing y in this plot: " r(nmissing)

* opplot displayed a warning (after the plot) because some respondents have
* a missing outcome.  If you have already looked into this, -nowarnings-
* silences it.
opplot y , clustvar(clusterid) stratvar(stratumid) stratum(0) ///
	title("Stratum 0: missing values counted as 0") name(Demo15a2, replace) ///
	footnotecovg nowarnings

opplot y if !missing(y), clustvar(clusterid) stratvar(stratumid) stratum(0) ///
	title("Stratum 0: missing values left out") name(Demo15b, replace) ///
	footnotecovg

use Demo15a, clear
list clusterid n_respondents n_outcome1 n_missing barheight, noobs

* Rows with a missing or zero weight represent no respondents and are left
* out of everything opplot summarizes.  (VCQI keeps such placeholder rows for
* sampled clusters that yielded no eligible respondents.)  Here cluster 4
* yielded nobody, and two rows in cluster 6 have a missing weight.
use fauxdata, clear
replace weight = 0 if clusterid == 4
replace y = . if clusterid == 4
bysort clusterid: replace weight = . if clusterid == 6 & _n <= 2
opplot y , clustvar(clusterid) stratvar(stratumid) stratum(0) weightvar(weight) ///
	title("Stratum 0: cluster 4 had no eligible respondents") name(Demo15c, replace) ///
	footnotecovg
di "Clusters plotted: " r(nclusters) "   respondents plotted: " r(N)

********************************************************************************
* PART 4: A report-style plot and its cluster-level dataset
*
* Post-campaign coverage survey reports often show one national organ pipe
* plot in which clusters where every child was vaccinated are light blue,
* clusters with more than 50% but less than 100% are dark blue and clusters
* with 50% or fewer are orange; a gold line shows the number of children per
* cluster; and the footnote lists the estimated coverage, design effect and
* intracluster correlation coefficient.  An annex then studies the clusters
* in each category.
********************************************************************************

clear
set seed 20261021
set obs 130
gen clusterid = 1000 + _n
gen region = 1 + mod(_n, 4)
label define region 1 "North" 2 "East" 3 "South" 4 "West"
label values region region
gen urban = runiform() < .3
gen double cluster_cov = rbeta(3, .7)
gen nkids = 4 + floor(12*runiform())
gen double psweight = 200 + 400*runiform()
expand nkids
bysort clusterid: gen child = _n
gen got_campaign_dose = runiform() < cluster_cov
gen heard_of_campaign = runiform() < (.4 + .5*cluster_cov)
label variable got_campaign_dose "Child received the campaign dose"
label variable heard_of_campaign "Caregiver heard of the campaign beforehand"
drop cluster_cov nkids
save campaign_survey, replace

opplot got_campaign_dose, clustvar(clusterid) weightvar(psweight) ///
	lcthreshold(50) plotn nlinecolor(gold) ///
	footnotecovg footnotedeff footnoteicc catlegend ///
	title("Campaign coverage, by cluster") ///
	savedata(campaign_opplot) export(campaign_opplot.png) ///
	name(Demo16, replace)

* opplot leaves results behind in r()
return list

* The saved dataset has one row per bar, in plot order, with the coverage
* category of each cluster
use campaign_opplot, clear
tab category
list clusterid barheight n_respondents n_outcome1 if category == 3, noobs

* Cross-tabulate a survey question by cluster coverage category
use campaign_survey, clear
merge m:1 clusterid using campaign_opplot, keepusing(category barheight) nogen
tab category heard_of_campaign, row

********************************************************************************
* PART 5: One plot per stratum, as VCQI does
********************************************************************************

use campaign_survey, clear
levelsof region, local(rlist)
foreach r of local rlist {
	local rname : label region `r'
	opplot got_campaign_dose, clustvar(clusterid) weightvar(psweight) ///
		stratvar(region) stratum(`r') stratumname(`rname') ///
		lcthreshold(50) plotn nlinecolor(gold) footnotecovg ///
		title("`r' - `rname'") name(Demo17_`r', replace) ///
		export(campaign_region_`r'.png) savedata(campaign_region_`r')
	di as text "`rname': coverage = " %4.1f r(covg) "%; " r(n_low) " of " r(nclusters) " clusters at or below 50%"
}

********************************************************************************
* PART 6: Labels in another language
*
* The axis titles and footnote labels come from global macros that VCQI sets
* in the user's chosen language.  You can set them yourself.
********************************************************************************

global OS_316 Pourcentage du cluster
global OS_317 Nombre d'enfants dans la grappe
global OS_327 Couverture estimée
global OS_498 Effet de conception
global OS_493 coefficient de corrélation intracluster

opplot got_campaign_dose, clustvar(clusterid) weightvar(psweight) ///
	lcthreshold(50) plotn nlinecolor(gold) ///
	footnotecovg footnotedeff footnoteicc ///
	name(Demo18, replace)

macro drop OS_316 OS_317 OS_327 OS_498 OS_493

********************************************************************************
* PART 7: Labels under the bars, many clusters, and text options
********************************************************************************

* Label each bar with its cluster ID; equal widths make the labels tidy
use fauxdata, clear
opplot y , clustvar(clusterid) stratvar(stratumid) stratum(1) ///
	equalwidth barlabels xtitle("Cluster ID") ///
	title(Stratum 1) name(Demo19, replace) ///
	caption("Relevant input options: equalwidth barlabels xtitle(Cluster ID)", size(vsmall))

* With hundreds of clusters thin outlines would overwhelm the colors, so
* opplot leaves them out automatically above 150 clusters;
* barlinewidth(*.1) puts them back (and barlinewidth(none) removes them
* from a smaller plot)
clear
set seed 600
set obs 600
gen clusterid = _n
gen double cluster_cov = rbeta(4, .6)
expand 15
gen y = runiform() < cluster_cov
opplot y, clustvar(clusterid) lcthreshold(75) plotn nlinecolor(gold) ///
	title("600 clusters, default (no outlines)") name(Demo20a, replace)
opplot y, clustvar(clusterid) lcthreshold(75) plotn nlinecolor(gold) ///
	barlinewidth(*.1) title("600 clusters, barlinewidth(*.1)") name(Demo20b, replace)

* Titles and notes may contain commas, several lines and text options
use fauxdata, clear
opplot y , clustvar(clusterid) stratvar(stratumid) stratum(0) ///
	title("Stratum 0, North and East", size(medium)) ///
	note("First line of a note" "Second line, with a comma", size(small)) ///
	footnotecovg name(Demo21, replace)

* Any other twoway option can be passed with twoway(); it takes precedence
* over opplot's own settings
opplot y if clusterid != 5, clustvar(clusterid) stratvar(stratumid) stratum(0) ///
	title(Stratum 0 without cluster 5) twoway(graphregion(color(gs15)) plotregion(margin(zero))) ///
	note("Using the twoway() option to pass graphregion and plotregion options", size(small)) ///
	saving(Demo22, replace) name(Demo22, replace)


* Here is the 'syntax' statement from opplot.  We have demoed the useful
* features in this program.  See -help opplot- for details.

/*
	syntax varlist(max=1 numeric) [if] [in], CLUSTVAR(varname) ///
		[STRATVAR(varname) STRATUM(string) WEIGHTvar(varname) ///
		TITLE(string asis) SUBtitle(string asis) FOOTnote(string asis) ///
		NOTE(string asis) CAPTION(string asis) ///
		BARCOLOR1(string) LINECOLOR1(string) ///
		BARCOLOR2(string) LINECOLOR2(string) EQUALWIDTH ///
		XTITLE(string asis) YTITLE(string asis) XLABEL(string asis) YLABEL(string asis) ///
		EXPORTSTRAtumname EXPORT(string) EXPORTWidth(integer 2000) ///
		SAVING(string asis) NAME(string) SAVEDATA(string asis) ///
		XSIZE(real -9) YSIZE(real -9) TWOWAY(string asis) PLOTN ///
		NLINEColor(string asis) NLINEWidth(string) NLINEPattern(string) ///
		YTITLE2(string asis) YROUND2(integer 5) ///
		LCTHRESHold(real -999) LCLINE  ///
		BARCOLORHIGH1(string) BARCOLORMID1(string) BARCOLORLOW1(string) ///
		BARCOLORHIGH2(string) BARCOLORMID2(string) BARCOLORLOW2(string) ///
		LINECOLORHIGH1(string) LINECOLORMID1(string) LINECOLORLOW1(string) ///
		LINECOLORHIGH2(string) LINECOLORMID2(string) LINECOLORLOW2(string)  ///
		FOOTNOTECOVG FOOTNOTEDEFF FOOTNOTEICC STRATUMNAME(string) ///
		HIGH(real -999) HCLINE HCTHRESHOLD(real -999) ///
		CATLEGEND BARLABELS BARLABSize(string) BARLINEWidth(string) NOWARNings ]
*/

* Questions ???
* Email: Dale.Rhoda@biostatglobal.com
