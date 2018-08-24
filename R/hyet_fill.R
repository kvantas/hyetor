#' @title Fill an hyetograph with missing date values
#'
#' @description  \code{hyet_fill} fills missing date values in an hyetograph
#' with NA values. This function can be used when missing values in time series
#' are marked implicitly using missing dates. Returns an error if \code{hyet} is
#' not a valid hyetograph.
#'
#' @param hyet an hyetograph from \code{hyet_create} function.
#' @param time_step a numeric value that represents the time-step.
#' @param ts_unit a character string specifying the time unit. Valid values
#' are "mins", "hours", "days", "months", "quarter" or "year".
#'
#' @return a tibble with the variables \code{date} and \code{prec} of the filled
#' hyetograph.
#' @export hyet_fill
#'
#' @examples
#'
#' # create date and precipitation values using 5 minutes time-step
#' prec_date <- seq(from = as.POSIXct(0, origin = "2018-01-01"),
#'                   length.out =  100,
#'                   by = "5 mins")
#' set.seed(1)
#' prec_values <-round(runif(100,0,10),1)
#'
#' # create hyetograph
#' hyet <- hyet_create(prec_date, prec_values)
#'
#' # remove some random values from the hyetograph
#' hyet_miss <- hyet[-sample(100,30), ]
#'
#' # fill hyetograph
#' hyet_fill <- hyet_miss %>%
#'   hyet_fill(5, "mins")

hyet_fill <- function(hyet, time_step = 5, ts_unit = "mins") {

  # check parameters
  hyet_check(hyet)
  count_check(time_step)
  units_check(ts_unit, minhour = FALSE)

  # fill
  util_fill(hyet, time_step, ts_unit)
}
