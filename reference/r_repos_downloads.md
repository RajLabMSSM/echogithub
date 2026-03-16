# Get downloads data from CRAN/Bioconductor/GitHub

Get the total number of downloads for each R package in CRAN,
Bioconductor, and/or GitHub.

## Usage

``` r
r_repos_downloads(
  pkgs = NULL,
  which = r_repos_opts(),
  use_cache = TRUE,
  nThread = 1,
  verbose = TRUE
)
```

## Source

[dlstats Issue with getting downloads data for many packages at
once.](https://github.com/GuangchuangYu/dlstats/issues/5)

## Arguments

- pkgs:

  Output from
  [r_repos_data](https://rajlabmssm.github.io/echogithub/reference/r_repos_data.md).

- which:

  Which R repositories to extract data from.

- use_cache:

  logical, should cached data be used? Default: TRUE. If set to FALSE,
  it will re-query download stats and update cache.

- nThread:

  Number of threads to parallelise data queries across.

- verbose:

  Print messages.

## Examples

``` r
if (FALSE) { # \dontrun{
#### All packages ####
pkgs_all <- r_repos_downloads(which = "Bioc")

#### Specific packages ####
pkgs <- r_repos_data()[r_repo=="CRAN",][seq_len(5),]
pkgs2 <- r_repos_downloads(pkgs = pkgs,
                           which = c("CRAN","Bioc"))
} # }
```
