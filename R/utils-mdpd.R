#' Compute storms interarrival time given and hyetograph and the  critical
#' duration in minutes
#'
#' @noRd
interarrival <- function(storms) {

  # compute stroms basic stats
  storms_stat <- dplyr::summarise(
    storms,
    begin = min(.data$date),
    end = max(.data$date),
    duration = as.numeric(difftime(.data$end, .data$begin, units = "mins")),
    cum_prec =  sum(.data$prec, na.rm = TRUE))

  # ungroup values
  storms_stat <- dplyr::ungroup(storms_stat)

  # compute interarrival and dry periods
  dplyr::mutate(
    storms_stat,
    inter_period = c(NA, difftime(tail(.data$begin, -1),
                                  head(.data$begin, -1),
                                  units = "mins")),
    dry_period = c(NA, difftime(tail(.data$begin, -1),
                                head(.data$end, -1),
                                units = "mins"))
  )

}
