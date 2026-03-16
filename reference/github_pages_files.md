# Find pages

Find html files on GitHub Pages.

## Usage

``` r
github_pages_files(
  owner,
  repo,
  branch = "gh-pages",
  subdir = NULL,
  query = NULL,
  local_repo = NULL,
  save_path = NULL,
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

- branch:

  Which branch to search.

- subdir:

  Only search for files within a given subdirectory (e.g. "docs").

- query:

  Regex query to filter files by.

- local_repo:

  Search a cloned local folder of a git repo instead of the remote
  GitHub repo. If not `NULL`, expects a path to the local repo.

- save_path:

  Path to save the results to (as a ".csv").

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
dt <- github_pages_files(owner="RajLabMSSM",
                         repo="echolocatoR",
                         .limit=5)
} # }
```
