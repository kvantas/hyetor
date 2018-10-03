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
    duration = as.numeric(difftime(.data$end, .data$begin, units = "hours")),
    cum_prec = sum(.data$prec, na.rm = TRUE)
  )

  # ungroup values
  storms_stat <- dplyr::ungroup(storms_stat)

  zero <- as.difftime(0, units = "hours")

  # compute interarrival and dry periods
  dplyr::mutate(
    storms_stat,
    inter_period = c(zero, difftime(tail(.data$begin, -1),
      head(.data$begin, -1),
      units = "hours"
    )),
    dry_period = c(zero, difftime(tail(.data$begin, -1),
      head(.data$end, -1),
      units = "hours"
    ))
  )
}
