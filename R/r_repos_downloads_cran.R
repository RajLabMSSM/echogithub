r_repos_downloads_cran <- function(pkgs,
                                   use_cache=TRUE,
                                   verbose=TRUE){
    r_repo <- NULL;
    
    messager("Gathering CRAN downloads data.",v=verbose)
    null_dt <- data.table::data.table(package=pkgs$package,
                                      downloads=NA)
    pkgs <- pkgs[r_repo=="CRAN",]
    if(nrow(pkgs)==0) return(null_dt)
    cran <- (dlstats::cran_stats(packages = pkgs$package,
                                 use_cache = use_cache) |>
                 data.table::data.table()
    )
    return(cran)
}