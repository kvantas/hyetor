
#' Compute UCH
#'
#' @noRd
uch <- function(hyet, time_step, ts_unit, nvalues, .simple = FALSE) {

  # compute duration and total precipitation height
  ts_dur <- lubridate::duration(paste(time_step, ts_unit), units = "mins")
  start_date <- hyet$date[1]
  end_date <- tail(hyet$date, 1)
  duration <- difftime(end_date, start_date - ts_dur,
    units = "mins"
  )

  prec_height <- sum(hyet$prec, na.rm = TRUE)

  # if prec doesn't start with zero add  that value
  if (hyet$prec[1] != 0) {
    hyet <- tibble::add_row(hyet,
      "prec" = 0, "date" = hyet$date[1] - ts_dur,
      .before = 1
    )
  }

  # create unitless hyetograph
  hyet <- dplyr::mutate(hyet,
    date_diff = c(0, diff(.data$date, units = "mins")),
    unit_time = as.numeric(cumsum(.data$date_diff)) /
      as.numeric(duration),
    unit_prec = cumsum(.data$prec) / prec_height
  )


  # interpolate values using linear method
  approx_hyet <- approx(
    x = hyet$unit_time, y = hyet$unit_prec, yleft = 0, yright = 1,
    method = "linear", n = nvalues
  )

  # find quartile
  quartile <- huff_class(c(0, cumsum(na.omit(hyet$prec))))

  # use .simple to return a tibble with one row
  if (.simple) {
    res <- tibble::as.tibble(t(approx_hyet$y))
    tibble::add_column(res,
      .before = TRUE,
      "start" = start_date,
      "end" = end_date,
      "duration" = as.numeric(duration) / 60,
      "prec_height" = prec_height,
      "mean_int" = prec_height / as.numeric(duration),
      "quartile" = quartile
    )
  } else {
    # create a tibble for aprrox. hyet
    hyet_approx <- tibble::tibble(
      "start" = start_date,
      "end" = end_date,
      "duration" = duration,
      "prec_height" = prec_height,
      "mean_int" = prec_height / as.numeric(duration),
      "quartile" = quartile,
      "unit_time" = approx_hyet$x,
      "unit_prec" = approx_hyet$y)
    # return results
    list(
      "start" = start_date,
      "end" = end_date,
      "duration" = duration,
      "prec_height" = prec_height,
      "mean_int" = prec_height / as.numeric(duration),
      "hyet" = dplyr::select(hyet, -c("date_diff")),
      "hyet_approx" = hyet_approx
    )
  }
}


#' Huff's quartile classification
#'
#' x is an unitless cumulative hyetograph
#'
#' @noRd
huff_class <- function(x) {
  unname(which.max(diff(quantile(x))))
}
