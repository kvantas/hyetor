#' @title Aggregate an hyetograph using a predefined time-step
#'
#' @description \code{hyet_aggregate} uses a predefined time-step to
#' aggregate precipitation records in an hyetograph. Returns an error if
#' \code{hyet} is not a valid hyetograph.
#'
#' @param hyet an hyetograph from \code{hyet_create} function.
#' @param time_step a numeric value that represents the time-step.
#' @param ts_unit a character string specifying the time unit. Valid values
#' are "mins", "hours", "days", "months", "quarter" or "year".
#'
#' @return a tibble with the aggregated hyetograph.
#' @export hyet_aggregate
#'
#' @examples
#'
#' prec30min <- prec5min %>%
#'  hyet_aggregate(30, "mins")
#'
hyet_aggregate <- function(hyet, time_step, ts_unit) {

  # check values
  hyet_check(hyet)
  count_check(time_step)
  units_check(ts_unit, minhour = FALSE)

  # call utility function
  util_aggr(hyet, time_step, ts_unit)
}
