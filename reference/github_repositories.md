# GitHub repositories

Search for GitHub repositories using specific queries.

## Usage

``` r
github_repositories(
  query,
  token = gh::gh_token(),
  .limit = Inf,
  verbose = TRUE
)
```

## Source

[GitHub Docs: Search
repositories](https://docs.github.com/en/rest/search#search-repositories)

[GitHub Docs: Constructing a search
query](https://docs.github.com/en/rest/search#constructing-a-search-query)

[Searching GitHub
repos](https://docs.github.com/en/search-github/searching-on-github/searching-for-repositories)

[Case-sensitive GitHub
searches](https://github.com/orgs/community/discussions/9759)

[Examples of using gh to search
repositories](https://github.com/r-lib/gh/pull/136)

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
repos <- github_repositories(query="language:r", .limit=100)
} # }
```
