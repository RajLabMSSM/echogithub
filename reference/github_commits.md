# GitHub commits

Get metadata for all commits to a given GitHub repo.

## Usage

``` r
github_commits(
  owner,
  repo,
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

A nested list of metadata

## Examples

``` r
if (FALSE) { # \dontrun{
commits <- github_commits(owner="RajLabMSSM",
                          repo="echolocatoR",
                          .limit=100)
} # }
```
