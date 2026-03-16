# Find, filter, and download files in a GitHub repository

Search for files within a GitHub repository and filter them by a regex
`query`. Optionally, can download these selected files to your local
computer using the original folder structure. *NOTE*: To search your
private repos, make sure you GitHub token is supplied to the `token`
argument, or is saved as in your *~.Renviron* file, e.g.:
`GITHUB_TOKEN=<token_here>`

## Usage

``` r
github_files(
  owner,
  repo,
  branch = c("master"),
  query = NULL,
  ignore.case = FALSE,
  method = "gh",
  token = gh::gh_token(),
  .limit = Inf,
  download = FALSE,
  download_dir = tempdir(),
  overwrite = FALSE,
  timeout = 5 * 60,
  nThread = 1,
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

- query:

  Regex query to filter files by.

- ignore.case:

  logical. if `FALSE`, the pattern matching is *case sensitive* and if
  `TRUE`, case is ignored during matching.

- method:

  Method to perform queries with:

  "gh"

  :   Uses the R package gh. Uses GitHub token to avoid query limits.

  "httr"

  :   Uses the R package httr. More flexible but quickly runs into
      webscraping limits imposed by GitHub.

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

- download:

  Whether to download the files. The downloaded file paths will be added
  to a new column named "path_local".

- download_dir:

  Directory to download files into.

- overwrite:

  If a local file already exists, overwrite it.

- timeout:

  How long to wait before timing out during queries/downloads (in units
  of seconds).

- nThread:

  Number of threads to parallelize queries/downloads across.

- verbose:

  Print messages.

## Value

A list of paths.

## Examples

``` r
if (FALSE) { # \dontrun{
files <- github_files(owner = "RajLabMSSM",
                      repo = "Fine_Mapping_Shiny",
                      query = ".md$")
} # }
```
