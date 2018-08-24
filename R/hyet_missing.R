#' Compute the missing values ratio of an hyetograph per month and year
#'
#' @description \code{hyet_missing} computes missing values ratio using an
#' hyetograph from the \code{hyet_create} function.
#'
#' @param hyet a hyetograph from \code{hyet_create} function
#'
#' @return a tibble with missing values ratios per month and year
#' @export hyet_missing
#'
#' @note \code{hyet} must not contain missing dates. Please use the
#' \code{hyet_fill} function before \code{hyet_missing}.
#'
#' @examples
#'
#' # compute missing values ratio per month and year
#' miss_vals <- prec5min %>%
#'   hyet_fill(time_step = 5) %>%
#'   hyet_missing()
#'
hyet_missing <- function(hyet) {

  # check
  hyet_check(hyet)

  # add year and month
  hyet <- dplyr::mutate(
    hyet,
    year = lubridate::year(.data$date),
    month = lubridate::month(.data$date)
  )
  # group by dates
  hyet_group <- dplyr::group_by(
    hyet,
    .data$year,
    .data$month
  )
  n_values <- dplyr::tally(hyet_group)

  # compute missing values ratio
  dplyr::summarise(
    hyet_group,
    na_ratio = sum(is.na(.data$prec)) / length(.data$prec)
  )
}
