# GitHub Pages website

Return the [GitHub Pages](https://pages.github.com/) website URL for a
given repository, if one exists.

## Usage

``` r
github_pages(
  owner,
  repo,
  error = TRUE,
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

- verbose:

  Print messages.

## Examples

``` r
if (FALSE) { # \dontrun{
link <- github_pages(owner="RajLabMSSM",
                     repo="echolocatoR")
} # }
```
