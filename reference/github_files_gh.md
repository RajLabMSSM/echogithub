# List files in GitHub repo: via gh

Search for files within a public GitHub repository and return their
paths.

## Usage

``` r
github_files_gh(
  owner,
  repo,
  branch = c("master", "main"),
  token = gh::gh_token(),
  .limit = Inf,
  verbose = TRUE
)
```

## Source

[GitHub
endpoints](https://docs.github.com/en/rest/overview/endpoints-available-for-github-apps)

[GitHub trees
API](https://docs.github.com/en/rest/git/trees#get-a-tree-recursively)

## Arguments

- owner:

  Repo owner name (can be organization or individual GitHub account
  name).

- repo:

  GitHub repository name.

- branch:

  Which branch to search.

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

A [data.table](https://rdrr.io/pkg/data.table/man/data.table.html) fo
file paths.
