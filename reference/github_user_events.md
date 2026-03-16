# GitHub user events

Return all events (e.g. commits, pull requests, comments, etc.) for a
GitHub user across all repositories.

## Usage

``` r
github_user_events(
  owner,
  error = TRUE,
  token = gh::gh_token(),
  .limit = Inf,
  public_only = TRUE,
  as_datatable = TRUE,
  verbose = TRUE
)
```

## Arguments

- owner:

  Repo owner name (can be organization or individual GitHub account
  name).

- error:

  Throw an error when the GitHub repository does not exist (default:
  `TRUE`).

- token:

  GitHub Personal Authentication Token (PAT). See [here for further
  instructions](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token).

- .limit:

  Number of records to return. This can be used instead of manual
  pagination. By default it is `NULL`, which means that the defaults of
  the GitHub API are used. You can set it to a number to request more
  (or less) records, and also to `Inf` to request all records. Note,
  that if you request many records, then multiple GitHub API calls are
  used to get them, and this can take a potentially long time.

- public_only:

  Only include public events. To include private events as well,set
  `public_only=FALSE` and provide a valid GitHub `token`.

- as_datatable:

  Return query results as a
  [data.table](https://rdrr.io/pkg/data.table/man/data.table.html)
  instead of a nested list.

- verbose:

  Print messages.

## Examples

``` r
if (FALSE) { # \dontrun{
events <- github_user_events(owner="bschilder", .limit=100)
} # }
```
