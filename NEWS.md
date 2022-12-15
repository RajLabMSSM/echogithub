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
    
## Bug fixes

* Elevate `rvest` to *Imports*.
    
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