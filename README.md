<!-- README.md is generated from README.Rmd. Please edit that file -->
hyetor
======

[![AppVeyor build
status](https://ci.appveyor.com/api/projects/status/github/kvantas/hyetor?branch=master&svg=true)](https://ci.appveyor.com/project/kvantas/hyetor)
[![Travis build
status](https://travis-ci.org/kvantas/hyetor.svg?branch=master)](https://travis-ci.org/kvantas/hyetor)
[![Coverage
status](https://codecov.io/gh/kvantas/hyetor/branch/master/graph/badge.svg)](https://codecov.io/github/kvantas/hyetor?branch=master)
[![DOI](https://zenodo.org/badge/145962234.svg)](https://zenodo.org/badge/latestdoi/145962234)
[![lifecycle](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)

`hyetor` is an R package that provides a collection of tools that
analyze fixed interval precipitation records. It can be used to:

1.  Aggregate precipitation values.
2.  Split precipitation time series to independent rainstorms using the
    maximum dry period duration of no precipitation.
3.  Compile Unitless Cumulative Hyetographs.
4.  Find maximum rainfall intensities.
5.  Categorize rainstorms using Huff’s quartile classification.
6.  Calculate rainfall erosivity values
7.  Create missing values summaries.

For more details checkout the package’s
[website](https://kvantas.github.io/hyetor/) and the vignettes:

Installation
------------

You can install the development version from Github with:

``` r
# install.packages("devtools")
devtools::install_github("kvantas/hyetor")
```

Using hyetor
------------

The functions that are provided by `hyetor` are:

-   Functions that can be used to preprocess precipitation time-series:
    `hyet_create`, `hyet_fill`, `hyet_aggregate` and `hyet_split`.
-   Functions that analyze precipitation time-series: `hyet_erosivity`,
    `hyet_intensities`, `hyet_missing` and `hyet_uch`.

The data sets that are provided by `hyetor` are:

-   `prec5min`, This time series comes from the weather station ‘Arna’
    in Greece. The owner of that weather station is the Ministry of
    Environment and Energy. The time series period is from 12/1954 to
    05/1956 and the time-step is 5 minutes.

Example
-------

This is a minimal example which shows how to use the package’s functions
to analyze the internal data set and compute erosivity values.

Load libraries and view data:

``` r
library(hyetor)
library(tibble)
library(dplyr)
library(lubridate)

prec5min
#> # A tibble: 48,209 x 2
#>    date                 prec
#>    <dttm>              <dbl>
#>  1 1954-12-14 07:40:00     0
#>  2 1954-12-14 07:45:00     0
#>  3 1954-12-14 07:50:00     0
#>  4 1954-12-14 07:55:00     0
#>  5 1954-12-14 08:00:00     0
#>  6 1954-12-14 08:05:00     0
#>  7 1954-12-14 08:10:00     0
#>  8 1954-12-14 08:15:00     0
#>  9 1954-12-14 08:20:00     0
#> 10 1954-12-14 08:25:00     0
#> # ... with 48,199 more rows
```

Compute the missing values ratio per year:

``` r
prec5min %>%
  hyet_fill(time_step = 5, ts_unit = "mins") %>%
  hyet_missing() %>%
  group_by(year) %>%
  summarise(na_ratio = mean(na_ratio))
#> # A tibble: 3 x 2
#>    year na_ratio
#>   <dbl>    <dbl>
#> 1  1954    0.493
#> 2  1955    0.723
#> 3  1956    0.619
```

Split to independent rainstorms and calculate erosivity values with
cumulative precipitation greater than 12,7 mm:

``` r
prec5min %>%
  hyet_split(time_step = 5, ts_unit = "mins") %>%
  hyet_erosivity(time_step = 5) %>%
  ungroup() %>%
  filter(cum_prec > 12.7) %>%
  select(begin, duration, cum_prec, erosivity)
#> # A tibble: 29 x 4
#>    begin               duration    cum_prec erosivity
#>    <dttm>              <time>         <dbl>     <dbl>
#>  1 1955-03-03 10:05:00 " 780 mins"     13.0      7.33
#>  2 1955-04-14 14:15:00 " 620 mins"     38.7    130.  
#>  3 1955-04-15 11:15:00 1235 mins       24.7     30.4 
#>  4 1955-05-11 13:30:00 " 375 mins"     28.2    123.  
#>  5 1955-07-15 14:50:00 " 125 mins"     19.4    162.  
#>  6 1955-08-30 14:30:00 " 150 mins"     23.8    115.  
#>  7 1955-09-02 12:05:00 " 360 mins"     25.2    124.  
#>  8 1955-09-04 13:10:00 " 170 mins"     20.4     52.5 
#>  9 1955-09-28 18:05:00 " 100 mins"     35.6    366.  
#> 10 1955-10-01 01:50:00 1115 mins       29.6     47.4 
#> # ... with 19 more rows
```

Meta
----

-   Bug reports, suggestions, and code are welcome. Please see
    [Contributing](/CONTRIBUTING.md).
-   Licence:
    -   All code is licensed MIT.
    -   All data are from the public data sources in
        <http://www.hydroscope.gr/>.
-   To cite `hyetor` please use:

<!-- -->

      Vantas, (2018). hyetor: R package to analyze fixed interval precipitation time series, URL: https://kvantas.github.io/hyetor/,
      DOI:http://doi.org/10.5281/zenodo.1403156

A BibTeX entry for LaTeX users is

    @Manual{ vantas2018hyetor,
        author = {Konstantinos Vantas},
        title = {{hyetor}: R package  to analyze fixed interval precipitation time series},
        doi = {http://doi.org/10.5281/zenodo.1403156},
        year = {2018},
        note = {R package},
        url = {https://kvantas.github.io/hyetor/},
      }
