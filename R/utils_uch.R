
#' Compute UCH
#'
#' @noRd
uch <- function(hyet, time_step, ts_unit, nvalues, .simple = FALSE) {

  # compute duration and total precipitation height
  ts_dur <- lubridate::duration(paste(time_step, ts_unit), units = "mins")
  duration <- difftime(tail(hyet$date, 1), hyet$date[1] - ts_dur,
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

  # use .simple to return a tibble with one row
  if (.simple) {
    tibble::as.tibble(t(approx_hyet$y))
  } else {
    # create a tibble for aprrox. hyet
    hyet_approx <- tibble::tibble(
      "unit_time" = approx_hyet$x,
      "unit_prec" = approx_hyet$y
    )
    # return results
    list(
      "duration" = duration,
      "prec_height" = prec_height,
      "hyet" = dplyr::select(hyet, -c("date_diff")),
      "hyet_approx" = hyet_approx
    )
  }
}


#' Huff's quartile classification
#'
#' x is an unitless cumulative hyetograph
huff_class <- function(x) {
  unname(which.max(diff(quantile(x))))
}
