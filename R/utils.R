#' Return error if not positive integer
#'
#' @noRd
count_check <- function(x, x_name) {
  if (!assertthat::is.count(x)) {
    stop(paste(x_name, "must be a positive integer"), call. = FALSE)
  }
}

#' Return error if x not a vector of values
#'
#' @noRd
vector_check <- function(time_step) {
  if (!(time_step %in% c(5, 10, 15, 30))) {
    stop(
      "`time_step` must have one of the values 1, 5, 10, 15 or 30 minutes.",
      call. = FALSE
    )
  }
}

#' return error if units are valid
#'
#' @noRd
units_check <- function(x, minhour = TRUE) {
  if (minhour) {
    if (!(x %in% c("mins", "hours"))) {
      stop(paste("units must be either `mins` or `hours`"), call. = FALSE)
    }
  } else {
    if (!(x %in% c("mins", "hours", "days", "months", "quarter", "year"))) {
      stop(paste(
        "units must be on of `mins`, `hours`, `days`, `months`,",
        "`quarter` or `year`"
      ), call. = FALSE)
    }
  }
}

#' return error if crit_dur is not a numeric vector of 12 values
#' @noRd
crit_dur_check <- function(x) {
  if (!is.numeric(x) | (length(x) != 12) | any(x < 0)) {
    stop(paste("crit_dur must be a numeric vector of 12 values"),
      call. = FALSE
    )
  }
}

#' return error if not valid energyy equation
#'
#' @noRd
en_eq_check <- function(x) {
  valid_equat <- c("brown_foster", "mcgregor_mutch", "wisch_smith")
  error_msg <- paste(
    "`en_equation` must be on of:",
    "`brown_foster`, `mcgregor_mutch`, `wisch_smith`"
  )
  if (!(x %in% valid_equat)) {
    stop(error_msg, call. = FALSE)
  }
}

#' Check for a valid hyetograph
#' @noRd
hyet_check <- function(hyet) {
  # check for expected names and values
  suppressWarnings(
    if (!(tibble::is.tibble(hyet) & (all(c("date", "prec") %in% names(hyet))) &
      lubridate::is.POSIXct(hyet$date) & is.numeric(hyet$prec))) {
      error_msg <- paste(
        "Error: `hyet` is not a valid hyetograph. Please use",
        "function `hyet_create`."
      )
      stop(error_msg, call. = FALSE)
    }
  )
}

#' Fill hyetographs
#'
#' @noRd
util_fill <- function(hyet, time_step, ts_unit) {

  # create an empty time series
  empty_ts <- tibble::tibble(date = seq(
    from = min(hyet$date, na.rm = TRUE),
    to = max(hyet$date, na.rm = TRUE),
    by = paste(time_step, ts_unit)
  ))

  # merge time series
  dplyr::left_join(empty_ts, hyet, by = "date")
}

#' Utility function for hyetograph aggregation
#' @noRd
util_aggr <- function(hyet, time_step, ts_unit = "mins") {

  # create aggregated date
  hyet$date <- lubridate::ceiling_date(
    hyet$date,
    paste(time_step, ts_unit)
  )

  # group by date
  hyet <- dplyr::group_by(hyet, .data$date)

  # summarise values
  dplyr::summarise(hyet, prec = sum(.data$prec, na.rm = TRUE))
}

#' Utility function for hyetographs rolling sum
#'
#' @noRd
util_roll_sum <- function(hyet, win_size) {
  hyet$prec <- RcppRoll::roll_sum(hyet$prec,
    n = win_size, fill = 0,
    align = "left", na.rm = TRUE
  )
  hyet
}


#' Calculate intensities using an hyetograph
#'
#' @noRd
rain_intensities <- function(hyet, time_step, ts_unit) {
  from_dur <- paste(time_step, ts_unit)
  ts_dur <- lubridate::duration(time_step, ts_unit)

  tibble::tibble(
    int_5min = max_roll_sum(hyet, from_dur, "5 mins") * 12,
    int_10min = max_roll_sum(hyet, from_dur, "10 mins") * 6,
    int_15min = max_roll_sum(hyet, from_dur, "15 mins") * 4,
    int_30min = max_roll_sum(hyet, from_dur, "30 mins") * 2,
    int_1hr = max_roll_sum(hyet, from_dur, "1 hours"),
    int_3hr = max_roll_sum(hyet, from_dur, "3 hours") / 3,
    int_6hr = max_roll_sum(hyet, from_dur, "6 hours") / 6,
    int_12hr = max_roll_sum(hyet, from_dur, "12 hours") / 12,
    int_24hr = max_roll_sum(hyet, from_dur, "1 days") / 24,
    int_48hr = max_roll_sum(hyet, from_dur, "2 days") / 48
  )
}

#' Find maximum rolling window sum
#'
#' @noRd
max_roll_sum <- function(hyet, from_dur, to_dur) {

  # compute rolling window
  win <- lubridate::as.duration(to_dur) / lubridate::as.duration(from_dur)
  res <- NA

  # if window < 1 return NA
  if (win < 1) {
    return(res)
  }

  # do not calculate rolling sum if window = 1
  if (win == 1) {
    res <- (max(hyet$prec))
  }
  else if (assertthat::is.count(win)) {
    tmp <- util_roll_sum(hyet, win)
    res <- suppressWarnings(max(tmp$prec, na.rm = TRUE))
  }

  ifelse(is.infinite(res), NA, res)
}
