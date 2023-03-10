description_extract_multi <- function(pkgs,
                                      nThread=1,
                                      fields=NULL,
                                      verbose=TRUE){
    requireNamespace("parallel")
    repo <- package <- NULL;
    
    pkgs <- check_pkgs(pkgs = pkgs)    
    if(length(pkgs$package)==0){
        messager("pkgs is an empty data.table. Returning NULL.",v=verbose)
    }
    meta_desc <- parallel::mclapply(stats::setNames(pkgs$package,
                                                    pkgs$package), 
                        function(p){
                            tryCatch({
                                description_extract(ref = p,
                                                    fields = fields,
                                                    as_datatable = TRUE,
                                                    verbose = FALSE)
                            }, error=function(e){messager(e,v=verbose);NULL})
                        }, mc.cores = nThread) |> 
        data.table::rbindlist(fill = TRUE, use.names = TRUE, idcol = "package")   
    if(nrow(meta_desc)==0){
        messager("WARNING: No metadata retrieved from any DESCRIPTION files.",
                 v=verbose)
    } else {
        if("repo" %in% names(meta_desc)) data.table::setkeyv(meta_desc,"repo")
    } 
    return(meta_desc)
}
