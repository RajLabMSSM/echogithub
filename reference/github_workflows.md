# GitHub workflows

Get metadata on workflows that have been run via GitHub Actions. This
includes the "conclusion" columns showing whether the workflow is
currently passing.

## Usage

``` r
github_workflows(
  owner,
  repo,
  token = gh::gh_token(),
  latest_only = TRUE,
  workflows = NULL,
  verbose = TRUE
)
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

- latest_only:

  Only return the latest run of each workflow.

- workflows:

  Select which workflows to return metadata for.

- verbose:

  Print messages.

## Value

[data.table](https://rdrr.io/pkg/data.table/man/data.table.html)
containing workflow metadata.

## Examples

``` r
if (FALSE) { # \dontrun{
dt <- github_workflows(owner="neurogenomics", repo="orthogene")
} # }
```
