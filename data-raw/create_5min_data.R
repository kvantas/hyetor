library(hydroscoper)

# get a 5 min step precipitation time series
prec5min <- get_data(subdomain = "kyy", time_id = 1431)

# round to 0.1 mm
prec5min$value <- round(prec5min$value, 1)

prec5min$comment <- NULL
names(prec5min) <- c("date", "prec")

devtools::use_data(prec5min, overwrite = TRUE)
