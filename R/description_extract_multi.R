description_extract_multi <- function(pkgs,
                                      nThread=1,
                                      verbose=TRUE){
    requireNamespace("parallel")
    
    pkgs <- check_pkgs(pkgs = pkgs)    
    meta_desc <- parallel::mclapply(pkgs$package, 
                        function(p){
                            tryCatch({
                                description_extract(repo = p,
                                                    fields = NULL,
                                                    as_datatable = TRUE,
                                                    verbose = FALSE)
                            }, error=function(e){messager(e,v=verbose);NULL})
                        }, mc.cores = nThread) |> 
        data.table::rbindlist(fill = TRUE) |>
        data.table::setnames("Package","package",
                             skip_absent = TRUE) 
    if(nrow(meta_desc)==0){
        messager("WARNING: No metadata retrieved from any DESCRIPTION files.",
                 v=verbose)
    } else {
        data.table::setkeyv(meta_desc,"package")
    }
    return(meta_desc)
}
