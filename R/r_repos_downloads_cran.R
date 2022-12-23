r_repos_downloads_cran <- function(pkgs,
                                   nThread=1,
                                   use_cache=TRUE,
                                   min_batch_size=10,
                                   method=c("cranlogs","dlstats"),
                                   agg=TRUE,
                                   verbose=TRUE){
    requireNamespace("parallel")
    r_repo <- downloads <- NULL;
    
    method <- tolower(method)[1]
    messager("Gathering CRAN downloads data with",
             paste0("method=",shQuote(method)),v=verbose)
    null_dt <- data.table::data.table(package=pkgs$package,
                                      downloads=NA)
    pkgs <- pkgs[r_repo=="CRAN",]
    if(nrow(pkgs)==0) return(null_dt)
    t1 <- Sys.time()
    if(method=="dlstats"){
        cran <- r_repos_downloads_cran_dlstats(pkgs=pkgs,
                                               nThread=nThread,
                                               use_cache=use_cache,
                                               min_batch_size=min_batch_size,
                                               verbose=verbose)
    } else {
        cran <- r_repos_downloads_cran_cranlogs(pkgs = pkgs, 
                                                nThread = nThread,
                                                grand_total = FALSE,
                                                verbose = verbose)
    }
    #### Aggregate ####
    if(isTRUE(agg)){
        cran <- cran[,list(downloads=sum(downloads)), by="package"]    
    }
    #### Report ####
    report_time(start = t1, verbose = verbose)
    #### Check ####
    if(nrow(cran)==0) {
        messager("No downloads data retrieved for any CRAN packages.",v=verbose)
    }
    return(cran)
}
