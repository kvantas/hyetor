library(hydroscoper)

# get a 5 min step precipitation time series
prec5min <- get_data(subdomain = "kyy", time_id = 1431)

# remove near zero values
prec5min$value <- ifelse(prec5min$value < 0.01, 0, prec5min$value)

prec5min$comment <- NULL
names(prec5min) <- c("date", "prec")

devtools::use_data(prec5min, overwrite = TRUE)
