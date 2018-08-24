#' Split an hyetograph to rainstorms using a fixed critical time duration of
#' no precipitation
#'
#' @param hyet hyet an hyetograph from \code{hyet_create} function.
#' @param time_step an integer that represents hyetograph's time-step.
#' @param ts_unit a character string specifying a time unit. Valid units are
#' "mins" and "hours".
#' @param crit_dur an integer or a vector of 12 integers that represent the
#' critical time duration of no precipitation that is used to separate the
#' hyetograph to independent rainstorms.
#'
#' @return a grouped dataframe
#' @export hyet_split
#'
#' @examples
#'
#' # create time series with 1 hours time step
#' time_step <- 30
#' ts_unit <- "mins"
#' len <- 90
#' crit_dur = rep(6,12)
#' hyet <- tibble::tibble(
#'   date = seq(
#'     from = as.POSIXct(0, origin = "2018-01-01"), length.out = len,
#'     by = paste(time_step, ts_unit)
#'   ),
#'   prec = runif(len, 1, 5)
#' )
#
# # create 2 dry durations
#' hyet$prec[10:23] <- 0
#' hyet$prec[41:54] <- 0
#'
#' # split hyet
#' storms <- hyet_split(hyet, time_step, ts_unit, crit_dur)
#'
hyet_split <- function(hyet, time_step = 5, ts_unit = "mins",
                       crit_dur = rep(6, 12)) {

  # check input values ---------------------------------------------------------
  hyet_check(hyet)
  count_check(time_step)
  units_check(ts_unit)
  crit_dur_check(crit_dur)

  # remove zero precipitation records
  hyet <- dplyr::filter(hyet, .data$prec > 0)

  # add month
  hyet <- dplyr::mutate(hyet, month = lubridate::month(.data$date))

  # use crit_dur per month to define storms
  crit_dur_df <- tibble::tibble(
    month = 1:12,
    crit_dur = as.difftime(crit_dur, units = "hours")
  )

  hyet <- dplyr::left_join(hyet, crit_dur_df, by = "month")

  # use `crit_dur` to extract rain-storms
  hyet <- dplyr::mutate(
    hyet,
    dif = c(
      as.difftime(time_step, units = ts_unit),
      diff(.data$date, units = ts_unit)
    ),
    new_storm = c(TRUE, utils::tail(.data$dif >= .data$crit_dur, -1)),
    storm = cumsum(.data$new_storm)
  )

  # group storms
  hyet <- dplyr::group_by(hyet, .data$storm)

  # add missing values as 0s in storms
  hyet <- dplyr::do(hyet, util_fill(.data, time_step, ts_unit))

  # ungroup hyet
  hyet <- dplyr::ungroup(hyet)

  # extract filled storms
  hyet$new_storm <- dplyr::if_else(is.na(hyet$new_storm), FALSE, hyet$new_storm)
  hyet$prec <- dplyr::if_else(is.na(hyet$prec), 0, hyet$prec)
  hyet <- dplyr::mutate(hyet, storm = cumsum(.data$new_storm))
  hyet <- dplyr::group_by(hyet, .data$storm)

  # remove auxiliary variables
  dplyr::select(hyet, c("date", "prec", "storm"))
}
