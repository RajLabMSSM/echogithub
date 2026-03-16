# R repositories

Report on which repositories R packages are distributed through (i.e.
base R, CRAN, Bioc, rOpenSci, R-Forge, and/or GitHub).

## Usage

``` r
r_repos(
  which = r_repos_opts(),
  version = NULL,
  add_downloads = FALSE,
  add_descriptions = FALSE,
  add_github = FALSE,
  upset_plot = TRUE,
  show_plot = TRUE,
  queries = r_repos_upset_queries(which = which, upset_plot = upset_plot),
  save_path = tempfile(fileext = "upsetr.pdf"),
  height = 7,
  width = 10,
  nThread = 1,
  verbose = TRUE
)
```

## Arguments

- which:

  Which R repositories to extract data from.

- version:

  (Optional) `character(1)` or `package_version` indicating the
  *Bioconductor* version (e.g., "3.8") for which repositories are
  required.

- add_downloads:

  Add the number of downloads from each repository.

- add_descriptions:

  Add metadata from *DESCRIPTION* files.

- add_github:

  Add metadata from the respective GitHub repository for each R package
  (if any exists).

- upset_plot:

  Whether to create an upset plot showing R package overlap between
  repositories.

- show_plot:

  Print the plot.

- queries:

  A list of query specifications for the upset plot.

- save_path:

  Path to save upset plot to.

- height:

  Saved plot height.

- width:

  Saved plot width.

- nThread:

  Number of threads to parallelise data queries across.

- verbose:

  Print messages.

## Value

Named list.

## Examples

``` r
if (FALSE) { # \dontrun{
report <- r_repos()
} # }
```
