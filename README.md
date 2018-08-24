<!-- README.md is generated from README.Rmd. Please edit that file -->
hyetor
======

[![AppVeyor build status](https://ci.appveyor.com/api/projects/status/github/kvantas/hyetor?branch=master&svg=true)](https://ci.appveyor.com/project/kvantas/hyetor) [![Travis build status](https://travis-ci.org/kvantas/hyetor.svg?branch=master)](https://travis-ci.org/kvantas/hyetor) [![Coverage status](https://codecov.io/gh/kvantas/hyetor/branch/master/graph/badge.svg)](https://codecov.io/github/kvantas/hyetor?branch=master) [![lifecycle](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)

`hyetor` is an R package that provides a collection of tools that analyze fixed interval precipitation records. It can be used to:

1.  Aggregate precipitation values.
2.  Split precipitation time series to independent rainstorms using the maximum dry period duration of no precipitation.
3.  Compile Unitless Cumulative Hyetographs.
4.  Find maximum rainfall intensities.
5.  Calculate rainfall erosivity values
6.  Creates missing values summaries.

For more details checkout the package's [website](https://kvantas.github.io/hyetor/) and the vignettes:

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

The data sets that are provided by `hyetor` are:

Example
-------

This is a minimal example which shows how to ...

Meta
----

-   Bug reports, suggestions, and code are welcome. Please see [Contributing](/CONTRIBUTING.md).
-   Licence:
    -   All code is licensed MIT.
    -   All data are from the public data sources in <http://www.hydroscope.gr/>.
-   To cite `hyetor` please use:
