*! opplot version 2.01 - Biostat Global Consulting - 2026-10-21
*******************************************************************************
* Change log
* 				Updated
*				version
* Date 			number 	Name			What Changed
*-------------------------------------------------------------------------------
* 2015-12-21	1.01	MK Trimner		Added Starting comment and VCP globals
*
*										Put error to the vcqi_log as well as screen
*
* 2016-02-24	1.02	Dale Rhoda		Only set VCP and call vcqi_log_comment
*          								if VCQI is running; allows the possibility
*										to call the program from outside VCQI
*
* 2016-03-12	1.03	Dale Rhoda		Added option to save the plotting dataset
*
* 2016-07-04	1.04	Dale Rhoda		I'm seeing ties in coverage across
*										many strata (often at 100%) and so
* 										added a condition that sorts the plots
*										in descending order of coverage, with
*										ties broken by descending order of
*										weight, and ascending order of
*										cluster ID (clustvar)
*
* 2016-09-10	1.05	Dale Rhoda		Improve option to save plotting dataset
*
* 2017-08-26	1.06	Mary Prier		Added version 14.1 line
*
* 2017-12-11 	1.07	Dale Rhoda		Added passthru twoway option
*
* 2017-12-20	1.08	Dale Rhoda		Cleaned up how the pass_thru local works
*
* 2018-06-22	1.09	Dale Rhoda		Added the equalwidth option
*                                       (which will over-ride the weightvar
*                                       option, if necessary, to yield bars
*                                       of equal width)
*
* 2018-08-14	1.10	Mary Prier		Added line of code that strips out
*                      					double quotes of savedata option,
*										if user supplied filename in double quotes
*
* 2019-01-22	1.11	Dale Rhoda		Added options to add a line indicating
*      									the number of respondents per cluster.
*										(PLOTN NLINEColor NLINEWIdth NLINEPattern
*										 YTITLE2 and YROUND2)
*
* 2019-06-05	1.12	Dale Rhoda		When bars are tied on other quantities,
*										sort in descending order of
*										n_respondents
*
* 2019-12-12	1.13	Dale Rhoda		Cleaned up how the name() option is
*										processed
*
*										Allow the user to specify ytitle(none)
* 										to turn off the ytitle altogether
*										(which shifts the plot slightly
*										 leftward)
*
* 2020-06-01	1.14	Dale Rhoda		Implement `if' and `in'
*
* 2023-07-28	1.15	MK Trimner		Added globals with Output Strings for
*                                       multi-lingual purposes
* 2023-11-03	1.16	MK Trimner		Updated barheight to be a double variable
*										Added options for bar colors for Opplots
*										Added notes with Covg, CI, DEFF, ICC,
*                                       StratumID , Nam and CI type information
*                                       to opplot dataset
*										Added STRATUMNAME as an option for notes
*										Added HIGH value for the cutoff for the
*                                       high end of the bars. This defaults to 100
* 2023-12-22	1.17	Dale Rhoda		Suppress horizontal line at y=lcthreshold
* 2024-03-20	1.18	MK Trimner		Added multi lingual globals for covg,
*                                       icc and deff footnotes
* 2024-04-30	1.19	Dale Rhoda		Changed from proper to ustrtitle
* 2024-06-11	1.20	Dale Rhoda		Establish four OS labels if not running VCQI
* 2024-08-14	1.21	Dale Rhoda		Use double precision for variables that describe
*                                       bar height and width
* 2024-08-16	1.22	Dale Rhoda		Round barheight to a thousandth of a
*                                       percent to avoid problems with
*                                       comparison of a double precision var
*                                       with a (not double) local macro
* 2025-03-05 	1.23	Dale Rhoda		Convert some global macros to locals
*                                       for the sake of tidiness.  And clean
*                                       out all globals that this program
*                                       temporarily sets.  And fix a typographical
*                                       error related to the svyset logic.
* 2025-05-29	1.24	MK Trimner		Added caption option
*										Put all 3 footnotes on a single line and changed the size to mirror that of the caption : size(vsmall)
* 2025-06-18	1.25	MK Trimner		Added option for user to request a line to show HCTHRESHOLD (HCLINE) and LCTHRESHold (LCLINE) lines
*										The HCLINE will only show if HIGH is < 100
*										Changed HIGH to HCTHRESHOLD
*										Added backwards compatibility for HIGH vs HCTHRESHOLD
*										Changed program so that it will create the different bars if lcthreshold is not provided but high is < 100
*										Footnote was only showing if note was not specified. Changed to be able to add both footnote and note
* 2025-08-13	1.26	MK Trimner		Added $VCQI_DEFF_TRUNCATE to svypd command so the CI's align with COVG output
* 2026-10-21	2.00	Dale Rhoda		Version 2.0 (drafted with Claude).  Main changes:
*                       & Claude        - Truly standalone: no longer calls svypd or
*                                         calcicc.  Coverage and DEFF come from
*                                         svy: mean (DEFF uses the
*                                         same formula as svypd and still honors
*                                         $VCQI_DEFF_TRUNCATE); the ICC comes from
*                                         an internal helper (opplot_icc) that uses
*                                         the same ANOVA formula as calcicc, so it
*                                         can be negative.
*                                       - Missing outcome values are explicitly
*                                         treated as 0 via a temporary 0/1 copy of
*                                         the outcome, for bars AND footnotes.
*                                       - title(), subtitle(), caption(), xlabel()
*                                         and ylabel() are passed through as typed;
*                                         note(), footnote(), xtitle(), ytitle()
*                                         and ytitle2() accept quoted text with
*                                         commas, several lines and suboptions,
*                                         and still take unquoted text literally;
*                                         xlabel() is now honored.
*                                       - Thresholds may be non-integers; hcthreshold()
*                                         alone gives two categories (no hidden
*                                         0% "low" category); lcthreshold() must
*                                         not exceed hcthreshold().
*                                       - Fixed default linecolor1 (barcolor1*1.5);
*                                         colors are always quoted (RGB works in
*                                         every option); removed the color checker
*                                         that rejected valid colors.
*                                       - Fixed equalwidth (cluster IDs repeated
*                                         across strata; weights no longer altered
*                                         for the footnote statistics).
*                                       - if and in now work together.
*                                       - Clear error messages that stop the program
*                                         (non 0/1 outcome, stratum not found,
*                                         stratvar without stratum, bad thresholds,
*                                         negative weights, savedata failures).
*                                       - Globals that opplot sets are always cleaned
*                                         up; no scalars are left behind.
*                                       - Default OS_ strings match VCQI's English
*                                         strings (OS_317 added); the ICC label is
*                                         no longer title-cased (only its first
*                                         letter is capitalized).
*                                       - New options: CATLEGEND, BARLABELS,
*                                         BARLINEWidth().
*                                       - Rows with a missing or zero weight are
*                                         excluded from everything (they represent
*                                         no respondents).
*                                       - No confidence interval is reported in any
*                                         form (plot, dataset notes or r()).
*                                       - Bar outlines are omitted automatically
*                                         when there are more than 150 clusters
*                                         (barlinewidth() overrides).
*                                       - Warns (screen, and VCQI log if running)
*                                         when respondents with a positive weight
*                                         have a missing outcome; new option
*                                         NOWARNings suppresses the warning.
*                                       - savedata adds category, n_outcome1,
*                                         n_missing, sum_weights, lcthreshold and
*                                         hcthreshold; opplot is now r-class.
* 2026-10-21	2.01	Dale Rhoda		New option BARLABSize() sets the size of the
*                       & Claude          cluster ID labels drawn by BARLABELS
*                                         (default vsmall); it implies BARLABELS.
*                                       - When xlabel() is given with barlabels or
*                                         barlabsize(), opplot now displays a note
*                                         that xlabel() takes precedence.
*******************************************************************************

capture program drop opplot
program define opplot, rclass
	version 14.1

	* Note: opplot.ado is distributed as part of the World Health Organization's
	* Vaccination Coverage Quality Indicators (VCQI) suite of Stata programs.
	* When opplot is called from within VCQI, it interacts with a VCQI log.
	* When opplot is not called from VCQI, it ignores the few lines of
	* VCQI-related code.  The program knows if it is being called from VCQI
	* because of the value of the global macro: VCQI_LOGOPEN.
	*
	* Since version 2.00 opplot does not depend on any other VCQI program.

	if "$VCQI_LOGOPEN" == "1" {
		local oldvcp $VCP
		global VCP opplot
		vcqi_log_comment $VCP 5 Flow "Starting"
	}

	* Establish English output strings (OS) if they are not already defined
	* (VCQI defines them in the user's chosen language).  These match the
	* English strings in VCQI's multi-lingual phrase list.
	local global_cleanup_list
	if `"$OS_316"' == "" {
		global OS_316 Percent of Cluster
		local global_cleanup_list `global_cleanup_list' OS_316
	}
	if `"$OS_317"' == "" {
		global OS_317 Number of Respondents
		local global_cleanup_list `global_cleanup_list' OS_317
	}
	if `"$OS_327"' == "" {
		global OS_327 Estimated Coverage
		local global_cleanup_list `global_cleanup_list' OS_327
	}
	if `"$OS_493"' == "" {
		global OS_493 Intracluster correlation coefficient
		local global_cleanup_list `global_cleanup_list' OS_493
	}
	if `"$OS_498"' == "" {
		global OS_498 Design effect
		local global_cleanup_list `global_cleanup_list' OS_498
	}

	* Do the work in a sub-program so that globals are cleaned up and the
	* VCP is restored even if the work stops with an error
	local opplot_nowarn
	capture noisily opplot_engine `0'
	local rc = _rc
	if `rc' == 0 {
		local w_nmiss = r(nmissing)
		local w_N     = r(N)
		local w_yvar  `r(yvar)'
		return add
	}

	* Unless the user specified nowarnings, warn when respondents with a
	* positive weight have a missing outcome (opplot counts them as 0).
	* Inside VCQI the warning also goes to the VCQI log and names the
	* calling program and the full opplot command.  VCQI log entries may
	* hold at most 2045 characters (vcqi_log_comment stops VCQI if an
	* entry is longer), so if the full command would not fit, only the
	* calling program is named.
	if `rc' == 0 & "`opplot_nowarn'" == "" {
		if `w_nmiss' > 0 & !missing(`w_nmiss') {
			local wmsg opplot warning: `w_nmiss' out of `w_N' respondents with a positive weight have a missing value of `w_yvar' (counted as 0)
			if "$VCQI_LOGOPEN" == "1" {
				* (macval() keeps dollar signs or macro quotes in the command from being expanded again)
				local wcall = strtrim(`"`macval(0)'"')
				local wfull `"`wmsg'; inside VCQI, opplot.ado was called from `oldvcp' with this syntax: opplot `macval(wcall)'"'
				* vcqi_log_comment expands macros in its text once more, so dollar
				* signs and left macro quotes are escaped with a backslash for the
				* log entry; the length test uses the escaped text, to be safe
				local wlog = subinstr(`"`macval(wfull)'"', "$", "\\$", .)
				local wlog = subinstr(`"`macval(wlog)'"', char(96), "\" + char(96), .)
				if strlen(`"`macval(wlog)'"') > 2045 {
					local wfull `"`wmsg'; inside VCQI, opplot.ado was called from `oldvcp'."'
					local wlog `"`macval(wfull)'"'
				}
				noi di as text `"`macval(wfull)'"'
				vcqi_log_comment $VCP 2 Warning `"`macval(wlog)'"'
			}
			else noi di as text `"`wmsg'."'
		}
	}

	* Clean out any global macros that were newly populated by this program
	foreach m of local global_cleanup_list {
		global `m'
	}

	if "$VCQI_LOGOPEN" == "1" {
		if `rc' == 0 vcqi_log_comment $VCP 5 Flow "Exiting"
		global VCP `oldvcp'
	}

	if `rc' != 0 exit `rc'
end

********************************************************************************
********************************************************************************

capture program drop opplot_engine
program define opplot_engine, rclass
	version 14.1

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

	* tell the calling program (opplot) whether to skip the missing-outcome warning
	c_local opplot_nowarn `nowarnings'

	local yvar `varlist'

	* Mark the observations selected by if and in (applied together)
	* (novarlist because missing values of the outcome are allowed)
	marksample touse, novarlist

	*---------------------------------------------------------------------------
	* Check the threshold options before doing any work
	*---------------------------------------------------------------------------

	* high() is the original name of hcthreshold(); keep it for backwards compatibility
	if `high' != -999 & `hcthreshold' == -999 local hcthreshold `high'
	if `high' != -999 & `hcthreshold' != `high' {
		di as text "opplot note: high() is the older name for hcthreshold(); using hcthreshold(`hcthreshold')."
	}
	if `hcthreshold' == -999 local hcthreshold 100
	local lcgiven = (`lcthreshold' != -999)

	if `hcthreshold' <= 0 | `hcthreshold' > 100 {
		opplot_error 198 "opplot error: hcthreshold() must be greater than 0 and no more than 100; you specified `hcthreshold'."
	}
	if `lcgiven' {
		if `lcthreshold' < 0 | `lcthreshold' >= 100 {
			opplot_error 198 "opplot error: lcthreshold() must be at least 0 and less than 100; you specified `lcthreshold'."
		}
		if `lcthreshold' > `hcthreshold' {
			opplot_error 198 "opplot error: lcthreshold(`lcthreshold') must not be larger than hcthreshold(`hcthreshold')."
		}
	}
	else local lcthreshold

	* Three color categories are used if the user specifies a low coverage
	* threshold or a high coverage threshold below 100
	local threecolor = `lcgiven' | (`hcthreshold' < 100)

	* barlabsize() implies barlabels; xlabel() takes precedence over both
	if `"`xlabel'"' != "" & `"`barlabsize'"' != "" {
		noi di as text "opplot note: xlabel() takes precedence over barlabsize()."
	}
	else if `"`xlabel'"' != "" & "`barlabels'" != "" {
		noi di as text "opplot note: xlabel() takes precedence over barlabels."
	}
	if `"`barlabsize'"' != "" local barlabels barlabels

	* savedata keeps the cluster variable under its own name, so it may not
	* share a name with one of the saved variables
	if `"`savedata'"' != "" {
		local reserved yvar stratvar stratum cluster n_respondents barorder barwidth ///
			cumulative_barwidth barheight n_outcome1 n_missing sum_weights ///
			category lcthreshold hcthreshold
		if `: list clustvar in reserved' {
			opplot_error 198 "opplot error: savedata cannot be used when the cluster variable is named `clustvar'; please rename it."
		}
	}

	if "`stratvar'" != "" & `"`stratum'"' == "" {
		opplot_error 198 "opplot error: when you specify stratvar(`stratvar') you must also specify which stratum to plot with the stratum() option."
	}

	quietly {

		preserve

		keep if `touse'

		* Clusters with a missing ID cannot be drawn
		count if missing(`clustvar')
		if r(N) > 0 {
			if "$VCQI_LOGOPEN" != "1" noi di as text "opplot note: `r(N)' observation(s) with missing `clustvar' were excluded."
			drop if missing(`clustvar')
		}

		*-----------------------------------------------------------------------
		* Keep only observations in the stratum of interest
		*-----------------------------------------------------------------------

		* if the user doesn't specify a stratum, the whole dataset is one stratum
		if "`stratvar'" == "" {
			local stratum 1
		}
		else {
			capture confirm string variable `stratvar'
			if _rc == 0 keep if `stratvar' == `"`stratum'"'
			else {
				local sv = real(`"`stratum'"')
				if missing(`sv') {
					opplot_error 198 "opplot error: stratvar(`stratvar') is numeric, so stratum() must be a number; you specified stratum(`stratum')."
				}
				local svtype : type `stratvar'
				if "`svtype'" == "float" keep if `stratvar' == float(`sv')
				else                     keep if `stratvar' == `sv'
			}
		}

		if _N == 0 {
			if "`stratvar'" != "" opplot_error 2000 "opplot error: no observations have `stratvar' == `stratum' (after applying any if/in conditions)."
			else                  opplot_error 2000 "opplot error: no observations to plot (after applying any if/in conditions)."
		}

		*-----------------------------------------------------------------------
		* Survey weights
		*-----------------------------------------------------------------------

		* if the user doesn't specify a weight variable, generate one
		if "`weightvar'" == "" {
			tempvar weightvariable
			gen byte `weightvariable' = 1
			local weightvar `weightvariable'
		}
		else {
			count if `weightvar' < 0 & !missing(`weightvar')
			if r(N) > 0 opplot_error 402 "opplot error: `weightvar' has `r(N)' negative value(s)."
		}

		* Rows with a missing or zero weight represent no respondents (in
		* VCQI they are typically placeholders for sampled clusters that
		* yielded no eligible respondents), so they are left out of
		* everything that opplot shows: bar widths and heights, the number
		* of respondents, the categories, the coverage and the ICC.
		* (Clusters with only such rows therefore do not appear as bars.)
		* Zero-weight rows do stay in the survey design while the DEFF is
		* estimated, as VCQI's svypd does, so that their clusters count.
		tempvar positive
		gen byte `positive' = `weightvar' > 0 & !missing(`weightvar')
		count if !`positive'
		local n_notrep = r(N)
		count if `positive'
		if r(N) == 0 opplot_error 2000 "opplot error: no observations with a positive `weightvar'."

		*-----------------------------------------------------------------------
		* The outcome: 0, 1 or missing; missing is treated as 0
		*-----------------------------------------------------------------------

		* if y contains anything but 0 or 1 or missing then fail
		capture assert inlist(`yvar',0,1) | missing(`yvar') if `positive'
		if _rc != 0 {
			if "`stratvar'" != "" local where " when `stratvar' == `stratum'"
			opplot_error 450 "opplot error: `yvar' should only have values of 0 or 1 or missing`where'."
		}

		* Work with a temporary 0/1 copy of the outcome in which missing
		* values (among respondents with a positive weight) are counted as 0
		* (no evidence of the outcome).  This copy is used for the bars AND
		* for the coverage, DEFF and ICC footnotes, so they always agree.
		tempvar y01
		gen byte `y01' = (`yvar' == 1)
		count if missing(`yvar') & `positive'
		local nmissing_total = r(N)

		*-----------------------------------------------------------------------
		* Stratum-level statistics: coverage and DEFF
		* (opplot does not report confidence intervals)
		*-----------------------------------------------------------------------

		* Sort by cluster (stable) so that cluster sums are always accumulated
		* in the same order (svy may still vary in the 16th digit)
		sort `clustvar', stable

		* Build the svyset command from the options, unless the data are
		* already svyset (e.g., by VCQI), in which case use that design
		quietly svyset
		if "`r(settings)'" == "" | "`r(settings)'" == ", clear" {
			svyset `clustvar' [pweight=`weightvar'], singleunit(scaled)
		}
		else if "$VCQI_LOGOPEN" != "1" {
			noi di as text "opplot note: the data are already svyset; the coverage and DEFF use that design (`r(settings)')."
		}

		tempname p se deff icc n
		scalar `p' = .
		scalar `se' = .
		scalar `deff' = .
		capture svy, subpop(`positive'): mean `y01'
		if _rc == 0 {
			scalar `p'  = _b[`y01']
			scalar `se' = _se[`y01']
			if missing(`se') | `se' < 1E-16 scalar `se' = 0

			* DEFF: same formula as VCQI's svypd/svyp_ci_calc
			*       DEFF = (N - 1) / Neff,  Neff = p(1-p)/se^2
			* and DEFF = 1 if p is 0 or 1 or the standard error is 0
			if `p' < 0.00000005 | `p' >= 0.99999995 | `se' < 0.00000005 {
				scalar `deff' = 1
			}
			else scalar `deff' = (e(N_sub) - 1) / (`p'*(1-`p') / `se'^2)
			if `"$VCQI_DEFF_TRUNCATE"' != "" & `deff' < 1 scalar `deff' = 1
		}
		else {
			noi di as text "opplot note: svy: mean could not estimate coverage for this stratum; footnote values will be missing."
		}

		* From here on, only rows that represent respondents
		if `n_notrep' > 0 {
			if "$VCQI_LOGOPEN" != "1" noi di as text "opplot note: `n_notrep' observation(s) with a missing or zero weight (`weightvar') are not represented in the plot."
			drop if !`positive'
		}
		scalar `n' = _N

		*-----------------------------------------------------------------------
		* Cluster-level quantities
		*-----------------------------------------------------------------------

		tempvar n_respondents wclust yweight wsum1 barheight barwidth n_yes n_miss ismiss

		* keep track of the number of respondents per cluster
		bysort `clustvar': gen long `n_respondents' = _N

		* calculate sum of survey weights in each cluster
		by `clustvar': egen double `wclust' = total(`weightvar')

		* calculate sum of survey weights for respondents with outcome = 1
		gen double `yweight' = `y01' * `weightvar'
		by `clustvar': egen double `wsum1' = total(`yweight')

		* counts for the saved dataset
		by `clustvar': egen long `n_yes'  = total(`y01')
		gen byte `ismiss' = missing(`yvar')
		by `clustvar': egen long `n_miss' = total(`ismiss')

		* the height of each bar is the weighted proportion of respondents
		* with outcome = 1
		gen double `barheight' = round(100*`wsum1'/`wclust', 0.001) // round to thousandth of a percent to avoid double comparison problems later
		format %3.1f `barheight'

		* the width of each bar is the proportion of the stratum weight in
		* the cluster -- or 100/(number of clusters) if equalwidth is specified
		tempvar tag
		egen byte `tag' = tag(`clustvar')
		count if `tag'
		local nclusters = r(N)
		if "`equalwidth'" != "" {
			gen double `barwidth' = 100 / `nclusters'
		}
		else {
			sum `weightvar', meanonly
			gen double `barwidth' = 100 * `wclust' / r(sum)
		}

		* ICC (unweighted, among the respondents represented in the plot)
		opplot_icc `y01' `clustvar'
		scalar `icc' = r(icc)

		local covg : di %-9.1f 100*`p'
		local deffs : di %-9.1f `deff'
		local iccs : di %-9.4f `icc'
		foreach s in covg deffs iccs {
			local `s' = strtrim("``s''")
		}

		* Add notes with the coverage information to the (saved) dataset
		note: Estimated Coverage = `covg'%
		note: DEFF = `deffs'
		note: ICC = `iccs'
		note: StratumID = `stratum'
		if "`stratumname'" == "" & "$VCQI_LOGOPEN" == "1" {
			capture confirm var level3name
			if _rc  == 0 local stratumname = level3name[1]
		}
		if "`stratumname'" != "" note: StratumName = `stratumname'
		note: Missing values of `yvar' are counted as 0 (`nmissing_total' respondent(s) in this plot).
		if `n_notrep' > 0 note: `n_notrep' row(s) with a missing or zero weight are not represented in this plot.

		*-----------------------------------------------------------------------
		* One row per bar
		*-----------------------------------------------------------------------

		* keep only one observation per cluster
		bysort `clustvar': keep if _n == 1

		* sort the bars, left-to-right, in descending order of height and width
		* (and if there are ties...then sort the ties by descending n_respondents
		*  and ascending clusterID)
		gsort -`barheight' -`n_respondents' -`barwidth' `clustvar'

		* coverage category of each bar (1=high, 2=mid, 3=low); the low
		* category takes precedence when lcthreshold == hcthreshold
		tempvar category
		gen byte `category' = .
		if `threecolor' {
			replace `category' = 2
			replace `category' = 1 if `barheight' >= `hcthreshold' - 1E-7
			if `lcgiven' replace `category' = 3 if `barheight' <= `lcthreshold' + 1E-7
			count if `category' == 1
			local n_high = r(N)
			count if `category' == 2
			local n_mid = r(N)
			count if `category' == 3
			local n_low = r(N)
		}

		* the background bars always have a height of 100%
		tempvar bartop cumulative_barwidth xleft
		gen double `bartop' = 100

		* Stata's facility for barcharts with varying widths requires a
		* variable that codes the cumulative barwidth
		gen double `cumulative_barwidth' = sum(`barwidth')

		* add an extra row onto the dataset and shift the cumulative width
		* down by one observation to make the x values work out correctly
		* (bar i spans from xleft[i] to xleft[i+1])
		set obs `=_N+1'
		gen double `xleft' = `cumulative_barwidth'[_n-1]
		replace `xleft' = 0 in 1

		*-----------------------------------------------------------------------
		* Graph options
		*-----------------------------------------------------------------------

		* establish default values if the user doesn't specify them
		if `"`ylabel'"' == "" local ylabel 0(50)100, angle(h) nogrid

		local ytitle_check = ustrlower(strtrim(subinstr(`"`ytitle'"', `"""', "", .)))
		if `"`ytitle'"' == "" local ytitle `""${OS_316}""'   // Percent of Cluster
		if "`ytitle_check'" == "none" local ytitle

		if "`barcolor1'"  == "" local barcolor1 pink
		if "`linecolor1'" == "" local linecolor1 `barcolor1'*1.5
		if "`barcolor2'"  == "" local barcolor2 white
		if "`linecolor2'" == "" local linecolor2 black*0.5

		if "`barcolorhigh1'"  == "" local barcolorhigh1 103 169 207  // light blue
		if "`linecolorhigh1'" == "" local linecolorhigh1 gs15
		if "`barcolorhigh2'"  == "" local barcolorhigh2 gs15
		if "`linecolorhigh2'" == "" local linecolorhigh2 black*0.5

		if "`barcolormid1'"  == "" local barcolormid1 0 0 128         // dark blue (navy)
		if "`linecolormid1'" == "" local linecolormid1 gs15
		if "`barcolormid2'"  == "" local barcolormid2 gs15
		if "`linecolormid2'" == "" local linecolormid2 black*0.5

		if "`barcolorlow1'"  == "" local barcolorlow1 255 91 0        // orange
		if "`linecolorlow1'" == "" local linecolorlow1 gs15
		if "`barcolorlow2'"  == "" local barcolorlow2 gs15
		if "`linecolorlow2'" == "" local linecolorlow2 black*0.5

		* Bar outlines: thin by default, but none at all for more than 150
		* clusters, where outlines would wash out the fill colors
		if "`barlinewidth'" == "" {
			if `nclusters' > 150 local barlinewidth none
			else                 local barlinewidth *.1
		}

		if "`exportstratumname'" != "" {
			if "`export'" == "" local export `stratum'.png
			else noi di as text "opplot note: export() takes precedence over exportstratumname."
		}
		if `"`name'"' != "" {
			local stripname `name'
			local stripname = subinstr("`stripname'", ", replace", "", .)
			local stripname = subinstr("`stripname'", ",replace" , "", .)
			local stripname = substr("`stripname'",1,min(32,length("`stripname'")))
			local namestring name(`stripname' , replace)
		}
		if `"`saving'"' != "" local savingstring saving(`saving')
		if `xsize'  != -9 local xsizestring xsize(`xsize')
		if `ysize'  != -9 local ysizestring ysize(`ysize')

		*-----------------------------------------------------------------------
		* Footnotes
		*-----------------------------------------------------------------------

		// BUILD THE FOOTNOTES based on user specified input
		// Estimated Coverage = XXX.X%; Design Effect = XX.X;
		// Intracluster Correlation Coefficient = X.XXXX
		local icclabel `"${OS_493}"'
		local icclabel = ustrupper(usubstr(`"`icclabel'"',1,1)) + usubstr(`"`icclabel'"',2,.)
		local opplot_footnote
		if "`footnotecovg'" != "" local opplot_footnote `"`opplot_footnote'; ${OS_327} = `covg'%"'  // Estimated Coverage
		if "`footnotedeff'" != "" local opplot_footnote `"`opplot_footnote'; ${OS_498} = `deffs'"'  // Design Effect
		if "`footnoteicc'"  != "" local opplot_footnote `"`opplot_footnote'; `icclabel' = `iccs'"' // Intracluster Correlation Coefficient
		if `"`opplot_footnote'"' != "" local opplot_footnote = usubstr(`"`opplot_footnote'"', 3, .)

		* The option footnote is a synonym for note; if both are provided,
		* the footnote lines come first.  The automatic coverage/DEFF/ICC
		* line comes before both.  Text options typed by the user (e.g.,
		* size()) are kept; otherwise the note is size(vsmall).
		* (Unquoted text is taken literally, commas and all, as in earlier
		*  versions; put the text in quotes to add suboptions such as size().)
		opplot_quote_text `footnote'
		local foot_text `"`r(text)'"'
		local foot_opts `"`r(opts)'"'
		opplot_quote_text `note'
		local note_text `"`r(text)'"'
		local note_opts `"`r(opts)'"'
		local all_text
		if `"`opplot_footnote'"' != "" local all_text `"`"`opplot_footnote'"'"'
		local all_text `"`all_text' `foot_text' `note_text'"'
		local all_opts `"`note_opts'"'
		if `"`all_opts'"' == "" local all_opts `"`foot_opts'"'
		if strpos(`"`all_opts'"', "size(") == 0 local all_opts `"size(vsmall) `all_opts'"'

		* title, subtitle and caption are passed as typed (as in earlier
		* versions), with unquoted text wrapped in quotes; xtitle, ytitle
		* and ytitle2 take unquoted text literally, as earlier versions did
		foreach o in title subtitle caption {
			if `"``o''"' != "" {
				opplot_split_text ``o''
				local `o' `"`r(full)'"'
			}
		}
		foreach o in xtitle ytitle {
			if `"``o''"' != "" {
				opplot_quote_text ``o''
				local `o' `"`r(full)'"'
			}
		}
		if `"`ytitle2'"' != "" {
			opplot_quote_text `ytitle2'
			local ytitle2 `"`r(text)'"'
			local ytitle2_opts `"`r(opts)'"'
		}

		local pass_thru
		if strtrim(`"`all_text'"') != "" local pass_thru `"`pass_thru' note(`all_text', `all_opts')"'
		if `"`title'"'    != "" local pass_thru `"`pass_thru' title(`title')"'
		if `"`subtitle'"' != "" local pass_thru `"`pass_thru' subtitle(`subtitle')"'
		if `"`caption'"'  != "" local pass_thru `"`pass_thru' caption(`caption')"'
		if `"`ytitle'"'   != "" local pass_thru `"`pass_thru' ytitle(`ytitle')"'
		if `"`xtitle'"'   == "" local xtitle `""""'
		local pass_thru `"`pass_thru' xtitle(`xtitle') ylabel(`ylabel')"'

		*-----------------------------------------------------------------------
		* x axis: nothing, the user's xlabel(), or cluster ID labels
		*-----------------------------------------------------------------------
		if `"`xlabel'"' != "" {
			local xlabelstring xlabel(`xlabel')
		}
		else if "`barlabels'" != "" {
			* barlabsize() sets the label size (default vsmall)
			if `"`barlabsize'"' == "" local barlabsize vsmall
			local xl
			local vlab : value label `clustvar'
			capture confirm string variable `clustvar'
			local isstring = (_rc == 0)
			forvalues i = 1/`nclusters' {
				local mid = `xleft'[`i'] + `barwidth'[`i']/2
				if `isstring'           local lab = `clustvar'[`i']
				else if "`vlab'" != ""  local lab : label `vlab' `=`clustvar'[`i']'
				else                    local lab = strofreal(`clustvar'[`i'], "%12.0g")
				local lab = subinstr(`"`lab'"', `"""', "", .)
				local xl `"`xl' `mid' `"`lab'"'"'
			}
			local xlabelstring `"xlabel(`xl', angle(90) labsize(`barlabsize') noticks nogrid)"'
		}
		else local xlabelstring xlabel(none)

		*-----------------------------------------------------------------------
		* If the user asks to plot the number of respondents (N) then
		* set up the twoway line and twoway scatteri syntax to do it.
		*-----------------------------------------------------------------------
		if "`plotn'" != "" {
			local nlinecolor = subinstr(`"`nlinecolor'"', `"""', "", .)
			if `"`nlinecolor'"'   == "" local nlinecolor gs10
			if "`nlinewidth'"   == "" local nlinewidth *.5
			if "`nlinepattern'" == "" local nlinepattern dash
			if `"`ytitle2'"'      == "" local ytitle2 `""${OS_317}""' // Number of Respondents
			sum `n_respondents'
			local y2max = `yround2' * ceil(`=r(max)+1'/`yround2')
			local plotnsyntax (line `n_respondents' `xleft', connect(stairstep) lc(`"`nlinecolor'"') lw(`nlinewidth') lp(`nlinepattern') yaxis(2)) ///
				(scatteri `=`n_respondents'[`=_N-1']' `=`xleft'[`=_N-1']' `=`n_respondents'[`=_N-1']' `=`xleft'[`=_N']' , ///
				ms(i) connect(direct) lc(`"`nlinecolor'"') lw(`nlinewidth') lp(`nlinepattern') yaxis(2))
			local yaxis2title ytitle(`ytitle2', `ytitle2_opts' axis(2))
			local yaxis2label ylabel(0(`yround2')`y2max', axis(2) angle(0))
		}

		*-----------------------------------------------------------------------
		* The bars
		*-----------------------------------------------------------------------
		local barcommon bartype(spanning) lpattern(solid) lwidth(`barlinewidth')

		if !`threecolor' {
			local plotit ///
				(bar `bartop'    `xleft', `barcommon' fcolor(`"`barcolor2'"') lcolor(`"`linecolor2'"')) ///
				(bar `barheight' `xleft', `barcommon' fcolor(`"`barcolor1'"') lcolor(`"`linecolor1'"'))
			if "`catlegend'" != "" noi di as text "opplot note: catlegend applies only to plots with coverage categories (lcthreshold or hcthreshold < 100)."
			local legendstring legend(off)
		}
		else {
			* We draw the high-coverage bars for every cluster, then draw the
			* mid-coverage bars on top of them starting at the first mid (or low)
			* cluster, then the low-coverage bars starting at the first low
			* cluster.  Bars are sorted by height, so each category is a
			* contiguous run at the right end of the plot.
			local plotit ///
				(bar `bartop'    `xleft', `barcommon' fcolor(`"`barcolorhigh2'"') lcolor(`"`linecolorhigh2'"')) ///
				(bar `barheight' `xleft', `barcommon' fcolor(`"`barcolorhigh1'"') lcolor(`"`linecolorhigh1'"')) ///
				(bar `bartop'    `xleft' if `category' >= 2 | (_n == _N & `category'[_n-1] >= 2), `barcommon' fcolor(`"`barcolormid2'"') lcolor(`"`linecolormid2'"')) ///
				(bar `barheight' `xleft' if `category' >= 2 | (_n == _N & `category'[_n-1] >= 2), `barcommon' fcolor(`"`barcolormid1'"') lcolor(`"`linecolormid1'"'))
			if `lcgiven' {
				local plotit `plotit' ///
				(bar `bartop'    `xleft' if `category' == 3 | (_n == _N & `category'[_n-1] == 3), `barcommon' fcolor(`"`barcolorlow2'"') lcolor(`"`linecolorlow2'"')) ///
				(bar `barheight' `xleft' if `category' == 3 | (_n == _N & `category'[_n-1] == 3), `barcommon' fcolor(`"`barcolorlow1'"') lcolor(`"`linecolorlow1'"'))
			}

			* Add the hcline and lcline if requested
			if "`lcline'" != "" & `lcgiven'          local plot_lc_line   (scatteri `lcthreshold' 0 `lcthreshold' 100, lc(gs8) lp(dash) connect(direct) ms(i))
			if "`hcline'" != "" & `hcthreshold' < 100 local plot_high_line (scatteri `hcthreshold' 0 `hcthreshold' 100, lc(gs8) lp(dash) connect(direct) ms(i))

			* Optional legend that names the categories and counts the clusters
			if "`catlegend'" != "" {
				local le = uchar(8804)   // less than or equal to
				local ge = uchar(8805)   // greater than or equal to
				local hcs = strofreal(`hcthreshold', "%9.0g")
				if `lcgiven' local lcs = strofreal(`lcthreshold', "%9.0g")
				if `hcthreshold' == 100 local labh 100%
				else                    local labh `ge'`hcs'%
				if `lcgiven' local labm >`lcs'% - <`hcs'%
				else         local labm <`hcs'%
				local lo order(2 `"`labh' (n = `n_high')"'
				* (no mid category when lcthreshold == hcthreshold)
				local showmid 1
				if `lcgiven' {
					if `lcthreshold' >= `hcthreshold' local showmid 0
				}
				if `showmid' local lo `lo' 4 `"`labm' (n = `n_mid')"'
				if `lcgiven' local lo `lo' 6 `"`le'`lcs'% (n = `n_low')"'
				local lo `lo')
				local legendstring legend(`lo' rows(1) size(small) position(6) region(lstyle(none)) symxsize(*.6))
			}
			else local legendstring legend(off)
		}

		graph twoway `plotit' `plotnsyntax' `plot_lc_line' `plot_high_line', ///
			graphregion(fcolor(white)) `pass_thru' `legendstring' ///
			`namestring' `savingstring' `xsizestring' `ysizestring' ///
			`xlabelstring' `yaxis2label' `yaxis2title' `twoway'

		if "`export'" != "" {
			graph export "`export'", width(`exportwidth') replace
		}

		*-----------------------------------------------------------------------
		* Saved results
		*-----------------------------------------------------------------------
		return scalar N         = `n'
		return scalar nclusters = `nclusters'
		return scalar nmissing  = `nmissing_total'
		return scalar covg      = 100*`p'
		return scalar deff      = `deff'
		return scalar icc       = `icc'
		return scalar hcthreshold = `hcthreshold'
		if `lcgiven'   return scalar lcthreshold = `lcthreshold'
		if `threecolor' {
			return scalar n_high = `n_high'
			return scalar n_mid  = `n_mid'
			if `lcgiven' return scalar n_low = `n_low'
			else         return scalar n_low = 0
		}
		return local stratum `"`stratum'"'
		return local yvar `yvar'

		* If the user has asked for underlying data to be saved, then
		* trim down to a small dataset that summarizes what is shown in
		* the bars; this is to help users identify the clusterid of a
		* particular bar in the figure; the order in which clusterids
		* appear in the saved dataset is the same order they appear in
		* the plot

		* Strip off double quotes if user supplied filename in double quotes
		local savedata = subinstr(`"`savedata'"', `"""',  "", .)

		* Strip off , replace if user supplied it in the savedata option
		local savedata = subinstr(`"`savedata'"', ", replace",  "", .)
		local savedata = subinstr(`"`savedata'"', ",replace" ,  "", .)
		local savedata = strtrim(`"`savedata'"')

		if `"`savedata'"' != "" {
			drop in `=_N'
			keep `clustvar' `n_respondents' `barwidth' `barheight' `n_yes' `n_miss' `wclust' `category'
			gen yvar     = "`yvar'"
			gen stratvar = "`stratvar'"
			gen stratum  = `"`stratum'"'
			gen cluster  = "`clustvar'"
			gen long   n_respondents       = `n_respondents'
			gen long   barorder            = _n
			gen double barwidth            = `barwidth'
			* cumulative barwidth starts at the width of bar 1
			gen double cumulative_barwidth = sum(barwidth)
			gen double barheight           = `barheight'
			gen long   n_outcome1          = `n_yes'
			gen long   n_missing           = `n_miss'
			gen double sum_weights         = `wclust'
			gen byte   category            = `category'
			gen double lcthreshold         = `=cond(`lcgiven', 0`lcthreshold', .)'
			gen double hcthreshold         = `=cond(`threecolor', `hcthreshold', .)'
			format %5.1f barwidth cumulative_barwidth barheight
			label define opplot_category 1 "high" 2 "mid" 3 "low", replace
			label values category opplot_category
			label variable yvar                "Outcome variable"
			label variable stratvar            "Stratum variable"
			label variable stratum             "Stratum plotted"
			label variable cluster             "Cluster variable"
			label variable n_respondents       "Respondents in cluster"
			label variable barorder            "Bar order, left to right"
			label variable barwidth            "Bar width (% of stratum weight)"
			label variable cumulative_barwidth "Right edge of bar (cumulative width)"
			label variable barheight           "Bar height (weighted % with outcome = 1)"
			label variable n_outcome1          "Respondents with outcome = 1"
			label variable n_missing           "Respondents with missing outcome (counted as 0)"
			label variable sum_weights         "Sum of weights in cluster"
			label variable category            "Coverage category"
			label variable lcthreshold         "Low coverage threshold"
			label variable hcthreshold         "High coverage threshold"
			keep  yvar stratvar stratum cluster `clustvar' n_respondents barorder barwidth ///
				cumulative_barwidth barheight n_outcome1 n_missing sum_weights category ///
				lcthreshold hcthreshold
			order yvar stratvar stratum cluster `clustvar' n_respondents barorder barwidth ///
				cumulative_barwidth barheight n_outcome1 n_missing sum_weights category ///
				lcthreshold hcthreshold
			capture save `"`savedata'"', replace
			if _rc != 0 opplot_error 603 `"opplot error: could not save the dataset `savedata' (does the folder exist?)."'
		}
	}
end

********************************************************************************
********************************************************************************

* Split the contents of a text option such as note() into its text and its
* suboptions; unquoted text is wrapped in double quotes
capture program drop opplot_split_text
program define opplot_split_text, rclass
	version 14.1
	_parse comma text opts : 0
	local text = strtrim(`"`text'"')
	local opts = strtrim(usubstr(`"`opts'"', 2, .))
	local first = usubstr(`"`text'"', 1, 1)
	if `"`text'"' != "" & `"`first'"' != `"""' & `"`first'"' != char(96) local text `"`"`text'"'"'
	return local text `"`text'"'
	return local opts `"`opts'"'
	if `"`opts'"' != "" return local full `"`text', `opts'"'
	else                return local full `"`text'"'
end

* Like opplot_split_text, but text that does not start with a quote is taken
* literally (commas included) and wrapped in quotes, with no suboptions.
* This is how note(), footnote(), xtitle(), ytitle() and ytitle2() behaved
* before version 2.00.
capture program drop opplot_quote_text
program define opplot_quote_text, rclass
	version 14.1
	local text = strtrim(`"`0'"')
	local first = usubstr(`"`text'"', 1, 1)
	if `"`text'"' != "" & `"`first'"' != `"""' & `"`first'"' != char(96) {
		return local text `"`"`text'"'"'
		return local opts ""
		return local full `"`"`text'"'"'
	}
	else {
		opplot_split_text `text'
		return add
	}
end

********************************************************************************
********************************************************************************

* Intracluster correlation coefficient using the one-way ANOVA estimator.
* This reproduces VCQI's calcicc (which uses loneway_plus): unlike Stata's
* loneway, the ICC is NOT truncated at 0, and when coverage is identical in
* every cluster (so both mean squares are 0) the ICC is -1/(mwtd-1).
* Argument 1 is a 0/1 outcome with no missing values; argument 2 is the
* cluster ID.  Returns r(icc), r(ms_between), r(ms_within), r(mwtd).
capture program drop opplot_icc
program define opplot_icc, rclass
	version 14.1
	args y c
	tempvar tag ni mi sb sw n2
	tempname N k ssb ssw sumn2 msb msw mwtd icc
	quietly {
		scalar `N' = _N
		egen byte `tag' = tag(`c')
		count if `tag'
		scalar `k' = r(N)
		if `k' < 2 | `N' <= `k' {
			return scalar icc = .
			exit
		}
		bysort `c': gen double `ni' = _N
		by `c': egen double `mi' = mean(`y')
		sum `y', meanonly
		gen double `sb' = (`mi' - r(mean))^2
		gen double `sw' = (`y' - `mi')^2
		sum `sb', meanonly
		scalar `ssb' = r(sum)
		sum `sw', meanonly
		scalar `ssw' = r(sum)
		gen double `n2' = `ni'^2 if `tag'
		sum `n2', meanonly
		scalar `sumn2' = r(sum)
		scalar `msb'  = `ssb' / (`k' - 1)
		scalar `msw'  = `ssw' / (`N' - `k')
		scalar `mwtd' = (`N' - `sumn2'/`N') / (`k' - 1)
		if `msb' > 0 | `msw' > 0 scalar `icc' = (`msb' - `msw') / (`msb' + (`mwtd' - 1) * `msw')
		else                     scalar `icc' = -1 / (`mwtd' - 1)
		return scalar icc        = `icc'
		return scalar ms_between = `msb'
		return scalar ms_within  = `msw'
		return scalar mwtd       = `mwtd'
	}
end

********************************************************************************
********************************************************************************

* Show an error, send it to the VCQI log if VCQI is running, and stop
capture program drop opplot_error
program define opplot_error
	version 14.1
	gettoken rc 0 : 0
	local msg `"`0'"'
	noi di as error `msg'
	if "$VCQI_LOGOPEN" == "1" {
		vcqi_log_comment $VCP 1 Error `msg'
		vcqi_halt_immediately
	}
	exit `rc'
end
