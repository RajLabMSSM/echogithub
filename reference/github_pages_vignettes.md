# GitHub Pages vignettes

List all GitHub Pages vignettes for one or more GitHub repository.

## Usage

``` r
github_pages_vignettes(
  owner,
  repo,
  as_toc = FALSE,
  branch = "gh-pages",
  subdir = "articles",
  query = "*.*.html$",
  local_repo = NULL,
  save_path = NULL,
  token = gh::gh_token(),
  verbose = FALSE
)
```

## Arguments

- owner:

  Repo owner name (can be organization or individual GitHub account
  name).

- repo:

  GitHub repository name.

- as_toc:

  Return the list of vignettes as a table of contents (TOC) HTML string.
  *NOTE*: If you want to show the TOC in an Rmarkdown file, make sure
  you change the code chunk settings to: `{r, results='asis'}`.

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

- verbose:

  Print messages.

## Examples

``` r
if (FALSE) { # \dontrun{
vdt <- github_pages_vignettes(owner = "RajLabMSSM",
                              repo = c("echolocatoR","echodata"))
} # }
```
