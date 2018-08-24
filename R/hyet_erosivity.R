#' @title  Compute rainfall erosivity from an hyetograph
#'
#' @description \code{hyet_erosivity}  uses an hyetograph, single or grouped
#' (i.e. from \code{hyet_split}) and computes the rainfall erosivity.
#'
#' @param hyet an hyetograph from \code{hyet_create} function. Precipitation
#' values must be in (mm).
#' @param time_step hyetograph's time-step in minutes. Must have one of the
#' values: \code{[5, 10, 15, 30]}.
#' @param en_equation a character string specifying the equation to be used
#' for calculating kinetic energy of rainfall. Must have one of the values:
#' \code{"brown_foster", "mcgregor_mutch", "wisch_smith"}.
#' Default value is \code{"brown_foster"}.
#'
#' The rainfall's kinetic energy equations are:
#' \itemize{
#' \item{\emph{Brown and Foster (1987)},
#'
#'       \eqn{e = 0.29(1 - 0.72  exp(-0.05i))}}
#' \item{\emph{McGregor and Mutchler (1976)},
#'
#'       \eqn{e = 0.273 + 0.2168exp(-0.048i) - 0.4126exp(-0.072i)}}
#' \item{\emph{Wischmeier and Smith (1958)},
#'
#'       \eqn{e = 0.119 + 0.0873 * log10(i)},
#'
#'       with the upper limit of 0.283  MJ/ha/mm if \eqn{i} > 76 mm/h.}
#' }
#' In the above equations \eqn{i} is rainfall intensity (mm/hr) and \eqn{e} is
#' the kinetic energy per unit of rainfall (MJ/ha/mm).
#'
#' @note \code{hyet} must not contain missing dates. Please use the
#' \code{hyet_fill} function before using \code{hyet_erosivity}.
#'
#' @references
#' Brown, L. C., & Foster, G. R. (1987). Storm erosivity using idealized
#' intensity distributions. Transactions of the ASAE, 30(2), 379-0386.
#'
#' McGregor, K. C., Bingner, R. L., Bowie, A. J., & Foster, G. R. (1995).
#' Erosivity index values for northern Mississippi. Transactions of the ASAE,
#' 38(4), 1039-1047.
#'
#' Wischmeier, W. H., & Smith, D. D. (1958). Rainfall energy and its
#' relationship to soil loss. Eos, Transactions American Geophysical Union,
#' 39(2), 285-291.
#'
#' @return a tibble with erosivity events related values: staring and ending
#' date, cumulative precipitation, maximum rolling intensity values of 15 and
#' 30 minutes and erosivity. If time step if 30 minutes then 15 minutes maximum
#' intensity is zero.
#'
#' @export hyet_erosivity
#'

#'
#' @examples
#'
#' # create time series with 30 mins time step
#' time_step <- 30
#' len <- 12
#' en_equation <- "brown_foster"
#'
#' hyet <- tibble::tibble(
#'   date = seq(
#'     from = as.POSIXct(0, origin = "2018-01-01 00:00:00", tz = "UTC"),
#'     length.out = len,
#'     by = paste(time_step, "mins")
#'   ),
#'   prec = c(1.1, 2.3, 3.2, 1.9, 4.1, 5.9, 2.5, 3.1, 2.9, 1.2, 0.5, 0.2)
#' )
#'
#' # compute erosivity
#'
#' hyet %>%
#' hyet_erosivity(time_step, en_equation)

hyet_erosivity <- function(hyet, time_step, en_equation = "brown_foster") {

  # check values
  hyet_check(hyet)
  en_eq_check(en_equation)
  vector_check(time_step)

  # check for grouped_df
  if ("grouped_df" %in% class(hyet)) {
    dplyr::do(hyet, erosivity(.data, time_step, en_equation))
  } else {
    erosivity(hyet, time_step, en_equation)
  }
}
