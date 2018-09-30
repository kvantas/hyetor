#' Calculate rainfall energy
#'
#' @noRd
rain_energy <- function(intensity, en_equation = "brown_foster") {
  if (is.null(intensity)) return(NA)

  if (en_equation == "brown_foster") {
    0.29 * (1 - 0.72 * exp(-0.082 * intensity))
  } else if (en_equation == "wisch_smith") {
    if (intensity > 76) {
      0.283
    } else {
      0.119 + 0.0873 * log10(intensity)
    }
  } else if (en_equation == "mcgregor_mutch") {
    0.273 + 0.2168 * exp(-0.048 * intensity) - 0.4126 * exp(-0.072 * intensity)
  }
}



#' Compute erosivity
#'
#' @noRd
erosivity <- function(hyet, time_step, en_equation) {

  # calc number of steps
  step_per60 <- 60 / time_step
  step_per30 <- 30 / time_step
  step_per15 <- 15 / time_step

  # compute time step duration and total duration
  ts_dur <- lubridate::duration(paste(time_step, "mins"))
  total_duration <- difftime(tail(hyet$date, 1), hyet$date[1] - ts_dur,
    units = "mins"
  )

  # compute 30 min and 15 min rolling precipitations
  if (time_step == 5) {
    hyet$prec15 <- util_roll_sum(hyet, 3)$prec
    hyet$prec30 <- util_roll_sum(hyet, 6)$prec
  } else if (time_step == 10) {
    hyet$prec15 <- 0
    hyet$prec30 <- util_roll_sum(hyet, 3)$prec
  } else if (time_step == 15) {
    hyet$prec15 <- 0
    hyet$prec30 <- util_roll_sum(hyet, 2)$prec
  } else if (time_step == 30) {
    hyet$prec15 <- 0
    hyet$prec30 <- hyet$prec
  }


  # break storms if six-hour-cumulative precipitation is < 1.27 mm -------------
  if (as.numeric(total_duration) > 360) {

    # calculate 6 hours sums
    hyet <- dplyr::mutate(
      hyet,
      six_hour_l = RcppRoll::roll_sum(.data$prec,
        n = step_per60 * 6, fill = Inf,
        align = "left", na.rm = TRUE
      ),
      six_hour_r = RcppRoll::roll_sum(.data$prec,
        n = step_per60 * 6, fill = Inf,
        align = "right", na.rm = TRUE
      )
    )

    # calculate breaks using the 1,27 mm rule
    hyet <- dplyr::mutate(
      hyet,
      break_storms = .data$six_hour_r < 1.27 | .data$six_hour_l < 1.27
    )
    hyet$break_storms[1] <- TRUE

    # find breaks
    hyet <- dplyr::mutate(hyet, extract_storm = cumsum(.data$break_storms))
  } else {
    # there is only one storm
    hyet$extract_storm <- 1
  }

  # remove zero prec values to minimize extracted storms
  hyet <- dplyr::filter(hyet, .data$prec > 0)

  # compute energy using intensities
  hyet <- dplyr::mutate(
    hyet,
    energy = rain_energy(.data$prec * step_per60, en_equation)
  )

  # group by extracted storms and compute EI values ----------------------------

  # group using extracted storms
  hyet <- dplyr::group_by(hyet, .data$extract_storm)

  # compute EI and max intensities
  EI <- dplyr::summarise(
    hyet,
    begin = .data$date[1],
    end = tail(.data$date, 1),
    duration = difftime(.data$end, (.data$begin - ts_dur), units = "mins"),
    cum_prec = sum(.data$prec),
    max_i15 = max(.data$prec15) * 4,
    max_i30 = max(.data$prec30) * 2,
    total_energy = sum(.data$energy * .data$prec, na.rm = TRUE),
    erosivity = total_energy * .data$max_i30,
    eros_density = .data$erosivity / .data$cum_prec
  )
  # remove extract_storm
  EI$extract_storm <- NULL

  # remove events with cum_prec < 1.27 mm or duration less than 30 minutes
  dplyr::filter(EI, .data$cum_prec > 1.27 & .data$duration >= 30)
}
