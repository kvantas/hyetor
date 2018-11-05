helliniko <- read.csv("./data-raw/elliniko.csv", sep = "\t")
helliniko <- tibble::as.tibble(helliniko)
# devtools::use_data(helliniko)

# use optim to find idf parameters #############################################

df <- helliniko[sample(nrow(helliniko), nrow(helliniko),replace = FALSE),]

library(dplyr)
df <- helliniko %>% group_by(duration) %>%
  arrange(desc(intensity), .by_group = TRUE) %>%
  add_tally() %>%
  mutate(id = row_number()) %>%
  mutate(ret_per = (n + 0.12)/(id - 0.44)) %>%
  select(c("duration", "intensity", "ret_per"))

idf <- function(duration, ret_per,
                kappa, hetta, theta, lambda, psi) {

  if (kappa > 0) {
    # GEV
    a <- lambda * (psi +((-log(1 - 1/ret_per))^(-kappa) - 1)/kappa)
  } else {
    # Gumbell
    a <- lambda * (psi -log(-log(1 - 1/ret_per)))
  }

  b <- (duration + theta)^hetta

  a/b
}

kappa <- 0.183-0.00049* mean(df$intensity[df$duration == 24], na.rm = TRUE)
kappa

cost <- function(x, fixed_kappa = FALSE) {
  hetta  <- x[1]
  theta  <- x[2]
  lambda <- x[3]
  psi    <- x[4]
  if (!fixed_kappa) {
    kappa  <- x[5]
  }

  # compute error

  errors <- df %>%
    mutate(intens_hat = idf(duration, ret_per,
                            kappa, hetta, theta, lambda, psi),
           error = log(intensity / intens_hat)^2
           ) %>%
    filter( is.finite(error)) %>%
    group_by(duration) %>%
    summarise(error = mean(error)) %>%
    ungroup()

  mean(errors$error)
}

cost(x = c(hetta=0.7764, theta=0.1393, lambda=6.8155, psi=2.8055, kappa = 0.18),
     fixed_kappa = FALSE)

res_opt <- optim(par   = c(hetta=0.5, theta=0.5, lambda=5, psi=10, kappa = 0.1),
                 lower = c(      0,         0,          0,    -Inf,       0),
                 upper = c(      1,         Inf,        Inf,   Inf,       1),
                 fn = cost, gr =  NULL,
                 method = "L-BFGS-B",
                 control = list(maxit = 1000))
res_opt$par
res_opt$value
