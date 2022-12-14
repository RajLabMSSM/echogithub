% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/description_extract.R
\name{description_extract}
\alias{description_extract}
\title{DESCRIPTION file: extract fields}
\usage{
description_extract(
  desc_file = NULL,
  repo = NULL,
  fields = c("owner", "repo", "authors"),
  add_html = FALSE,
  as_datatable = FALSE,
  verbose = TRUE
)
}
\arguments{
\item{desc_file}{When \code{owner} or \code{repo} are NULL, 
these arguments are inferred from the \emph{DESCRIPTION} file.
If a  \emph{DESCRIPTION} file cannot be found in the current working directory, 
it then searches for one in the remote GitHub repository.}

\item{repo}{GitHub repository name.}

\item{fields}{Fields to extract.}

\item{add_html}{Add HTML styling to certain fields (e.g "authors").}

\item{as_datatable}{Convert the results into a \link[data.table]{data.table}.}

\item{verbose}{Print messages.}
}
\value{
A named list or \link[data.table]{data.table}.
}
\description{
Extract information from an R package's DESCRIPTION file.
}
\examples{
 
\dontrun{
res <- description_extract(repo="echolocatoR")
}
}
