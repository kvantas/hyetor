#' Create Unitless Cumulative Hyetographs (UCH)
#'
#' @description \code{hyet_uch} uses an hyetograph, single or grouped
#' (i.e. from \code{hyet_split}) and creates the corresponding UCHs. Returns an
#' error if \code{hyet} is not a valid hyetograph.
#'
#' @param hyet an hyetograph from \code{hyet_create} function.
#' @param time_step a numeric value that represents the time-step.
#' @param ts_unit a character string specifying the time unit. Valid values
#' are "mins" and "hours".
#'
#' @return a tibble with start and end time, precipitation height, mean
#' intensity and duration, Huff's quartile classification and
#' the unitless cumulative precipitation for every 1% of unitless time using
#' linear interpolation.
#'
#' @note missing date values must be set explicit using the \code{hyet_fill}
#' function if a single hyetograph is used. \code{hyet_split} returns filled
#' storms.
#'
#' @references
#'
#' Bonta, J. V. (2004). Development and utility of Huff curves for
#' disaggregating precipitation amounts. Applied Engineering in Agriculture,
#' 20(5), 641.
#'
#' Huff, F. A. (1967). Time distribution of rainfall in heavy storms. Water
#' Resources Research, 3(4), 1007-1019.
#' @export hyet_uch
#'
#' @examples
#'
#' # create time series with 30 mins time step
#' time_step <- 30
#' ts_unit <- "mins"
#' len <- 12
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
#' # create uch
#' uch <- hyet %>%
#'   hyet_uch(time_step, ts_unit)
#'
hyet_uch <- function(hyet, time_step, ts_unit) {

  # check values
  hyet_check(hyet)
  count_check(time_step)
  units_check(ts_unit, minhour = TRUE)

  nvalues <- 100

  # check for grouped_df
  if ("grouped_df" %in% class(hyet)) {
    dplyr::do(hyet, uch(.data, time_step, ts_unit, nvalues, TRUE))
  } else {
    uch(hyet, time_step, ts_unit, nvalues, TRUE)
  }
}
