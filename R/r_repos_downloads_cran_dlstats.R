r_repos_downloads_cran_dlstats <- function(pkgs,
                                           nThread=1,
                                           use_cache=TRUE,
                                           min_batch_size=10,
                                           verbose=TRUE){
    requireNamespace("dlstats")
    #### Split into batches ####
    batches <- split_batches(v = pkgs$package,
                             n_batches = max(nThread,min_batch_size)) 
    #### Get downloads data for each batch #### 
    parallel::mclapply(seq_len(length(batches)),
                               function(i){
                           b <- batches[[i]]
                           messager(paste("Batch:",i,"/",length(batches)),
                                    parallel = TRUE,
                                    v=verbose)
                           dt <- dlstats::cran_stats(packages = b,
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
}