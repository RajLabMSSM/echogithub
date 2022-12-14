% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/report_time.R
\name{report_time}
\alias{report_time}
\title{Report time}
\usage{
report_time(
  start,
  end = Sys.time(),
  prefix = NULL,
  verbose = TRUE,
  units = "min",
  digits = 2
)
}
\arguments{
\item{units}{character string.  Units in which the results are
    desired.  Can be abbreviated.}

\item{digits}{integer indicating the number of decimal places
    (\code{round}) or significant digits (\code{signif}) to be used.
    For \code{round}, negative values are allowed (see \sQuote{Details}).}
}
\description{
Report time at end of function.
}
\keyword{internal}
