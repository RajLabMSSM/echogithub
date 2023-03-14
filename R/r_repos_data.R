#' R repositories data
#' 
#' Gather data on which repositories R packages are distributed through
#'  (e.g. CRAN, Bioc, rOpenSci, and/or GitHub).
#' @param include A subset of packages to return data for.
#' @param cast Cast the results to wide format
#'  so that each package only appears in one row.
#' @param add_hex Search for hex sticker URLs for each package.
#' If the link does not exist, returns \code{NA}.
#' @param nThread Number of threads to parallelise \code{add_descriptions} 
#' step across.
#' @param verbose Print messages.
#' @inheritParams r_repos
#' @inheritParams github_files
#' @inheritParams description_extract
#' @inheritParams BiocManager::repositories
#' @inheritParams rworkflows::get_hex
#' @returns data.table
#' 
#' @export
#' @importFrom utils installed.packages available.packages
#' @importFrom data.table merge.data.table := fcoalesce
#' @importFrom rworkflows get_hex
#' @examples 
#' #### All packages ####
#' pkgs1 <- r_repos_data()
#' #### Specific packages ####
#' #### Add extra data ####
#' pkgs2 <- r_repos_data(include=c("echogithub","echodeps","BiocManager"),
#'                       which = r_repos_opts(exclude = NULL),
#'                       add_downloads = TRUE,
#'                       add_descriptions = TRUE,
#'                       add_github = TRUE,
#'                       add_hex = TRUE,
#'                       cast = TRUE)
r_repos_data <- function(include=NULL,
                         add_downloads=FALSE,
                         add_descriptions=FALSE,
                         add_github=FALSE,
                         add_hex=FALSE,
                         hex_path="inst/hex/hex.png",
                         which=r_repos_opts(),
                         cast=FALSE,
                         fields=NULL,
                         version=NULL,
                         nThread=1,
                         token=gh::gh_token(),
                         verbose=TRUE){ 
    # devoptera::args2vars(r_repos_data, reassign = TRUE)
    package <- ref <- hex_url <- NULL;
    
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
        meta_desc <- description_extract(refs = unique(pkgs$package),
                                         fields = fields,
                                         as_datatable = TRUE,
                                         nThread = nThread,
                                         verbose = verbose)
        by <- base::intersect(names(meta_desc),names(pkgs))
        pkgs <- data.table::merge.data.table(meta_desc,
                                             pkgs,
                                             all = TRUE,
                                             by=by)
    }
    #### Add owner_repo ####
    pkgs <- add_owner_repo(dt = pkgs)
    #### Get repo metadata ####
    if(isTRUE(add_github)){
        if(!all(c("owner","repo") %in% names(pkgs))){
            messager("Skipping add_github, as no owner/repo data available.",
                     v=verbose)
        } else {
            meta_gh <- lapply(unique(pkgs$package),
                              function(p){
                tryCatch({
                    pkgs_p <- pkgs[package==p,][1,]
                    gm <- github_metadata(
                        owner = pkgs_p$owner,
                        repo = pkgs_p$repo,
                        add_traffic = FALSE,
                        token = token,
                        verbose = verbose)
                   if(is.null(gm)){
                       return(data.table::data.table(package=p))
                   } else {
                       gm$package <- p
                       return(gm)
                   }
                }, error=function(e){messager(e,v=verbose);NULL})
            }) |> data.table::rbindlist(fill = TRUE)
            #### Merge back with main data ####
            ## Need to do this carefully bc there's MANY columns in meta_gh,
            ## and some accidentalty merging a same-named columns can result 
            ## in rows with NAs.
            meta_gh <- add_owner_repo(dt = meta_gh)
            overlap <- intersect(names(meta_gh),names(pkgs))
            by <- "ref"
            overlap <- overlap[overlap!=by]
            pkgs <- data.table::merge.data.table(pkgs,
                                                 meta_gh[,-overlap, with=FALSE],
                                                 all = TRUE,
                                                 by = by)
        } 
    } 
    #### Add hex ####
    if(isTRUE(add_hex)){
        messager("Finding hex sticker URLs.",v=verbose)
        pkgs[,hex_url:= rworkflows::get_hex(refs = ref, 
                                            paths = NULL,
                                            add_html = FALSE,
                                            hex_path = hex_path,
                                            verbose = TRUE)]
        pkgs[,hex_url:=sapply(hex_url, function(h){if(is.null(h))NA else h})]
    }
    #### Return ####
    return(pkgs)
}
