r_repos_downloads_bioc <- function(pkgs,
                                   use_cache=TRUE, 
                                   min_batch_size=10,
                                   method=c("biocpkgtools",
                                            "dlstats"),
                                   nThread=1,
                                   verbose=TRUE){
    
    r_repo <- NULL;
    
    method <- tolower(method)[1]
    messager("Gathering Bioc downloads data with",
             paste0("method=",shQuote(method),"."),v=verbose)
    null_dt <- data.table::data.table(package=pkgs$package,
                                      downloads=NA)
    pkgs_bioc <- pkgs[r_repo=="Bioc",]
    if(nrow(pkgs_bioc)==0) return(null_dt) 
    t1 <- Sys.time()
    if(method=="dlstats"){
        bioc <- r_repos_downloads_bioc_dlstats(pkgs=pkgs_bioc,
                                               use_cache=use_cache,
                                               nThread=nThread,
                                               min_batch_size=min_batch_size, 
                                               verbose=verbose)
    } else if(method=="biocpkgtools"){
        bioc <- r_repos_downloads_bioc_biocpkgtools(pkgs = pkgs_bioc)
    }  
    #### Report ####
    report_time(start = t1, verbose = verbose)
    #### Check ####
    if(nrow(bioc)==0){ 
        messager("No downloads data retrieved for any Bioc packages.",v=verbose)
        bioc <- null_dt
    }
    return(bioc)
}
