# List files in GitHub repo: via httr

Search for files within a public GitHub repository and return their
paths.

## Usage

``` r
github_files_httr(
  owner,
  repo,
  branch = c("main", "master"),
  seconds = 5 * 60,
  verbose = TRUE
)
```

## Arguments

- owner:

  Repo owner name (can be organization or individual GitHub account
  name).

- repo:

  GitHub repository name.

- branch:

  Which branch to search.

- seconds:

  number of seconds to wait for a response until giving up. Can not be
  less than 1 ms.

- verbose:

  Print messages.

## Value

A [data.table](https://rdrr.io/pkg/data.table/man/data.table.html) fo
file paths.
