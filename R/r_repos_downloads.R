#' Get downloads data from CRAN/Bioconductor/GitHub
#' 
#' Get the total number of downloads for each R package in 
#' CRAN, Bioconductor, and/or GitHub.
#' @param pkgs Output from \link[echogithub]{r_repos_data}.
#' @param verbose Print messages.
#' @inheritParams r_repos
#' @inheritParams dlstats::cran_stats 
#' 
#' @export
#' @importFrom data.table rbindlist data.table setnames dcast merge.data.table
#' @importFrom data.table :=
#' @examples 
#' pkgs <- r_repos_data()[r_repo=="CRAN",][seq_len(5),]
#' pkgs2 <- r_repos_downloads(pkgs = pkgs)
r_repos_downloads <- function(pkgs,
                              which=r_repos_opts(),
                              use_cache=TRUE,
                              verbose=TRUE){ 
    
    requireNamespace("dlstats")
    downloads <- NULL;
    
    #### Check args ####
    pkgs <- check_pkgs(pkgs = pkgs)    
    if(all(is.null(which))) return(NULL)
    which <- tolower(which)
    res <- list()
    #### GitHub ####
    if("github" %in% which){
        res[["GitHub"]] <- r_repos_downloads_github(pkgs=pkgs,
                                                    fields=c("Package",
                                                             "owner",
                                                             "repo"),
                                                    verbose=verbose)         
    }
    #### CRAN ####
    if("cran" %in% which){
        res[["CRAN"]] <- r_repos_downloads_cran(pkgs=pkgs,
                                                use_cache=use_cache,
                                                verbose=verbose)
    }  
    #### Bioc ####
    if("bioc" %in% which){
        res[["Bioc"]] <- r_repos_downloads_bioc(pkgs=pkgs,
                                                use_cache=use_cache,
                                                verbose=verbose)
    }
    #### rbind ####    
    dat <- data.table::rbindlist(res, 
                                 fill = TRUE, 
                                 use.names = TRUE, 
                                 idcol = "r_repo") 
    #### Aggregate and cast data ####
    dat_agg <- dat[,list(downloads=sum(downloads)),
               by=c("r_repo","package")]
    #### Merge with input data ####
    by <- c("package","r_repo")
    
    pkgs <- data.table::merge.data.table(pkgs,dat_agg,
                                         by=by[by %in% names(pkgs)],
                                         all.x = TRUE)
    return(pkgs) 
}
