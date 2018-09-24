#' Compute maximum rolling intensities from an hyetograph
#'
#' @description \code{hyet_intensities} uses an hyetograph, single or grouped
#' (i.e. from \code{hyet_split}) and computes characteristic maximum rolling
#' precipitation intensities. Returns an error if \code{hyet} is not a valid
#' hyetograph.
#'
#' @param hyet an hyetograph from \code{hyet_create} function.
#' @param time_step a numeric value that represents the time-step.
#' @param ts_unit a character string specifying the time unit. Valid values
#' are "mins" and "hours".
#'
#' @return a tibble with the maximum rolling rainfall intensities for 5, 10, 15,
#'  30 minutes and 1, 2, 3, 6, 12, 24 and 48 hours
#'
#' @note missing date values must be set explicit using the \code{hyet_fill}
#' function if a single hyetograph is used. \code{hyet_split} returns filled
#' storms.
#'
#' @export hyet_intensities
#'
#' @examples
#'
#' # set values
#' time_step <- 1
#' ts_unit <- "hours"
#' len <- 18
#'
#' # create an hyetograph
#' hyet <- tibble::tibble(
#' date = seq(
#' from = as.POSIXct(0, origin = "2018-01-01"), length.out = len,
#'     by = paste(time_step, ts_unit)
#'   ),
#'   prec = seq(1, 18, 1)
#' )
#'
#' # add a dry period
#' hyet$prec[5:10] <- 0
#'
#' # split to storms and calculate intensities per storm
#' intens <- hyet %>%
#'   hyet_split(time_step, ts_unit) %>%
#'   hyet_intensities(time_step, ts_unit)

hyet_intensities <- function(hyet, time_step, ts_unit) {

  # check values
  hyet_check(hyet)
  count_check(time_step)
  units_check(ts_unit, minhour = TRUE)

  # check for grouped_df
  if ("grouped_df" %in% class(hyet)) {
    dplyr::do(hyet, rain_intensities(.data, time_step, ts_unit))
  } else {
    rain_intensities(hyet, time_step, ts_unit)
  }
}
