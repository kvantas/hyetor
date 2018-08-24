#' @title Aggregate a hyetograph using a time step
#'
#' @description \code{hyet_aggregate} uses a predefined time step value to
#' aggregate precipitation records in an hyetograph.
#'
#' @param hyet a hyetograph from \code{hyet_create} function.
#' @param time_step an integer specifying the time step value of the aggregated
#' hyetograph.
#' @param ts_unit a character string specifying the time unit of the aggregated
#' hyetograph. Valid units are "mins", "hours", "days", "months", "quarter" or
#' "year".
#'
#' @return a tibble with the aggregated hyetograph.
#' @export hyet_aggregate
#'
#' @examples
#'
#' prec30min <- hyet_aggregate(prec5min, 30, "mins")
#'
hyet_aggregate <- function(hyet, time_step, ts_unit) {

  # check values
  hyet_check(hyet)
  count_check(time_step)
  units_check(ts_unit, minhour = FALSE)

  # call utility function
  util_aggr(hyet, time_step, ts_unit)
}
