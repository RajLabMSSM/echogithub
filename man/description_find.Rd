% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/description_find.R
\name{description_find}
\alias{description_find}
\title{Find a DESCRIPTION file}
\usage{
description_find(
  desc_file = NULL,
  owner = NULL,
  repo = NULL,
  use_github = FALSE,
  verbose = TRUE
)
}
\arguments{
\item{desc_file}{When \code{owner} or \code{repo} are NULL, 
these arguments are inferred from the \emph{DESCRIPTION} file.
If a  \emph{DESCRIPTION} file cannot be found in the current working directory, 
it then searches for one in the remote GitHub repository.}

\item{owner}{Repo owner name
(can be organization or individual GitHub account name).}

\item{repo}{GitHub repository name.}

\item{use_github}{Prioritize getting the \emph{DESCRIPTION} file
from GitHub.}

\item{verbose}{Print messages.}
}
\description{
Find  DESCRIPTION file for a given R package.
}
\examples{
 
desc_file <- description_find(repo="data.table") 
}
