# GitHub metadata

Get metadata on a GitHub repository.

## Usage

``` r
github_metadata(
  owner,
  repo,
  add_traffic = FALSE,
  token = gh::gh_token(),
  .limit = Inf,
  verbose = TRUE
)
```

## Arguments

- owner:

  Repo owner name (can be organization or individual GitHub account
  name).

- repo:

  GitHub repository name.

- add_traffic:

  Add traffic metadata with
  [github_traffic](https://rajlabmssm.github.io/echogithub/reference/github_traffic.md).

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

- verbose:

  Print messages.

## Value

A [data.table](https://rdrr.io/pkg/data.table/man/data.table.html).

## Examples

``` r
if (FALSE) { # \dontrun{
dt <- github_metadata(owner="RajLabMSSM",
                      repo="echolocatoR")
} # }
```
