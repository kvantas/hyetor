#' Compute interarrival and dry times duration from independent rainstorms
#'
#' @description \code{hyet_interar} uses independent rainstorms that comes
#' from the \code{hyet_split} function and computes their interarrival and
#' dry time duration.
#' Returns an error if \code{storms} is not a valid grouped hyetograph.
#'
#' @param storms a grouped dataframe with independent rainstorms.
#'
#' @return  a tibble with the duration, total precipitation height
#' and interarrival and dry times in hours of the independent rainstorms.
#' @export hyet_arrive
#'
#' @note Please note that the interarrival and dry time durations for the first
#' rainstorms is set to zero.
#'
#' @examples
#' # create time series with 1 hours time step
#' time_step <- 1
#' ts_unit <- "hours"
#' len <- 30
#' crit_dur <- rep(6, 12)
#'
#' hyet <- tibble::tibble(
#'   date = seq(
#'     from = as.POSIXct(0, origin = "2018-01-01"), length.out = len,
#'     by = paste(time_step, ts_unit)
#'   ),
#'   prec = runif(len, 1, 5)
#' )
#'
#' # create 2 dry durations of 6 hours
#' hyet$prec[10:15] <- 0
#' hyet$prec[21:26] <- 0
#'
#' # add some zeros
#' hyet$prec[2:5] <- 0
#'
#' # split hyet and compute interarrival times
#' hyet %>%
#'   hyet_split(time_step, ts_unit, crit_dur) %>%
#'   hyet_arrive()

hyet_arrive <- function(storms) {

  # check values
  hyet_check(storms)

  # check for grouped_df
  if ("grouped_df" %in% class(storms)) {
    interarrival(storms)
  } else {
    stop(paste(" Please use `hyet_split` function to create storms"),
      call. = FALSE
    )
  }
}
