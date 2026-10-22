{smcl}
{* *! opplot.sthlp version 2.01 - Biostat Global Consulting - 2026-10-21}{...}
{* Change log: }{...}
{* 				Updated}{...}
{*				version}{...}
{* Date 		number 	Name			What Changed}{...}
{* 2017-12-20	1.00	Dale Rhoda		Original version}{...}
{* 2024-01-04	1.04	Dale Rhoda		Coverage categories and footnotes}{...}
{* 2026-10-21	2.00	Dale Rhoda		Rewritten for opplot 2.00 (with Claude)}{...}
{* 2026-10-21	2.01	Dale Rhoda		barlabsize(); clearer r(n_*) entries (with Claude)}{...}
{vieweralsosee "[G-2] graph twoway bar" "help twoway_bar"}{...}
{vieweralsosee "[SVY] svyset" "help svyset"}{...}
{vieweralsosee "[R] loneway" "help loneway"}{...}
{viewerjumpto "Syntax" "opplot##syntax"}{...}
{viewerjumpto "Description" "opplot##description"}{...}
{viewerjumpto "Options" "opplot##options"}{...}
{viewerjumpto "Missing values" "opplot##missing"}{...}
{viewerjumpto "Coverage categories" "opplot##categories"}{...}
{viewerjumpto "Footnote statistics" "opplot##stats"}{...}
{viewerjumpto "Saved dataset" "opplot##savedata"}{...}
{viewerjumpto "Stored results" "opplot##results"}{...}
{viewerjumpto "Examples" "opplot##examples"}{...}
{viewerjumpto "VCQI" "opplot##vcqi"}{...}
{title:Title}

{phang}
{bf:opplot} {hline 2} Organ pipe plot: one bar per cluster for a 0/1 outcome in cluster survey data


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{cmd:opplot} {it:yvar} {ifin} {cmd:,} {opt clustvar(varname)} [{it:options}]

{synoptset 30 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Required}
{synopt :{opt clustvar(varname)}}cluster ID (numeric or string){p_end}

{syntab:Data}
{synopt :{opt stratvar(varname)}}stratum variable; requires {opt stratum()}{p_end}
{synopt :{opt stratum(string)}}the value of {it:stratvar} to plot{p_end}
{synopt :{opt stratumname(string)}}name of the stratum, recorded in the saved dataset's notes{p_end}
{synopt :{opt weight:var(varname)}}survey weight; default is equal weights{p_end}
{synopt :{opt equalwidth}}draw every bar with the same width{p_end}

{syntab:Bar colors (two-color plots)}
{synopt :{opt barcolor1(color)}}shaded (outcome = 1) part of the bars; default {cmd:pink}{p_end}
{synopt :{opt barcolor2(color)}}unshaded part of the bars; default {cmd:white}{p_end}
{synopt :{opt linecolor1(color)}}outline of the shaded part; default {it:barcolor1}{cmd:*1.5}{p_end}
{synopt :{opt linecolor2(color)}}outline of the unshaded part; default {cmd:black*0.5}{p_end}
{synopt :{opt barlinew:idth(linewidth)}}width of all bar outlines; default {cmd:*.1}, or {cmd:none} above 150 clusters{p_end}

{syntab:Coverage categories (three-color plots)}
{synopt :{opt lcthresh:old(#)}}clusters with coverage <= # are "low"{p_end}
{synopt :{opt hcthreshold(#)}}clusters with coverage >= # are "high"; default 100{p_end}
{synopt :{opt high(#)}}older name for {opt hcthreshold()}{p_end}
{synopt :{opt lcline}}dashed line at the low threshold{p_end}
{synopt :{opt hcline}}dashed line at the high threshold (if below 100){p_end}
{synopt :{opt catlegend}}legend naming each category and counting its clusters{p_end}
{synopt :{opt barcolorhigh1(color)} ...}colors for each category; see {help opplot##categories:below}{p_end}

{syntab:Number of respondents}
{synopt :{opt plotn}}add a line showing the number of respondents per cluster (right axis){p_end}
{synopt :{opt nlinec:olor(color)}}color of that line; default {cmd:gs10}{p_end}
{synopt :{opt nlinew:idth(linewidth)}}width of that line; default {cmd:*.5}{p_end}
{synopt :{opt nlinep:attern(pattern)}}pattern of that line; default {cmd:dash}{p_end}
{synopt :{opt ytitle2(text)}}title of the right axis; default "Number of Respondents"{p_end}
{synopt :{opt yround2(#)}}right axis runs from 0 to a multiple of #; default 5{p_end}

{syntab:Footnote statistics}
{synopt :{opt footnotecovg}}show the estimated coverage{p_end}
{synopt :{opt footnotedeff}}show the design effect{p_end}
{synopt :{opt footnoteicc}}show the intracluster correlation coefficient{p_end}

{syntab:Text and axes}
{synopt :{opt title(tinfo)}}title; also {opt sub:title()}, {opt caption()}{p_end}
{synopt :{opt note(tinfo)}}note below the plot; {opt foot:note()} is a synonym{p_end}
{synopt :{opt xtitle(axis_title)}}x-axis title; also {opt ytitle()}{p_end}
{synopt :{opt xlabel(rule_or_values)}}x-axis labels; also {opt ylabel()}{p_end}
{synopt :{opt barlabels}}label each bar with its cluster ID{p_end}
{synopt :{opt barlabs:ize(textsizestyle)}}size of the {opt barlabels} labels; default {cmd:vsmall}{p_end}

{syntab:Output}
{synopt :{opt name(name)}}name of the graph in memory ({cmd:replace} is implied){p_end}
{synopt :{opt saving(filename[, replace])}}save the graph as a .gph file{p_end}
{synopt :{opt export(filename)}}export the graph, e.g., {cmd:plot.png}{p_end}
{synopt :{opt exportw:idth(#)}}width in pixels for {opt export()}; default 2000{p_end}
{synopt :{opt exportstra:tumname}}export to {it:stratum}{cmd:.png}{p_end}
{synopt :{opt savedata(filename)}}save a dataset with one row per bar{p_end}
{synopt :{opt xsize(#)} {opt ysize(#)}}size of the graph{p_end}
{synopt :{opt twoway(twoway_options)}}any other {help twoway_options:twoway options}{p_end}

{syntab:Messages}
{synopt :{opt nowarn:ings}}do not warn about respondents with a missing outcome{p_end}
{synoptline}
{p 4 6 2}
{it:yvar} must be numeric and take only the values 0, 1 or missing.{p_end}


{marker description}{...}
{title:Description}

{pstd}
{cmd:opplot} draws an {it:organ pipe plot}, a bar chart that summarizes a
binary outcome in cluster survey data.  Each cluster is a vertical bar.  The
height of the shaded part of a bar is the (weighted) percent of respondents in
that cluster whose {it:yvar} is 1, also called the cluster's {it:coverage}.
The width of a bar is proportional to the sum of the survey weights in the
cluster.  Bars are sorted from the highest coverage on the left to the lowest
on the right, so the plot looks like a row of organ pipes.{p_end}

{pstd}
Because widths are proportional to weights, the shaded fraction of the whole
plot equals the survey-weighted coverage estimate for the stratum.  The
variation in bar heights is a picture of the intracluster correlation: when
every cluster has about the same coverage the ICC is near zero; when some
clusters are fully vaccinated and others hardly at all, it is large.  The plots
are also useful for spotting clusters with surprisingly low (or high) coverage,
which may deserve follow-up.  The optional saved dataset tells you which
cluster each bar represents.{p_end}

{pstd}
Organ pipe plots were developed for vaccination coverage surveys (see section
6.1.2 of the World Health Organization's {it:Vaccination Coverage Cluster
Surveys: Reference Manual}, 2018), but they are useful for any cluster survey
with a binary outcome.  They have some features in common with Pareto charts
from quality control.{p_end}

{pstd}
{cmd:opplot} plots one stratum at a time.  If your data hold several strata,
give the stratum variable in {opt stratvar()} and the stratum to plot in
{opt stratum()}, and call {cmd:opplot} once per stratum (see the
{help opplot##examples:examples}).{p_end}

{pstd}
{cmd:opplot} requires only official Stata 14.1 or later.{p_end}


{marker options}{...}
{title:Options}

{dlgtab:Required}

{phang}
{opt clustvar(varname)} names the cluster ID.  Observations with a missing
cluster ID are excluded (with a note).

{dlgtab:Data}

{phang}
{opt stratvar(varname)} and {opt stratum(string)} select one stratum.  If
{it:stratvar} is numeric, {opt stratum()} must be a number; if it is a string
variable, {opt stratum()} is matched exactly, including upper/lower case
(e.g., {cmd:stratum(North Region)}).
Without these options all of the data (after {cmd:if} and {cmd:in}) are
plotted as one stratum.  {cmd:opplot} stops with an error if the stratum has
no observations.

{phang}
{opt stratumname(string)} records a name for the stratum in the notes of the
saved dataset.

{phang}
{opt weightvar(varname)} gives the survey weights; bar widths are proportional
to the sum of weights in each cluster, and bar heights are weighted
percents.  Without it, all respondents have equal weight, so widths are
proportional to the number of respondents.  Negative weights are an error.

{pmore}
Rows with a {bf:missing or zero weight} represent no respondents and are left
out of everything {cmd:opplot} summarizes: bar widths and heights, the number
of respondents, the coverage categories, the coverage and the ICC.  (Zero-weight
rows stay in the survey design when the DEFF is computed, so that their
clusters count, as in VCQI; see {help opplot##stats:Footnote statistics}.)
(In VCQI such rows are typically placeholders for sampled clusters that
yielded no eligible respondents.  Zero-weight rows are kept in the survey
design while the DEFF is computed, so that those clusters count, and are left
out of everything else; rows with a missing weight are left out entirely.)  A cluster made up only of such rows does not
appear as a bar.  Outside VCQI, {cmd:opplot} displays a note giving the number
of rows excluded.

{phang}
{opt equalwidth} draws every bar with the same width (100 / number of
clusters).  Bar heights and the footnote statistics still use {opt weightvar()}.
Equal widths are handy with {opt barlabels}.

{dlgtab:Bar colors}

{phang}
{opt barcolor1()}, {opt barcolor2()}, {opt linecolor1()} and {opt linecolor2()}
set the colors of two-color plots.  Any Stata {help colorstyle} may be used,
including RGB values ({cmd:barcolor1(0 114 178)}) and intensities
({cmd:barcolor1(navy*0.6)}).  The outline of the shaded part defaults to a
slightly darker version of {it:barcolor1}.

{phang}
{opt barlinewidth(linewidth)} sets the width of the outlines that separate the
bars.  The default is {cmd:*.1} for up to 150 clusters and {cmd:none} for
more than 150, where outlines would wash out the fill colors.  Specify, e.g.,
{cmd:barlinewidth(*.1)} to keep outlines on a large plot, or
{cmd:barlinewidth(none)} to remove them from a small one.

{dlgtab:Number of respondents}

{phang}
{opt plotn} adds a stair-step line showing the number of respondents in each
cluster, read from a second y-axis on the right.  Small clusters with low
coverage may be less alarming than large ones.  {opt nlinecolor()},
{opt nlinewidth()}, {opt nlinepattern()}, {opt ytitle2()} and {opt yround2()}
control the line and its axis.  The right axis runs from 0 to (the largest
cluster size plus one) rounded up to a multiple of {opt yround2()}.

{dlgtab:Footnote statistics}

{phang}
{opt footnotecovg}, {opt footnotedeff} and {opt footnoteicc} put the estimated
coverage, design effect and intracluster correlation coefficient on one line
at the bottom of the plot, e.g.,
"Estimated Coverage = 80.9%; Design effect = 3.9; Intracluster correlation
coefficient = 0.2798".  See {help opplot##stats:Footnote statistics}.

{dlgtab:Text and axes}

{phang}
{opt title()}, {opt subtitle()}, {opt caption()}, {opt xlabel()} and
{opt ylabel()} are passed to {cmd:graph twoway} as you type them, so quoted
text with commas, several lines and suboptions all work, e.g.,
{cmd:title("Kandal, Phnom Penh", size(medium))}.  As in {cmd:graph}, put a
title that contains a comma in double quotes.

{phang}
{opt xtitle()}, {opt ytitle()}, {opt ytitle2()}, {opt note()} and
{opt footnote()} work the same way when the text is in double quotes.
Unquoted text is taken literally, commas included, as in earlier versions
of {cmd:opplot}: {cmd:note(Source: survey, 2024)} prints "Source: survey, 2024".

{phang}
{opt note()} and its synonym {opt footnote()} add notes below the plot.  If
you give both, the {opt footnote()} lines come first.  The automatic footnote
statistics line, if requested, comes before both.  Notes are
{cmd:size(vsmall)} unless you give a size yourself, e.g.,
{cmd:note("Line 1" "Line 2", size(small))}; other suboptions (e.g.,
{cmd:color(red)}) are kept as well.

{phang}
{opt ytitle()} defaults to "Percent of Cluster".  {cmd:ytitle(none)} removes
the title (and shifts the plot slightly left); {cmd:ytitle(" ")} leaves a
blank title.  {opt ylabel()} defaults to {cmd:0(50)100, angle(h) nogrid}.

{phang}
The x axis has no labels by default; its scale is the cumulative percent of
the stratum's weight.  {opt barlabels} labels each bar with its cluster ID
(the value label is used if there is one).  This is most legible with
{opt equalwidth} and up to a few dozen clusters.  The labels are vertical
and {cmd:vsmall} by default; {opt barlabsize()} sets their size, e.g.,
{cmd:barlabsize(medium)} or {cmd:barlabsize(*1.5)} (see
{help textsizestyle}), and implies {opt barlabels}.  If the size is not
a valid Stata text size, Stata notes that and uses its default size.
{opt xlabel()} overrides {opt barlabels} and {opt barlabsize()}, and opplot
displays a note saying so.

{dlgtab:Output}

{phang}
{opt name()} names the graph in memory; {cmd:replace} is always implied.
{opt saving()} saves a .gph file.  {opt export()} exports the graph to any
format that {helpb graph export} supports with a {cmd:width()} option (e.g.,
.png or .tif), {opt exportwidth()} pixels wide, replacing any existing file.  {opt exportstratumname}
exports to {it:stratum}{cmd:.png} in the current folder unless {opt export()}
is also given.

{phang}
{opt savedata(filename)} saves a dataset with one row per bar; see
{help opplot##savedata:Saved dataset}.  The file name may be in quotes and may
be followed by ", replace", e.g., {cmd:savedata("my bars", replace)}; an
existing file is always replaced.  {cmd:opplot} stops with an error if the file
cannot be saved.

{phang}
{opt twoway()} passes any other {help twoway_options} to the graph.  These come
last, so they take precedence over {cmd:opplot}'s own settings, e.g.,
{cmd:twoway(graphregion(color(gs15)))}.

{dlgtab:Messages}

{phang}
{opt nowarnings} suppresses the warning that {cmd:opplot} otherwise displays
when some respondents with a positive weight have a missing outcome; see
{help opplot##missing:Missing values}.  It changes nothing else.


{marker missing}{...}
{title:Missing values of the outcome}

{pstd}
{cmd:opplot} counts a missing value of {it:yvar} as {bf:0} for any respondent
with a positive weight: the respondent is in the denominator but shows no
evidence of the outcome.  (Rows with a missing or zero weight are excluded
altogether; see {opt weightvar()}.)  Internally the
program makes a temporary copy of {it:yvar} in which missing values are
replaced by 0, and uses that copy for {bf:everything}: the bar heights, the
coverage categories, the stored results, and the footnote coverage, design
effect and ICC.  So the shaded area of the plot agrees with the footnote
coverage (unless the data were already {cmd:svyset} with a different weight;
see {help opplot##stats:Footnote statistics}).  Bar widths depend only on the
weights, so respondents with a missing outcome still count toward their
cluster's width.  A cluster in which every respondent with a positive weight
has a missing outcome is drawn as a 0% bar.{p_end}

{pstd}
If a missing value means "not part of the denominator" (for example, a child
not eligible for an indicator), leave those respondents out with {cmd:if}:{p_end}

{phang2}{cmd:. opplot y if !missing(y), clustvar(clusterid)}{p_end}

{pstd}
{bf:Warning.}  Unless you specify {opt nowarnings}, whenever respondents with a
positive weight have a missing outcome {cmd:opplot} displays, after the plot,{p_end}

{phang2}{cmd:opplot warning: 5 out of 96 respondents with a positive weight have a missing value of y (counted as 0).}{p_end}

{pstd}
where 96 is the number of respondents with a positive weight in the plot
({cmd:r(N)}) and 5 of them have a missing outcome ({cmd:r(nmissing)}).  Rows
with a zero or missing weight are never counted.  When VCQI is running, the
period is replaced by "; inside VCQI, opplot.ado was called from
{it:program} with this syntax: opplot {it:...}", giving the VCQI program
that called {cmd:opplot} and the full {cmd:opplot} command, and the same
text is written to the VCQI log as a warning.  If that text would be longer
than the 2,045 characters a VCQI log entry can hold, the command is left out:
"; inside VCQI, opplot.ado was called from {it:program}."{p_end}

{pstd}
The number of missing values is stored in {cmd:r(nmissing)}, in the notes of
the saved dataset, and per cluster in the saved variable {cmd:n_missing}.{p_end}


{marker categories}{...}
{title:Coverage categories (three-color plots)}

{pstd}
By default all bars are drawn in {opt barcolor1()}.  If you specify
{opt lcthreshold()}, or {opt hcthreshold()} below 100, each cluster is
assigned to a category and the categories are drawn in different colors:{p_end}

{p2colset 8 24 26 2}{...}
{p2col:{bf:high}}coverage >= {opt hcthreshold()} (by default, exactly 100%){p_end}
{p2col:{bf:low}}coverage <= {opt lcthreshold()}{p_end}
{p2col:{bf:mid}}everything else{p_end}
{p2colreset}{...}

{pstd}
For example, {cmd:lcthreshold(50)} shows clusters where every respondent had
the outcome in light blue, clusters with more than 50% but less than 100% in
dark blue, and clusters with 50% or less in orange.  Thresholds need not
be whole numbers (e.g., {cmd:lcthreshold(33.3)}).  {opt lcthreshold()} must be
at least 0 and less than 100, {opt hcthreshold()} must be more than 0 and at
most 100, and {opt lcthreshold()} may not exceed {opt hcthreshold()};
otherwise {cmd:opplot} stops with an error.{p_end}

{pstd}
Special cases: if {opt lcthreshold()} equals {opt hcthreshold()} there are two
categories, and a cluster exactly at the threshold is {bf:low}.  If you give
only {opt hcthreshold()} (below 100) there are two categories, high and mid,
and a cluster exactly at the threshold is {bf:high}.  Giving
{cmd:hcthreshold(100)} without {opt lcthreshold()} is the same as giving neither:
a two-color plot.{p_end}

{pstd}
{opt catlegend} adds a legend such as "100% (n = 57)   >50% - <100% (n = 54)
<=50% (n = 19)" (drawn with the symbols for "less than or equal to" and
"greater than or equal to") that names each category and counts its
clusters.  Without it
there is no legend, so explain the colors in a note or in the text of your
report.  {opt lcline} and {opt hcline} add dashed reference lines at the
thresholds.{p_end}

{pstd}
Category colors.  For each category there are four colors: the shaded part
({opt barcolor}{it:cat}{opt 1}), the unshaded part ({opt barcolor}{it:cat}{opt 2}),
and their outlines ({opt linecolor}{it:cat}{opt 1}, {opt linecolor}{it:cat}{opt 2}),
where {it:cat} is {cmd:high}, {cmd:mid} or {cmd:low}.  The twelve options are
{opt barcolorhigh1()}, {opt barcolorhigh2()}, {opt linecolorhigh1()}, {opt linecolorhigh2()},
{opt barcolormid1()}, {opt barcolormid2()}, {opt linecolormid1()}, {opt linecolormid2()},
{opt barcolorlow1()}, {opt barcolorlow2()}, {opt linecolorlow1()} and {opt linecolorlow2()}.
Defaults:{p_end}

{p2colset 8 32 34 2}{...}
{p2col:{opt barcolorhigh1()}}{cmd:103 169 207} (light blue){p_end}
{p2col:{opt barcolormid1()}}{cmd:0 0 128} (dark blue){p_end}
{p2col:{opt barcolorlow1()}}{cmd:255 91 0} (orange){p_end}
{p2col:{opt barcolor}{it:cat}{opt 2()}}{cmd:gs15}{p_end}
{p2col:{opt linecolor}{it:cat}{opt 1()}}{cmd:gs15}{p_end}
{p2col:{opt linecolor}{it:cat}{opt 2()}}{cmd:black*0.5}{p_end}
{p2colreset}{...}

{pstd}
In three-color plots {opt barcolor1()}, {opt barcolor2()}, {opt linecolor1()}
and {opt linecolor2()} are not used.{p_end}


{marker stats}{...}
{title:Footnote statistics}

{pstd}
The statistics are computed for the plotted stratum using the 0/1 copy of
the outcome (missing = 0):{p_end}

{phang2}
{bf:Coverage} is the survey-weighted proportion from
{cmd:svy, subpop(}{it:positive weight}{cmd:): mean}.  {cmd:opplot} does not
report a confidence interval.{p_end}

{phang2}
{bf:Design effect} = (N {c -} 1) / N_eff, where N is the number of
respondents with a positive weight and N_eff = p(1{c -}p)/SE^2.  It
is set to 1 when coverage is 0% or 100% or the standard error is 0.  If the
global macro {cmd:VCQI_DEFF_TRUNCATE} is not empty, a DEFF below 1 is set
to 1.  Rows with a zero weight stay in the survey design for this
calculation (outside the subpopulation), as in VCQI, so a sampled cluster
that yielded no respondents still counts as a cluster; they contribute
nothing else.{p_end}

{phang2}
{bf:ICC} is the one-way ANOVA estimator over clusters (unweighted).  Unlike
{helpb loneway}, it is {bf:not} truncated at 0.  When coverage is the same
in every cluster it equals {c -}1/(m0{c -}1), where
m0 = (N {c -} sum(n_i^2)/N)/(K {c -} 1) is the usual adjusted average cluster
size (N respondents, K clusters, n_i respondents in cluster i), so it is
negative.  The ICC is missing if there is only one cluster.
{p_end}

{pstd}
Survey design.  If the data are not {cmd:svyset}, {cmd:opplot} uses
{cmd:svyset} {it:clustvar} {cmd:[pweight=}{it:weightvar}{cmd:], singleunit(scaled)}
within the plotted stratum.  If the data are already {cmd:svyset},
{cmd:opplot} uses that design for the footnote statistics and for
{cmd:r(covg)} and {cmd:r(deff)}, even if its weight
differs from {opt weightvar()}, and (outside VCQI) displays a note saying
so.  The bars always use {opt weightvar()}.  Because only the plotted stratum
is kept, the statistics are computed on that stratum as a subset of the
data.{p_end}


{marker savedata}{...}
{title:Saved dataset}

{pstd}
{opt savedata()} saves one row per bar, in plot order (row 1 is the
left-most bar).  Use it to find the cluster ID of a surprising bar, to count
clusters by category, or to merge cluster categories back onto respondent
data.  Variables:{p_end}

{p2colset 8 30 32 2}{...}
{p2col:{cmd:yvar}, {cmd:stratvar}, {cmd:cluster}}names of the outcome, stratum and cluster variables (strings){p_end}
{p2col:{cmd:stratum}}the stratum plotted (string; "1" if no {opt stratvar()}){p_end}
{p2col:{it:clustvar}}the cluster ID, under its own name{p_end}
{p2col:{cmd:n_respondents}}respondents in the cluster with a positive weight{p_end}
{p2col:{cmd:n_outcome1}}respondents with {it:yvar} = 1{p_end}
{p2col:{cmd:n_missing}}respondents with missing {it:yvar} (counted as 0){p_end}
{p2col:{cmd:sum_weights}}sum of weights in the cluster (= {cmd:n_respondents} without {opt weightvar()}){p_end}
{p2col:{cmd:barorder}}position of the bar, left to right{p_end}
{p2col:{cmd:barwidth}}width of the bar (% of the stratum's weight){p_end}
{p2col:{cmd:cumulative_barwidth}}right edge of the bar{p_end}
{p2col:{cmd:barheight}}weighted % with {it:yvar} = 1 (to 0.001%){p_end}
{p2col:{cmd:category}}1 high, 2 mid, 3 low (missing in two-color plots){p_end}
{p2col:{cmd:lcthreshold}, {cmd:hcthreshold}}the thresholds used (missing if not used){p_end}
{p2colreset}{...}

{pstd}
The dataset's {help notes} record the coverage, the DEFF, the ICC, the
stratum ID and name, the number of missing outcomes, and the number of rows
with a missing or zero weight that are not represented.  With
{opt savedata()}, the cluster variable may not have the same name as one of
the variables above ({cmd:opplot} stops with an error).  Widths and heights
are stored unrounded (heights to 0.001%).{p_end}

{pstd}
Bar order.  Bars are sorted by descending height; ties are broken by
descending number of respondents, then descending width, then ascending
cluster ID.  The data in memory are not changed by {cmd:opplot}.{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:opplot} stores the following in {cmd:r()}:{p_end}

{synoptset 18 tabbed}{...}
{p2col 5 18 22 2: Scalars}{p_end}
{synopt:{cmd:r(N)}}respondents plotted (positive weight){p_end}
{synopt:{cmd:r(nclusters)}}clusters (bars); excludes clusters with no positive-weight rows{p_end}
{synopt:{cmd:r(nmissing)}}respondents with a positive weight and missing {it:yvar}{p_end}
{synopt:{cmd:r(covg)}}estimated coverage (percent){p_end}
{synopt:{cmd:r(deff)}}design effect{p_end}
{synopt:{cmd:r(icc)}}intracluster correlation coefficient{p_end}
{synopt:{cmd:r(hcthreshold)}}high threshold{p_end}
{synopt:{cmd:r(lcthreshold)}}low threshold (only if {opt lcthreshold()} was given){p_end}
{synopt:{cmd:r(n_high)}}clusters in the high category*{p_end}
{synopt:{cmd:r(n_mid)}}clusters in the mid category*{p_end}
{synopt:{cmd:r(n_low)}}clusters in the low category* (0 when {opt hcthreshold()} is given without {opt lcthreshold()}){p_end}
{synopt:}* returned only when the plot has coverage categories, that is, when {opt lcthreshold()} is given or {opt hcthreshold()} is below 100{p_end}

{p2col 5 18 22 2: Macros}{p_end}
{synopt:{cmd:r(stratum)}}stratum plotted{p_end}
{synopt:{cmd:r(yvar)}}outcome variable{p_end}
{p2colreset}{...}


{marker examples}{...}
{title:Examples}

{pstd}
The accompanying {cmd:opplot_demo.do} runs all of these and more.{p_end}

{pstd}Fake data: 2 strata, 10 clusters each{p_end}
{phang2}{cmd:. clear}{p_end}
{phang2}{cmd:. set seed 8675309}{p_end}
{phang2}{cmd:. set obs 200}{p_end}
{phang2}{cmd:. gen clusterid = round(runiform(1, 20))}{p_end}
{phang2}{cmd:. gen stratumid = clusterid > 10}{p_end}
{phang2}{cmd:. gen y = runiform() > mod(clusterid - 1, 10)/10}{p_end}
{phang2}{cmd:. gen weight = 1 + (clusterid == 11)}{p_end}

{pstd}One plot per stratum{p_end}
{phang2}{cmd:. opplot y, clustvar(clusterid) stratvar(stratumid) stratum(0) title(Stratum 0) name(s0)}{p_end}
{phang2}{cmd:. opplot y, clustvar(clusterid) stratvar(stratumid) stratum(1) title(Stratum 1) name(s1)}{p_end}

{pstd}Weights, colors, and the number of respondents{p_end}
{phang2}{cmd:. opplot y, clustvar(clusterid) stratvar(stratumid) stratum(1) weightvar(weight) barcolor1(ebblue) barcolor2(gs12) plotn}{p_end}

{pstd}Three coverage categories with a legend, footnote statistics, and an exported image{p_end}
{phang2}{cmd:. opplot y, clustvar(clusterid) lcthreshold(50) catlegend plotn nlinecolor(gold) footnotecovg footnotedeff footnoteicc export(all.png)}{p_end}
{phang2}{cmd:. return list}{p_end}

{pstd}Save the bars and look at the low-coverage clusters{p_end}
{phang2}{cmd:. opplot y, clustvar(clusterid) stratvar(stratumid) stratum(0) lcthreshold(50) savedata(s0_bars)}{p_end}
{phang2}{cmd:. preserve}{p_end}
{phang2}{cmd:. use s0_bars, clear}{p_end}
{phang2}{cmd:. list clusterid barheight n_respondents if category == 3}{p_end}
{phang2}{cmd:. restore}{p_end}

{pstd}Leave out respondents with a missing outcome instead of counting them as 0{p_end}
{phang2}{cmd:. opplot y if !missing(y), clustvar(clusterid) footnotecovg}{p_end}

{pstd}Label the bars, with equal widths{p_end}
{phang2}{cmd:. opplot y, clustvar(clusterid) stratvar(stratumid) stratum(1) equalwidth barlabels xtitle("Cluster ID")}{p_end}
{phang2}{cmd:. opplot y, clustvar(clusterid) stratvar(stratumid) stratum(1) equalwidth barlabsize(medium) xtitle("Cluster ID")}{p_end}

{pstd}Text with commas and several lines{p_end}
{phang2}{cmd:. opplot y, clustvar(clusterid) title("Region 1, North", size(medium)) note("Line 1" "Line 2, with a comma", size(small))}{p_end}

{pstd}One plot per stratum in a loop{p_end}
{phang2}{cmd:. levelsof stratumid, local(slist)}{p_end}
{phang2}{cmd:. foreach s of local slist {c -(}}{p_end}
{phang2}{cmd:.     opplot y, clustvar(clusterid) stratvar(stratumid) stratum(`s') lcthreshold(50) footnotecovg export(stratum_`s'.png)}{p_end}
{phang2}{cmd:.     di "Stratum `s': " r(n_low) " of " r(nclusters) " clusters at or below 50%"}{p_end}
{phang2}{cmd:. {c )-}}{p_end}


{marker vcqi}{...}
{title:Use within VCQI}

{pstd}
{cmd:opplot} is distributed with the World Health Organization's Vaccination
Coverage Quality Indicators (VCQI, pronounced {it:Vicki}) software, which uses
it to make an organ pipe plot for each stratum, but it does not depend on
VCQI.  When VCQI is running (global {cmd:VCQI_LOGOPEN} = 1), {cmd:opplot}
writes to the VCQI log and stops VCQI on an error.{p_end}

{pstd}
Language.  The axis titles and footnote labels come from the global macros
{cmd:OS_316} (Percent of Cluster), {cmd:OS_317} (Number of Respondents),
{cmd:OS_327} (Estimated Coverage), {cmd:OS_498} (Design effect) and
{cmd:OS_493} (Intracluster correlation coefficient).  VCQI sets them in the
user's language; if they are empty {cmd:opplot} uses the English text shown and
then clears them.  You can set them yourself to label plots in another
language.{p_end}

{pstd}
Versions.  {cmd:opplot} is available from SSC and as part of VCQI.  The code is
meant to be the same from both sources, but you might have an older copy from
one of them.  Type {cmd:which opplot} to see which copy Stata is using.{p_end}


{title:Authors}

{pstd}
Dale Rhoda, Mary Prier, Mary Kay Trimner and Caitlin Clary, Biostat Global
Consulting.  Versions 2.00 and 2.01 were prepared with the help of Claude (Anthropic).{p_end}

{pstd}
Email {browse "mailto:Dale.Rhoda@biostatglobal.com":Dale.Rhoda@biostatglobal.com}{p_end}


{title:Videos and slides}

{pmore}{browse "https://youtu.be/k-2NJMT_uvo":Organ Pipe Plots - Overview} (VCQI training video){p_end}
{pmore}{browse "https://youtu.be/sSGR60eOBrI":Organ Pipe Plots - Drilling Down} (the saved dataset){p_end}
{pmore}{browse "https://www.stata.com/meeting/columbus18/slides/columbus18_Prier.pptx":2018 Stata Conference presentation}{p_end}
{pmore}{browse "https://github.com/BiostatGlobalConsulting/organ-pipe-plots":GitHub repository} (slides describing newer features){p_end}
