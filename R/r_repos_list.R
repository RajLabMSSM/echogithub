r_repos_list <- function(which,
                         include=NULL,
                         version=NULL,
                         verbose=TRUE){ 
    
    package <- installed <- github_url <- NULL;
    
    which <- gsub("-","",tolower(which))
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
        requireNamespace("BiocManager")
        messager("Gathering R packages: Bioc",v=verbose)
        # *Note*: This only retrieves Bioc packages in the currently installed 
        # release of Bioconductor. Packages that are only in older versions of  
        # Bioc (and were later deprecated) will not be listed here. 
        ### This function gives all packages, including CRAN, Bioc,
        # and anything currently installed. 
        # bioc <- BiocManager::available()  
        ### This only gives Bioc packages ####
        
        if(is.null(version)||
           identical(version,base::version)) {
            version <- BiocManager::version()
        }
        repos <- suppressMessages(
            BiocManager::repositories(version = version)
        )
        repos <- repos[names(repos)!="CRAN"]
        bioc <- utils::available.packages(repos = repos) |> data.frame()
        # bioc <- BiocPkgTools::biocPkgList(version = version,
        #                                   repo = names(repos))
        res[["Bioc"]] <- data.table::data.table(package=rownames(bioc))
    } 
    #### rOpenSci ####
    if("ropensci" %in% which){
        requireNamespace("rvest")
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
        requireNamespace("githubinstall")
        messager("Gathering R packages: GitHub",v=verbose)
        # githubinstall::gh_update_package_list()
        github <- githubinstall::gh_list_packages() 
        gh_res <- data.table::data.table(package=github$package_name)
        ## Check for any that are indeed on github but not in githubinstall.
        missing_pkgs <- include[!include %in% unique(github$package_name)]
        if(length(missing_pkgs)>0){
            messager("Gathering R packages: GitHub+",v=verbose)
            d <- description_extract(refs = missing_pkgs,
                                     fields = c("Package","github_url"),
                                     as_datatable = TRUE,
                                     verbose = verbose)
            d <- d[is.character(github_url) & (!is.na(github_url)),]  
            if(nrow(d)>0){
                gh_res <- rbind(
                    gh_res,
                    data.table::data.table(package=d$package))
            }
        }
        res[["GitHub"]] <- gh_res
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
    #### Check if none were found ####
    if(nrow(pkgs)==0) stopper("No packages found.")
    #### Filter packages ####
    if(!is.null(include)) pkgs <- pkgs[package %in% include,]
    #### Add installed info ####
    pkgs[,installed:=package %in% rownames(utils::installed.packages())]
    return(pkgs)
}
