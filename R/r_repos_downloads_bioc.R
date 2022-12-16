r_repos_downloads_bioc <- function(pkgs,
                                   use_cache=TRUE,
                                   verbose=TRUE){
    r_repo <- NULL;
    
    messager("Gathering Bioc downloads data.",v=verbose)
    null_dt <- data.table::data.table(package=pkgs$package,
                                      downloads=NA)
    pkgs <- pkgs[r_repo=="Bioc",]
    if(nrow(pkgs)==0) return(null_dt)
    bioc <- (dlstats::bioc_stats(packages = pkgs$package,
                                 use_cache = use_cache) |>
                 data.table::data.table() 
    )
    if(nrow(bioc)>0){
        bioc <- bioc |>
            data.table::setnames(c("Nb_of_distinct_IPs","Nb_of_downloads"),
                                 c("downloads_unique","downloads"),
                                 skip_absent = TRUE)
    } else{
        bioc <- null_dt
    }
    return(bioc)
}
