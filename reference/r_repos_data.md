# R repositories data

Gather data on which repositories R packages are distributed through
(e.g. CRAN, Bioc, rOpenSci, and/or GitHub).

## Usage

``` r
r_repos_data(
  include = NULL,
  add_downloads = FALSE,
  add_descriptions = FALSE,
  add_github = FALSE,
  add_hex = FALSE,
  hex_path = "inst/hex/hex.png",
  which = r_repos_opts(),
  cast = FALSE,
  fields = NULL,
  version = NULL,
  nThread = 1,
  token = gh::gh_token(),
  verbose = TRUE
)
```

## Arguments

- include:

  A subset of packages to return data for.

- add_downloads:

  Add the number of downloads from each repository.

- add_descriptions:

  Add metadata from *DESCRIPTION* files.

- add_github:

  Add metadata from the respective GitHub repository for each R package
  (if any exists).

- add_hex:

  Search for hex sticker URLs for each package. If the link does not
  exist, returns `NA`.

- hex_path:

  Path to hex sticker file.

- which:

  Which R repositories to extract data from.

- cast:

  Cast the results to wide format so that each package only appears in
  one row.

- fields:

  Fields to extract.

- version:

  (Optional) `character(1)` or `package_version` indicating the
  *Bioconductor* version (e.g., "3.8") for which repositories are
  required.

- nThread:

  Number of threads to parallelise `add_descriptions` step across.

- token:

  GitHub Personal Authentication Token (PAT). See [here for further
  instructions](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token).

- verbose:

  Print messages.

## Value

data.table

## Examples

``` r
if (FALSE) { # \dontrun{
#### All packages ####
pkgs1 <- r_repos_data()
#### Specific packages ####
#### Add extra data ####
pkgs2 <- r_repos_data(include=c("echogithub","echodeps","BiocManager"),
                      which = r_repos_opts(exclude = NULL),
                      add_downloads = TRUE,
                      add_descriptions = TRUE,
                      add_github = TRUE,
                      add_hex = TRUE,
                      cast = TRUE)
} # }
```
