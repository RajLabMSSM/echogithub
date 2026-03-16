# GitHub dependents

Get all GitHub repositories that are dependent on the target GitHub
repository. *NOTE:* The [GitHub
API](https://docs.github.com/en/rest/dependency-graph) does not
currently support getting deps from repo, so need to use webscraping
instead.

## Usage

``` r
github_dependents(
  owner,
  repo,
  token = gh::gh_token(),
  max_pages = 1000,
  verbose = TRUE
)
```

## Source

[github-dependents-info
(python)](https://github.com/nvuillam/github-dependents-info)

[github-dependents-scraper
(CLI)](https://github.com/manusa/github-dependents-scraper)

Made with a little help from ChatGPT.

## Arguments

- owner:

  Repo owner name (can be organization or individual GitHub account
  name).

- repo:

  GitHub repository name.

- token:

  GitHub Personal Authentication Token (PAT). See [here for further
  instructions](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token).

- max_pages:

  The maximum number of pages to extract before stopping.

- verbose:

  Print messages.

## Value

A [data.table](https://rdrr.io/pkg/data.table/man/data.table.html).

## Examples

``` r
if (FALSE) { # \dontrun{
dt <- github_dependents(owner = "neurogenomics",
                        repo = "rworkflows")
} # }
```
