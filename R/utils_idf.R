#' compute intensity using idf parameters
#'
#' @noRd
idf <- function(duration, freque,
                kappa, hetta, theta, lambda, psi) {

  # compute numerator of idf function
  if (kappa > 0) {
    # GEV
    a <- lambda * (psi +((-log(1 - 1/freque))^(-kappa) - 1)/kappa)
  } else if (kappa == 0){
    # Gumbell
    a <- lambda * (psi -log(-log(1 - 1/freque)))
  } else {
    stop(paste("kappa < 0 implies an upper bound, which is not the case in",
               "maximum rainfall intensity"))
  }
  # compute denominator
  b <- (duration + theta)^hetta
  a/b
}

#' Optimize idf parameters
#'
#' @noRd
optim_idf <- function(df, par = c(hetta=0.5, theta=0.5, lambda=5, psi=10,
                                  kappa = 0.1)) {

  # order data and compute frequencies
  df <- dplyr::group_by(df, .data$duration)
  df <- dplyr::arrange(dplyr::desc(.data$intensity), by.group = TRUE)

  # add a column n to based on the number of items within durations
  df <- dplyr::add_tally(df)

  # compute frequencies
  df <- dplyr::mutate(
    df,
    id = dplyr::row_number(),
    freque = (.data$n + 0.12)/(.data$id - 0.44)
  )

  # cost function used in optimization of idf
  cost <- function(x) {

    hetta  <- x[1]
    theta  <- x[2]
    lambda <- x[3]
    psi    <- x[4]
    kappa  <- x[5]

    # compute errors
    errors <- dplyr::mutate(df,
      intens_hat = idf(.data$duration, .data$freque,
                       kappa, hetta, theta, lambda, psi),
      error = log(.data$intensity / .data$intens_hat)^2
      )

    # remove non finite errors
    errors <- dplyr::filter(errors, is.finite(.data$error))

    # compute mean error per duration
    errors <- dplyr::ungroup(errors)
    errors <- dplyr::group_by(errors, .data$duration)
    errors <- dplyr::summarise(errors, error = mean(.data$error))
    errors <- dplyr::ungroup(errors)

    # return mean error per duration
    mean(errors$error)
  }

  # use optim function
  res <- optim(par     = par,
               lower   = c(0,   0,   0, -Inf, 0),
               upper   = c(1, Inf, Inf,  Inf, 1),
               fn      = cost,
               gr      =  NULL,
               method  = "L-BFGS-B",
               control = list(maxit = 1000))
}

