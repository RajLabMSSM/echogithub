# echogithub: Getting started

## GitHub branches

### List

Easily find all available branches for a given GitHub repo.

``` r

branches <- echogithub::github_branches(owner = "RajLabMSSM",
                                        repo = "echolocatoR")
```

    ## Searching for all branches in: RajLabMSSM/echolocatoR

    ## 5 branch(es) found: 
    ##  - dev
    ##  - echoverse
    ##  - gh-pages
    ##  - master
    ##  - v1

``` r

print(branches)
```

    ## [1] "dev"       "echoverse" "gh-pages"  "master"    "v1"

### Check

You can also check whether a particular branch exists. By default,
[`github_branches()`](https://rajlabmssm.github.io/echogithub/reference/github_branches.md)
interprets “master” and “main” as synonymous and returns whichever one
actually exists.

``` r

branches <- echogithub::github_branches(owner = "RajLabMSSM",
                                        repo = "echolocatoR",
                                        branch = "main")
```

    ## Searching for all branches in: RajLabMSSM/echolocatoR

    ## 1 matching branch(es) found: 
    ##  - master

``` r

print(branches)
```

    ## [1] "master"

## GitHub files

[`github_files()`](https://rajlabmssm.github.io/echogithub/reference/github_files.md)
lets you easily:

1.  Search any GitHub repo (that you have access to) for files.
2.  Filter those files by a *regex* `query`.
3.  Download those files to your local computer (can increase `nThread`
    to speed up download via parallelisation).

*NOTE*: To search your private repos, make sure your GitHub token is
supplied to the `token` argument, or is saved in your *~/.Renviron*
file, e.g.: `GITHUB_TOKEN=<token_here>`

### Search / filter / download

``` r

files <- echogithub::github_files(owner = "RajLabMSSM",
                                  repo = "Fine_Mapping_Shiny",
                                  query = ".md$",
                                  ignore.case = TRUE,
                                  download = TRUE)
```

    ## Searching for all branches in: RajLabMSSM/Fine_Mapping_Shiny

    ## 1 matching branch(es) found: 
    ##  - master

    ## 6,529 files found in GitHub repo: RajLabMSSM/Fine_Mapping_Shiny

    ## 1 file(s) found matching query.

    ## + Downloading 1 files.

    ## Returning pre-existing file: https://raw.githubusercontent.com/RajLabMSSM/Fine_Mapping_Shiny/master/README.md

``` r

knitr::kable(utils::head(files))
```

| path | mode | type | sha | size | url | link | link_raw | path_local |
|:---|:---|:---|:---|:---|:---|:---|:---|:---|
| README.md | 100644 | blob | 0b1923bd0830aa5ebd0b9d16a367b26216ebbd35 | 151 | <https://api.github.com/repos/RajLabMSSM/Fine_Mapping_Shiny/git/blobs/0b1923bd0830aa5ebd0b9d16a367b26216ebbd35> | <https://github.com/RajLabMSSM/Fine_Mapping_Shiny/blob/master/README.md> | <https://raw.githubusercontent.com/RajLabMSSM/Fine_Mapping_Shiny/master/README.md> | /tmp/RtmppsX57R/ |

## GitHub Pages

There are several functions for searching GitHub Pages websites
associated with specific GitHub repos.

### Find GitHub Pages URL

First, since not all GitHub repos use GitHub Pages, we should find out
whether the one we are interested in exists.

``` r

ghpages_url <- echogithub::github_pages(owner = "RajLabMSSM",
                                        repo = "echolocatoR")
```

    ## Returning valid GitHub Pages URL for repo: RajLabMSSM/echolocatoR.

``` r

print(ghpages_url)
```

    ## [1] "https://rajlabmssm.github.io/echolocatoR/"

If it does not exist, the function will simply return `NULL` when you
set `error = FALSE`.

``` r

ghpages_null <- echogithub::github_pages(owner = "RajLabMSSM",
                                         repo = "Fine_Mapping_Shiny",
                                         error = FALSE)
```

    ## Cannot find GitHub Pages URL for repo RajLabMSSM/Fine_Mapping_Shiny. Returning NULL.

``` r

print(ghpages_null)
```

    ## NULL

### Find vignettes

`github_pages_vignettes` allows you to easily gather all vignettes
across multiple GitHub Pages websites at once.

#### As `data.table`

``` r

vdt <- echogithub::github_pages_vignettes(
    owner = c("RajLabMSSM", "neurogenomics"),
    repo = c("echodata", "MungeSumstats")
)
knitr::kable(utils::head(vdt))
```

| repo | owner | path | mode | type | sha | size | url | link | link_raw | link_ghpages_index | link_ghpages | link_html |
|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|
| echodata | RajLabMSSM | articles/echodata.html | 100644 | blob | d0440b4251930f0c7f3f5b7217a10273e8ccb676 | 12505 | <https://api.github.com/repos/RajLabMSSM/echodata/git/blobs/d0440b4251930f0c7f3f5b7217a10273e8ccb676> | <https://github.com/RajLabMSSM/echodata/blob/master/articles/echodata.html> | <https://raw.githubusercontent.com/RajLabMSSM/echodata/gh-pages/articles/echodata.html> | <https://rajlabmssm.github.io/echodata/> | <https://rajlabmssm.github.io/echodata//articles/echodata.html> | [echodata](https://rajlabmssm.github.io/echodata//articles/echodata.html) |
| echodata | RajLabMSSM | articles/echolocatoR_Finemapping_Portal.html | 100644 | blob | 5ad7fda2f3700b037bff3206f720313e2d75e828 | 42174 | <https://api.github.com/repos/RajLabMSSM/echodata/git/blobs/5ad7fda2f3700b037bff3206f720313e2d75e828> | <https://github.com/RajLabMSSM/echodata/blob/master/articles/echolocatoR_Finemapping_Portal.html> | <https://raw.githubusercontent.com/RajLabMSSM/echodata/gh-pages/articles/echolocatoR_Finemapping_Portal.html> | <https://rajlabmssm.github.io/echodata/> | <https://rajlabmssm.github.io/echodata//articles/echolocatoR_Finemapping_Portal.html> | [echolocatoR Finemapping Portal](https://rajlabmssm.github.io/echodata//articles/echolocatoR_Finemapping_Portal.html) |

#### As table of contents

You can also use the `as_toc = TRUE` argument to turn the vignettes
`data.table` into an HTML Table of Contents (TOC).

``` r

toc <- echogithub::github_pages_vignettes(
    owner = c("RajLabMSSM", "neurogenomics"),
    repo = c("echodata", "MungeSumstats"),
    as_toc = TRUE
)
```

- ### 

  - [echodata](https://rajlabmssm.github.io/echodata/)

  &nbsp;

  - #### [echodata](https://rajlabmssm.github.io/echodata//articles/echodata.html)

  - #### [echolocatoR Finemapping Portal](https://rajlabmssm.github.io/echodata//articles/echolocatoR_Finemapping_Portal.html)

## *DESCRIPTION* files

*DESCRIPTION* files contain essential information about each R package.
However, finding and importing them is not always straightforward
(e.g. when the package is not yet installed).
[`echogithub::description_extract`](https://rajlabmssm.github.io/echogithub/reference/description_extract.md)
searches a variety of sources (e.g. local files, local installations,
GitHub) to find the correct *DESCRIPTION* file and import it into the
easy-to-use `description` format.

It then parses it to extract the relevant information.

### Find and extract

`description_extract` takes that object and extracts and parses just the
fields you need, returning them as a named list.

``` r

res <- echogithub::description_extract(
    refs = c("RajLabMSSM/echolocatoR",
             "RajLabMSSM/echogithub",
             "RajLabMSSM/rworkflows")
)
```

    ## When refs is provided, paths must have the same length (or be set to NULL). Setting paths=NULL.

    ## Cannot find DESCRIPTION for: echolocatoR

    ## Importing cached file: /github/home/.cache/R/rworkflows/RajLabMSSM.echolocatoR_DESCRIPTION

``` r

methods::show(res)
```

    ## Key: <repo>
    ##                   package         owner        repo
    ##                    <char>        <char>      <char>
    ## 1:  RajLabMSSM/echogithub    RajLabMSSM  echogithub
    ## 2: RajLabMSSM/echolocatoR    RajLabMSSM echolocatoR
    ## 3:  RajLabMSSM/rworkflows neurogenomics  rworkflows
    ##                                                          authors
    ##                                                           <char>
    ## 1: Brian Schilder, Jack Humphrey, Towfique Raj, Hiranyamaya Dash
    ## 2:                   Brian Schilder, Jack Humphrey, Towfique Raj
    ## 3:  Brian Schilder, Alan Murphy, Hiranyamaya  Dash, Nathan Skene

## Session Info

``` r

utils::sessionInfo()
```

    ## R Under development (unstable) (2026-03-12 r89607)
    ## Platform: x86_64-pc-linux-gnu
    ## Running under: Ubuntu 24.04.4 LTS
    ## 
    ## Matrix products: default
    ## BLAS:   /usr/lib/x86_64-linux-gnu/openblas-pthread/libblas.so.3 
    ## LAPACK: /usr/lib/x86_64-linux-gnu/openblas-pthread/libopenblasp-r0.3.26.so;  LAPACK version 3.12.0
    ## 
    ## locale:
    ##  [1] LC_CTYPE=en_US.UTF-8       LC_NUMERIC=C              
    ##  [3] LC_TIME=en_US.UTF-8        LC_COLLATE=en_US.UTF-8    
    ##  [5] LC_MONETARY=en_US.UTF-8    LC_MESSAGES=en_US.UTF-8   
    ##  [7] LC_PAPER=en_US.UTF-8       LC_NAME=C                 
    ##  [9] LC_ADDRESS=C               LC_TELEPHONE=C            
    ## [11] LC_MEASUREMENT=en_US.UTF-8 LC_IDENTIFICATION=C       
    ## 
    ## time zone: UTC
    ## tzcode source: system (glibc)
    ## 
    ## attached base packages:
    ## [1] stats     graphics  grDevices utils     datasets  methods   base     
    ## 
    ## other attached packages:
    ## [1] echogithub_1.0.0 BiocStyle_2.39.0
    ## 
    ## loaded via a namespace (and not attached):
    ##  [1] yulab.utils_0.2.4   rappdirs_0.3.4      sass_0.4.10        
    ##  [4] generics_0.1.4      renv_1.1.8          rworkflows_1.0.8   
    ##  [7] bitops_1.0-9        stringi_1.8.7       digest_0.6.39      
    ## [10] magrittr_2.0.4      evaluate_1.0.5      grid_4.6.0         
    ## [13] RColorBrewer_1.1-3  bookdown_0.46       fastmap_1.2.0      
    ## [16] rprojroot_2.1.1     jsonlite_2.0.0      BiocManager_1.30.27
    ## [19] scales_1.4.0        httr2_1.2.2         textshaping_1.0.5  
    ## [22] jquerylib_0.1.4     cli_3.6.5           rlang_1.1.7        
    ## [25] gitcreds_0.1.2      badger_0.2.5        withr_3.0.2        
    ## [28] cachem_1.1.0        yaml_2.3.12         otel_0.2.0         
    ## [31] tools_4.6.0         parallel_4.6.0      dplyr_1.2.0        
    ## [34] ggplot2_4.0.2       here_1.0.2          curl_7.0.0         
    ## [37] vctrs_0.7.1         R6_2.6.1            lifecycle_1.0.5    
    ## [40] stringr_1.6.0       fs_1.6.7            htmlwidgets_1.6.4  
    ## [43] ragg_1.5.1          pkgconfig_2.0.3     desc_1.4.3         
    ## [46] pkgdown_2.2.0       bslib_0.10.0        pillar_1.11.1      
    ## [49] gtable_0.3.6        data.table_1.18.2.1 glue_1.8.0         
    ## [52] gh_1.5.0            systemfonts_1.3.2   xfun_0.56          
    ## [55] tibble_3.3.1        rvcheck_0.2.1       tidyselect_1.2.1   
    ## [58] knitr_1.51          farver_2.1.2        htmltools_0.5.9    
    ## [61] rmarkdown_2.30      dlstats_0.1.7       compiler_4.6.0     
    ## [64] S7_0.2.1            RCurl_1.98-1.17

------------------------------------------------------------------------
