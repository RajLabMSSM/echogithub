% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/github_dependents.R
\name{github_dependents}
\alias{github_dependents}
\title{GitHub dependents}
\usage{
github_dependents(owner, repo, token = gh::gh_token(), verbose = TRUE)
}
\arguments{
\item{owner}{Repo owner name
(can be organization or individual GitHub account name).}

\item{repo}{GitHub repository name.}

\item{token}{GitHub Personal Authentication Token (PAT).
See \href{https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token}{
here for further instructions}.}

\item{verbose}{Print messages.}
}
\value{
A \link[data.table]{data.table}.
}
\description{
Get all GitHub repositories that are dependent on the target
 GitHub repository.
}
\examples{
dt <- github_dependents(owner = "neurogenomics", 
                        repo = "rworkflows")
}
