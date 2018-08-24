#' @title Fill a hyetograph with missing date values
#'
#' @description  \code{hyet_fill} fills missing date values in a hyetograph
#' with NA values.  Returns an error if \code{hyet} is not a valid hyetograph or
#' \code{time_step} is a not a numeric value.
#'
#' @param hyet a hyetograph from \code{hyet_create} function
#' @param time_step an integer that represents hyetograph's time-step.
#' @param ts_unit a character string specifying a time unit. Valid units are
#' "mins" and "hours".
#'
#' @return a tibble with the variables \code{date} and \code{prec}
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
#' # remove some random values from hyetograph
#' hyet_miss <- hyet[-sample(100,30), ]
#'
#' # fill hyetograph
#' hyet_fill(hyet_miss, 5, "mins")

hyet_fill <- function(hyet, time_step = 5, ts_unit = "mins") {

  # check parameters
  hyet_check(hyet)
  count_check(time_step)
  units_check(ts_unit)

  # fill
  util_fill(hyet, time_step, ts_unit)
}
