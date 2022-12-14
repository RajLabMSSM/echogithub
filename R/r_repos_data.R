r_repos_data <- function(verbose=TRUE){
    requireNamespace("rvest")
    requireNamespace("BiocManager")
    requireNamespace("githubinstall")
    # Get all packages per repo
    
    messager("Gathering R package repository data.",v=verbose)
    #### Base R ####
    baser <- rownames(installed.packages(priority="base")) 
    
    #### CRAN ####
    cran <- utils::available.packages(
        contriburl = "https://cran.rstudio.com/src/contrib") |> data.frame() 
    
    #### Bioc ####
    # *Note*: This only retrieves Bioc packages in the currently installed 
    # release of Bioconductor. Packages that are only in older versions of Bioc 
    # (and were later deprecated) will not be listed here. 
    ### This function gives all packages, including CRAN, Bioc,
    # and anything currently installed. 
    # bioc <- BiocManager::available()  
    ### This only gives Bioc packages ####
    repos <- BiocManager::repositories()
    repos <- repos[names(repos)!="CRAN"]
    bioc <- utils::available.packages(repos = repos) |> data.frame() 
    
    #### rOpenSci ####
    ropensci <- 
        rvest::read_html("https://docs.ropensci.org/") |>
        rvest::html_element("#repolist") |>
        rvest::html_children() |> 
        rvest::html_text()  
    
    ## GitHub
    
    # > The githubinstall package uses Gepuro Task Views for getting the list of R packages on GitHub. Gepuro Task Views is crawling the GitHub and updates information every day. The package downloads the list of R packages from Gepuro Task Views each time it was loaded. Thus, you can always use the newest list of packages on a new R session.
    # However, you may use an R session for a long time. In such case, gh_update_package_list() is useful.
    # gh_update_package_list() updates the downloaded list of the R packages explicitly.
    # 
    # However this is not actually true, 
    # as the file has not been updated since February 3rd 2018:
    #     https://github.com/hoxo-m/githubinstall/issues/41
    # 
    # A Pull Request was made in 2019 but it was never integrated:
    #     https://github.com/pabter/gepuro-task-views-copy/tree/76b7c4e48a704927432f328c6f898cbac0c5731c
    
    githubinstall::gh_update_package_list()
    github <- githubinstall::gh_list_packages() 
    
    #### Merge all repos #### 
    pkgs <- rbind(
        cbind(package=baser,
              repo="base"),
        cbind(package=cran$Package,
              repo="CRAN"),
        cbind(package=bioc$Package,
              repo="Bioc"),
        cbind(package=ropensci,
              repo="rOpenSci"),
        cbind(package=github$package_name,
              repo="GitHub")
    ) |>
        data.table::data.table()
    return(pkgs)
}