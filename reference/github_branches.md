# GitHub branches

List all branches for a given GitHub repository.

## Usage

``` r
github_branches(
  owner = NULL,
  repo = NULL,
  branch = NULL,
  master_or_main = TRUE,
  as_datatable = FALSE,
  token = gh::gh_token(),
  desc_file = NULL,
  error = FALSE,
  verbose = TRUE
)
```

## Arguments

- owner:

  Owner of the GitHub repository. If `NULL`, will automatically try to
  infer the owner name from the *DESCRIPTION file* (assuming you're
  working directory is a local R package repo).

- repo:

  GitHub repository name. If `NULL`, will automatically try to infer the
  repo name name from the *DESCRIPTION file* (assuming you're working
  directory is a local R package repo).

- branch:

  \[Optional\] If `branch` is supplied (as a character vector of one or
  more branch names), will check to see if that branch exists. If it
  does, only that branch will be returned. If it doesn't, an error will
  be thrown.

- master_or_main:

  If `branch` is supplied and is either `"master"` or `"main"`,
  automatically interpret "master" and "main" as synonymous and return
  whichever branch exists.

- as_datatable:

  Return the results as a
  [data.table](https://rdrr.io/pkg/data.table/man/data.table.html)
  (`TRUE`), or as a character vector of branch names (default: `FALSE`).

- token:

  GitHub Personal Authentication Token (PAT). See [here for further
  instructions](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token).

- desc_file:

  When `owner` or `repo` are NULL, these arguments are inferred from the
  *DESCRIPTION* file.

- error:

  Throw an error when no matching branches are fond.

- verbose:

  Print messages.

## Value

Character vector or
[data.table](https://rdrr.io/pkg/data.table/man/data.table.html) of
branches.

## Examples

``` r
if (FALSE) { # \dontrun{
branches <- github_branches(owner="RajLabMSSM", repo="echolocatoR")
} # }
```
