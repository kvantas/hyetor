#' @title Create an hyetograph
#'
#' @description  \code{hyet_create} uses precipitation and date values to
#' create a tibble that represents the distribution of rainfall over time.
#' Returns an error if:
#' \itemize{
#'  \item \code{prec} and \code{date} values don't have the same length.
#'  \item \code{prec} is not a numeric vector.
#'  \item \code{date} is not a POSIXct (times) vector.
#' }
#'
#' @details  This function checks the validity of precipitation and date values
#' and returns an error if:
#' \itemize{
#'   \item{These vectors don't have the same length,}
#'   \item{precipitation is not numeric or}
#'   \item{date  is not POSIXct.}
#' }
#'
#' @param date a numeric vector of precipitation values
#' @param prec a POSIXct vector with date values
#'
#' @return a tibble with the variables \code{date} and \code{prec}
#' @export hyet_create
#'
#' @examples
#'
#' # create date and precipitation values
#' date <- seq(from = as.POSIXct(0, origin = "2018-01-01"),
#'                   length.out =  100,
#'                   by = "mins")
#' set.seed(1)
#' prec <-round(runif(100,0,10),1)
#'
#' # create hyetograph
#' hyet <- hyet_create(date, prec)
#'
hyet_create <- function(date, prec) {
  if (!is.null(date)) {
    if (length(prec) != length(date)) {
      stop(
        "Error: `prec` and  `date` lenghts must be equal.",
        call. = FALSE
      )
    }
    if (!lubridate::is.POSIXct(date)) {
      stop("Error: `prec` must be a POSIXct vector.", call. = FALSE)
    }
  }
  if (!is.numeric(prec)) {
    stop("Error: `prec` must be a numeric vector.", call. = FALSE)
  }

  tibble::tibble(date = date, prec = prec)
}
