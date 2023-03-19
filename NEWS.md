# echogithub 0.99.2

## New features

* Replace functions that have since been offloaded and improved in `rworkflows`
    - `echogithub::description_find` --> `rworkflows::get_description`
    - `echogithub::github_hex` --> `rworkflows::get_hex`
    - `echogithub::readme_header` --> `rworkflows::use_badges`
* `r_repos_data`
    - Add new arg `add_hex` to find hex URL with `rworkflows::get_hex`.
* `r_repos`
    - New arg `queries`
* New functions:
    - `github_user_events`
* Expose `.limit` arg wherever relevant.

## Bug fixes

* `github_dependents`
    - Gather deps from all pages (not just the first one).
* `description_authors`
    - Fix to handle more complex situations 
    without explicit naming of each field.
* `r_repos_data`
    - Add a check for find R packages that are on GitHub but just not available 
    via `githubinstall` (which is a lot, since it became outdated years ago).
    

# echogithub 0.99.1

## New features

* New GitHub functions:
    - `github_permissions`
    - `github_metadata`
    - `github_commits`
    - `github_traffic`
    - `github_dependents`
    - `github_dependencies`
* New functions for finding which repos R packages are in:
    - `r_repos`
    - `r_repos_data`
    - `r_repos_downloads`
    - `r_repos_opts`
* Added more robust func to get GH url: `get_github_url()`
    
## Bug fixes

* Elevate `rvest` to *Imports*.
* Add `parallel` to *Imports*. 
* `r_repos_downloads_bioc`  / `r_repos_downloads_cran`
    - Split queries into batches to prevent issues 
        requesting with too many packages at once.
    - Parallelise.
    
# echogithub 0.99.0

## New features

* Added a `NEWS.md` file to track changes to the package.
* Moved all GitHub-related functions from `echodata` to `echogithub`.
* New function: `github_branches`:
    - Automatically infers owner/repo/branches. 
    - Automatically translates main/master to the correct synonym.
    
## Bug fixes

* Switched to using `gh` instead of `httr` to avoid API limits imposed by GitHub.
    - Kept `httr` as alternative method.
* `is_url`:
    - Add `RCurl::url.exists` check.