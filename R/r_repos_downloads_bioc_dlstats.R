r_repos_downloads_bioc_dlstats <- function(pkgs,
                                           use_cache=TRUE,
                                           nThread=1,
                                           min_batch_size=10, 
                                           verbose=TRUE){
    requireNamespace("parallel")
    requireNamespace("dlstats")
    
    batches <- split_batches(v = pkgs$package,
                             n_batches = max(nThread,min_batch_size)) 
    #### Get downloads data for each batch #### 
    bioc <- parallel::mclapply(seq_len(length(batches)),
                               function(i){
                       b <- batches[[i]]
                       messager(paste("Batch:",i,"/",length(batches)),
                                parallel = TRUE,
                                v=verbose)
                       dt <- dlstats::bioc_stats(packages = b,
                                                 use_cache = use_cache) |>
                           data.table::data.table()
                       messager(paste(
                           "Data for",formatC(nrow(dt),big.mark = ","),
                           "packages retrieved."
                       ),
                       parallel=TRUE,
                       v=verbose)
                       return(dt)
                   }, mc.cores = nThread) |> 
        data.table::rbindlist(fill=TRUE)
    if(nrow(bioc)>0){
        bioc <- bioc |> 
            data.table::setnames("Package","package") |>
            data.table::setnames(c("Nb_of_distinct_IPs","Nb_of_downloads"),
                                 c("downloads_unique","downloads"),
                                 skip_absent = TRUE)
    }
    return(bioc)
}
