
<!-- README.md is generated from README.Rmd. Please edit that file -->

# ir

<!-- badges: start -->

[![Lifecycle:
maturing](https://img.shields.io/badge/lifecycle-maturing-blue.svg)](https://www.tidyverse.org/lifecycle/#maturing)
<!-- badges: end -->

ir is an R package that contains simple functions to import, handle and
preprocess infrared spectra. Infrared spectra are stored as list columns
in `data.frame`s to enable efficient storage of metadata along with the
spectra and support further analyses containing other data for the same
samples.

Supported file formats for import currently are:

1.  .csv files with individual spectra.
2.  Thermo Galactic’s .spc files with individual spectra.

Provided functions for preprocessing and general handling are:

1.  baseline correction with:
      - a polynomial baseline
      - a convex hull baseline.
2.  binning.
3.  clipping.
4.  interpolating (resampling, linearly).
5.  replacing selected parts of a spectrum by a straight line.
6.  averaging spectra within specified groups.
7.  normalizing spectra:
      - to the maximum intensity
      - to the intensity at a specific x value
      - so that all intensity values sum to 1.
8.  smoothing:
      - Savitzky-Golay smoothing
      - Fourier smoothing.
9.  computing derivatives of spectra using Savitzky-Golay smoothing.

### How to install

You can install ir from GitHub using R via:

``` r
remotes::install_github(repo = "henningte/ir")
```

### How to use

You can load ir in R with:

``` r
library(ir)

# load additional packages needed for this tutorial
library(ggplot2)
library(magrittr)
```

You can load the sample data with:

``` r
ir::ir_sample_data
#> # A tibble: 58 x 7
#>    measurement_id sample_id sample_type sample_comment klason_lignin
#>  *          <int> <chr>     <chr>       <chr>          <units>      
#>  1              1 GN 11-389 needles     Abies Firma M~ 0.359944     
#>  2              2 GN 11-400 needles     Cupressocypar~ 0.339405     
#>  3              3 GN 11-407 needles     Juniperus chi~ 0.267552     
#>  4              4 GN 11-411 needles     Metasequoia g~ 0.350016     
#>  5              5 GN 11-416 needles     Pinus strobus~ 0.331100     
#>  6              6 GN 11-419 needles     Pseudolarix a~ 0.279360     
#>  7              7 GN 11-422 needles     Sequoia sempe~ 0.329672     
#>  8              8 GN 11-423 needles     Taxodium dist~ 0.356950     
#>  9              9 GN 11-428 needles     Thuja occiden~ 0.369360     
#> 10             10 GN 11-434 needles     Tsuga carolin~ 0.289050     
#> # ... with 48 more rows, and 2 more variables: holocellulose <units>,
#> #   spectra <list>
```

`ir_sample_data` is an object of class `ir`. An Object of class `ir` is
basically a `data.frame` where each row represents one infrared
measurement and column `spectra` contains the infrared spectra (one per
row) and columns `measurement_id` and `sample_id` represent identifiers
for each measurement and sample, respectively. This allows effectively
storing repeated measurements for the same sample in the same table, as
well as any metadata and accessory data (e.g. nitrogen content of the
sample).

The column `spectra` is a list column of `data.frame`s, meaning that
each cell in `sample_data` contains for column `spectra` a `data.frame`.
For example, the first element of `ir_sample_data$spectra` represents
the first spectrum as a `data.frame`:

``` r
ir::ir_get_spectrum(ir_sample_data, what = 1)[[1]] %>% 
  head(10)
#> # A tibble: 10 x 2
#>        x        y
#>    <int>    <dbl>
#>  1  4000 0.000361
#>  2  3999 0.000431
#>  3  3998 0.000501
#>  4  3997 0.000571
#>  5  3996 0.000667
#>  6  3995 0.000704
#>  7  3994 0.000612
#>  8  3993 0.000525
#>  9  3992 0.000502
#> 10  3991 0.000565
```

Column `x` represents the x values (in this case wavenumbers
\[cm<sup>-1</sup>\]) and column `y` the corresponding intensity values.

A simple workflow would be, for example, to baseline correct the
spectra, then bin them to bins with a width of 10 wavenumber units, then
normalize them so that the maximum intensity value is 1 and the minimum
intensity value is 0 and then plot the baseline corrected spectra for
each sample and sample type:

``` r
ir_sample_data %>%                                      # data
  ir::ir_bc(method = "rubberband") %>%                  # baseline correction
  ir::ir_bin(width = 10) %>%                            # binning
  ir::ir_normalise(method = "zeroone") %>%              # normalisation
  plot() + ggplot2::facet_wrap(~ sample_type)           # plot
```

![](README-sample_data_workflow-1.png)<!-- -->

### How to cite

Please cite this R package as:

> Henning Teickner (2020). *ir: A Simple Package to Handle and
> Preprocess Infrared Spectra’*. Accessed 11 Jul 2020. Online at
> <https://github.com/henningte/ir>.

### Licenses

**Text and figures :** [CC
BY 4.0](http://creativecommons.org/licenses/by/4.0/)

**Code :** See the [DESCRIPTION](DESCRIPTION) file

**Data :** [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/)
attribution requested in reuse. See the sources section for data sources
and how to give credit to the original author(s) and the source.

### Contributions

We welcome contributions from everyone. Before you get started, please
see our [contributor guidelines](CONTRIBUTING.md). Please note that this
project is released with a [Contributor Code of Conduct](CONDUCT.md). By
participating in this project you agree to abide by its terms.

### Sources

The complete data in this package is derived from Hodgkins et al. (2018)
and was restructured to match the requirements of ir. The original
article containing the data can be downloaded from
<https://www.nature.com/articles/s41467-018-06050-2> and is distributed
under the Creative Commons Attribution 4.0 International License
(<http://creativecommons.org/licenses/by/4.0/>). The data on Klason
lignin and holocellulose content was originally derived from De La Cruz,
Florentino B., Osborne, and Barlaz (2016).

This packages was developed in R (R version 4.0.1 (2020-06-06)) (R Core
Team 2019) using functions from devtools (Wickham, Hester, and Chang
2019), usethis (Wickham and Bryan 2019), rrtools (Marwick 2019) and
roxygen2 (Wickham et al. 2019).

### References

<div id="refs" class="references hanging-indent">

<div id="ref-LaCruz.2016">

De La Cruz, Florentino B., Jason Osborne, and Morton A. Barlaz. 2016.
“Determination of Sources of Organic Matter in Solid Waste by Analysis
of Phenolic Copper Oxide Oxidation Products of Lignin.” *Journal of
Environmental Engineering* 142 (2): 04015076.
<https://doi.org/10.1061/(ASCE)EE.1943-7870.0001038>.

</div>

<div id="ref-Hodgkins.2018">

Hodgkins, Suzanne B., Curtis J. Richardson, René Dommain, Hongjun Wang,
Paul H. Glaser, Brittany Verbeke, B. Rose Winkler, et al. 2018.
“Tropical peatland carbon storage linked to global latitudinal trends
in peat recalcitrance.” *Nature communications* 9 (1): 3640.
<https://doi.org/10.1038/s41467-018-06050-2>.

</div>

<div id="ref-Marwick.2019">

Marwick, Ben. 2019. “rrtools: Creates a Reproducible Research
Compendium.” <https://github.com/benmarwick/rrtools>.

</div>

<div id="ref-RCoreTeam.2019">

R Core Team. 2019. “R: A Language and Environment for Statistical
Computing.” Vienna, Austria: R Foundation for Statistical Computing.
<https://www.R-project.org/>.

</div>

<div id="ref-Wickham.2019b">

Wickham, Hadley, and Jennifer Bryan. 2019. “usethis: Automate Package
and Project Setup.” <https://CRAN.R-project.org/package=usethis>.

</div>

<div id="ref-Wickham.2019c">

Wickham, Hadley, Peter Danenberg, Gábor Csárdi, and Manuel Eugster.
2019. “roxygen2: In-Line Documentation for R.”
<https://CRAN.R-project.org/package=roxygen2>.

</div>

<div id="ref-Wickham.2019">

Wickham, Hadley, Jim Hester, and Winston Chang. 2019. “devtools: Tools
to Make Developing R Packages Easier.”
<https://CRAN.R-project.org/package=devtools>.

</div>

</div>
