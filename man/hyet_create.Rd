% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/hyet_create.R
\name{hyet_create}
\alias{hyet_create}
\title{Create an hyetograph}
\usage{
hyet_create(date, prec)
}
\arguments{
\item{date}{a numeric vector of precipitation values}

\item{prec}{a POSIXct vector with date values}
}
\value{
a tibble with the variables \code{date} and \code{prec}
}
\description{
\code{hyet_create} uses precipitation and date values to
create a tibble that represents the distribution of rainfall over time.
Returns an error if:
\itemize{
 \item \code{prec} and \code{date} values don't have the same length.
 \item \code{prec} is not a numeric vector.
 \item \code{date} is not a POSIXct (times) vector.
}
}
\details{
This function checks the validity of precipitation and date values
and returns an error if:
\itemize{
  \item{These vectors don't have the same length,}
  \item{precipitation is not numeric or}
  \item{date  is not POSIXct.}
}
}
\examples{

# create date and precipitation values
date <- seq(from = as.POSIXct(0, origin = "2018-01-01"),
                  length.out =  100,
                  by = "mins")
set.seed(1)
prec <-round(runif(100,0,10),1)

# create hyetograph
hyet <- hyet_create(date, prec)

}
