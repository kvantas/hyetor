#' hyetor: Analyzes fixed interval precipitation records.
#'
#' This package provides a collection of tools that can be used to analyze fixed
#'  interval precipitation time series:
#'  \itemize{
#'    \item {Aggregate precipitation time series values.}
#'    \item {Split precipitation records to independent rainstorms.}
#'    \item {Compile Unitless Cumulative Hyetographs.}
#'    \item {Find maximum rainfall intensities for various time steps.}
#'    \item {Calculate rainfall erosivity values.}
#'    \item {Create missing values summaries.}
#'    }
#'
#' @section Data Sources:
#'
#' The data are retrieved from:
#'  \url{http://www.hydroscope.gr/}
#'
#' @name hyetor
#' @aliases hyetor-package
#' @docType package
#'
#' @importFrom rlang .data
#' @importFrom magrittr %>%
#' @importFrom stats approx na.omit quantile
#' @importFrom utils tail head
#'
#'
"_PACKAGE"
