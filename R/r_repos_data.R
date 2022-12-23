#' R repositories data
#' 
#' Gather data on which repositories R packages are distributed through
#'  (e.g. CRAN, Bioc, rOpenSci, and/or GitHub).
#' @param include A subset of packages to return data for.
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
#' #### All packages ####
#' pkgs1 <- r_repos_data()
#' #### Specific packages ####
#' #### Add extra data ####
#' pkgs3 <- r_repos_data(include="echogithub",
#'                       which = r_repos_opts(exclude = NULL),
#'                       add_downloads = TRUE,
#'                       add_descriptions = TRUE,
#'                       add_github = TRUE,
#'                       cast=TRUE)
r_repos_data <- function(include=NULL,
                         add_downloads=FALSE,
                         add_descriptions=FALSE,
                         add_github=FALSE,
                         which=r_repos_opts(),
                         cast=FALSE,
                         version=NULL,
                         nThread=1,
                         verbose=TRUE){
    # templateR:::source_all()
    # templateR:::args2vars(r_repos_data) 
    installed <- package <- NULL;
    
    if(isTRUE(add_github) && 
       isFALSE(add_descriptions)){
        messager("add_descriptions must =TRUE when add_github=TRUE.",
                 "Setting add_descriptions=TRUE.",
                 v=verbose)
        add_descriptions <- TRUE
    }
    #### List all R packages ####
    pkgs <- r_repos_list(which = which, 
                         include = include,
                         version = version,
                         verbose = verbose) 
    #### Add downloads ####
    if(isTRUE(add_downloads)){
        pkgs <- r_repos_downloads(pkgs = pkgs,
                                  which = which,
                                  nThread = nThread,
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
        by <- base::intersect(names(meta_desc),names(pkgs))
        pkgs <- data.table::merge.data.table(meta_desc,
                                             pkgs,
                                             all = TRUE,
                                             by=by)
    }
    #### Add GitHub metadata ####
    #### Get repo metadata ####
    if(isTRUE(add_github)){
        if(!all(c("owner","repo") %in% names(pkgs))){
            messager("Skipping add_github, as no owner/repo data available.",
                     v=verbose)
        } else {
            meta_gh <- lapply(seq_len(nrow(pkgs)), function(i){
                tryCatch({
                    echogithub::github_metadata(owner = pkgs[i,]$owner,
                                                repo = pkgs[i,]$repo,
                                                add_traffic = TRUE,
                                                verbose = verbose)
                }, error=function(e){messager(e,v=verbose);NULL})
            }) |> data.table::rbindlist(fill = TRUE)
            by <- base::intersect(names(meta_gh),names(pkgs))
            pkgs <- data.table::merge.data.table(meta_gh,
                                                 pkgs,
                                                 all = TRUE,
                                                 by=by)
        } 
    }
    return(pkgs)
}
