#' R repositories data
#' 
#' Gather data on which repositories R packages are distributed through
#'  (e.g. CRAN, Bioc, rOpenSci, and/or GitHub).
#' @param include A subset of packages to return data for.
#' @param add_downloads Add the number of downloads from each repository.
#' @param add_descriptions Add metadata extracted from \emph{DESCRIPTION} files.
#' @param cast Cast the results to wide format
#'  so that each package only appears in one row.
#' @param nThread Number of threads to parallelise \code{add_descriptions} 
#' step across.
#' @param verbose Print messages.
#' @inheritParams r_repos
#' @inheritParams BiocManager::repositories
#' @returns data.table
#' 
#' @export
#' @importFrom utils installed.packages available.packages
#' @importFrom data.table merge.data.table
#' @examples 
#' pkgs <- r_repos_data()
r_repos_data <- function(include=NULL,
                         add_downloads=FALSE,
                         add_descriptions=FALSE,
                         which=r_repos_opts(),
                         cast=FALSE,
                         version=NULL,
                         nThread=1,
                         verbose=TRUE){
    requireNamespace("rvest")
    requireNamespace("BiocManager")
    requireNamespace("githubinstall")
    installed <- package <- NULL;
    
    which <- tolower(which)
    res <- list()
    #### Base R ####
    if("base" %in% which){
        messager("Gathering R packages: base",v=verbose)
        res[["base"]] <- data.table::data.table(
            package=rownames(utils::installed.packages(priority="base"))
        ) 
    } 
    #### CRAN ####
    if("cran" %in% which){
        messager("Gathering R packages: CRAN",v=verbose)
        cran <- utils::available.packages(
            contriburl = "https://cran.rstudio.com/src/contrib") |> data.frame()
        res[["CRAN"]] <- data.table::data.table(package=cran$Package)
    } 
    #### Bioc ####
    if("bioc" %in% which){
        messager("Gathering R packages: Bioc",v=verbose)
        # *Note*: This only retrieves Bioc packages in the currently installed 
        # release of Bioconductor. Packages that are only in older versions of Bioc 
        # (and were later deprecated) will not be listed here. 
        ### This function gives all packages, including CRAN, Bioc,
        # and anything currently installed. 
        # bioc <- BiocManager::available()  
        ### This only gives Bioc packages ####
        if(is.null(version)) version <- BiocManager::version()
        repos <- suppressMessages(
            BiocManager::repositories(version = version)
        )
        repos <- repos[names(repos)!="CRAN"]
        bioc <- utils::available.packages(repos = repos) |> data.frame()
        res[["Bioc"]] <- data.table::data.table(package=rownames(bioc))
    } 
    #### rOpenSci ####
    if("ropensci" %in% which){
        messager("Gathering R packages: rOpenSci",v=verbose)
        res[["rOpenSci"]] <- 
            data.table::data.table(
                package=rvest::read_html("https://docs.ropensci.org/") |>
                    rvest::html_element("#repolist") |>
                    rvest::html_children() |> 
                    rvest::html_text() 
                )
    }  
    #### R-forge #### 
    if("rforge" %in% which){
        messager("Gathering R packages: R-Forge",v=verbose)
        rforge <- utils::available.packages(
            repos = "http://R-Forge.R-project.org") |> data.frame()  
        res[["R-Forge"]] <- data.table::data.table(package=rownames(rforge))
    }
    #### GitHub ####
    if("github" %in% which){  
        messager("Gathering R packages: GitHub",v=verbose)
        # githubinstall::gh_update_package_list()
        github <- githubinstall::gh_list_packages() 
        res[["GitHub"]] <- data.table::data.table(package=github$package_name)
    }
    #### GitHub ####
    if("local" %in% which){  
        messager("Gathering R packages: local",v=verbose)
        # githubinstall::gh_update_package_list()
        local <- utils::installed.packages()
        res[["local"]] <- data.table::data.table(package=rownames(local))
    }
    #### Merge all repos #### 
    pkgs <- data.table::rbindlist(res, 
                                  fill = TRUE,
                                  use.names = TRUE, 
                                  idcol = "r_repo") 
    if(!is.null(include)) pkgs <- pkgs[package %in% include]
    #### Add installed info ####
    pkgs[,installed:=package %in% rownames(utils::installed.packages())]
    #### Add downloads ####
    if(isTRUE(add_downloads)){
        pkgs <- r_repos_downloads(pkgs = pkgs,
                                  which = which,
                                  verbose = verbose)
    }
    #### Cast wider ####
    if(isTRUE(cast)){ 
        pkgs <- r_repos_data_cast(pkgs = pkgs,
                                  verbose = verbose)
       
    }
    #### Add DESRIPTION metadata ####
    if(isTRUE(add_descriptions)){
        meta_desc <- description_extract_multi(pkgs = unique(pkgs$package),
                                               nThread = nThread,
                                               verbose = verbose)
        pkgs <- data.table::merge.data.table(meta_desc,
                                             pkgs,
                                             all = TRUE,
                                             by="package")
    }
    return(pkgs)
}
