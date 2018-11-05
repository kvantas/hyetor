#' Five minutes precipitation time series
#'
#' This time series comes from the weather station 'Arna' in Greece with
#' coordinates 36.88002, 22.41292 (ETRS89) and altitude 779 m.
#' The owner of that weather station is the Ministry of Environment and Energy.
#' Precipitation's units of measurement is in mm and the time step is five
#' minutes.
#'
#' @format A tibble with 48,209 rows and 2 variables:
#' \describe{
#'   \item{date}{The time series' dates}
#'   \item{prec}{Precipitation, in mm}
#' }
#' @source http://kyy.hydroscope.gr/timeseries/d/1432/
"prec5min"


#' Helliniko maximum intensities
#'
#' A 30 year (1957-58 to 1986-87) data record of the Helliniko recording
#' station (located at the Helliniko airport, Athens). The durations range from
#' 5/60 h  (5 min) to 24 h. Owing to missing values, the sample size for some durations is lower than 30.
#'
#' @format  A tibble with 228 rows and 2 variables:
#' \describe{
#'   \item{duration}{The duration of the maximum intensity for a specific year}
#'   \item{intensity}{Maximum intensity for a specific year and duration, in
#'   mm/hr}
#' }
#'
#' @source D. Koutsoyiannis, Statistical Hydrology, Edition 4, 312 pages,
#' doi:10.13140/RG.2.1.5118.2325, National Technical University of Athens,
#' Athens, 1997.
"helliniko"
