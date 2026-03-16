# GitHub permissions

Get permissions metadat on a GitHub repository.

## Usage

``` r
github_permissions(owner, repo, token = gh::gh_token(), verbose = TRUE)
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

- verbose:

  Print messages.

## Value

A [data.table](https://rdrr.io/pkg/data.table/man/data.table.html).

## Examples

``` r
if (FALSE) { # \dontrun{
permissions <- github_permissions(owner="RajLabMSSM",
                                  repo="echolocatoR")
} # }
```
