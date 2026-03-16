# GitHub code

Search for GitHub code using specific queries.

## Usage

``` r
github_code(query, token = gh::gh_token(), .limit = Inf, verbose = TRUE)
```

## Source

[GitHub Docs: Searching
code](https://docs.github.com/en/search-github/searching-on-github/searching-code)

## Arguments

- query:

  Regex query to filter files by.

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
## easily exceeds API limit
repos <- github_code(query="Package: path:DESCRIPTION", .limit=5)
} # }
```
