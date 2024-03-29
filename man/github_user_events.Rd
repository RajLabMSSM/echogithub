% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/github_user_events.R
\name{github_user_events}
\alias{github_user_events}
\title{GitHub user events}
\usage{
github_user_events(
  owner,
  error = TRUE,
  token = gh::gh_token(),
  .limit = Inf,
  public_only = TRUE,
  as_datatable = TRUE,
  verbose = TRUE
)
}
\arguments{
\item{owner}{Repo owner name
(can be organization or individual GitHub account name).}

\item{error}{Throw an error when the GitHub repository does not exist 
(default: \code{TRUE}).}

\item{token}{GitHub Personal Authentication Token (PAT).
See \href{https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token}{
here for further instructions}.}

\item{.limit}{Number of records to return. This can be used
instead of manual pagination. By default it is \code{NULL},
which means that the defaults of the GitHub API are used.
You can set it to a number to request more (or less)
records, and also to \code{Inf} to request all records.
Note, that if you request many records, then multiple GitHub
API calls are used to get them, and this can take a potentially
long time.}

\item{public_only}{Only include public events. 
To include private events as well,set \code{public_only=FALSE} and provide a 
valid GitHub \code{token}.}

\item{as_datatable}{Return query results as a \link[data.table]{data.table} 
instead of a nested list.}

\item{verbose}{Print messages.}
}
\description{
Return all events (e.g. commits, pull requests, comments, etc.) 
for a GitHub user across all repositories.
}
\examples{
events <- github_user_events(owner="bschilder", .limit=100)
}
