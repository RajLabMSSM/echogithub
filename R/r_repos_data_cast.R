r_repos_data_cast <- function(pkgs,
                              verbose=TRUE){
    dummy <- NULL;
    
    if("downloads" %in% names(pkgs)){
        messager(
            "Casting data: numbers represent downloads in each r_repo.",
            v=verbose)
        pkgs <- data.table::dcast.data.table(
            pkgs, 
            formula = "package + installed ~ r_repo",
            value.var = "downloads")
    } else { 
        messager(
            "Casting data: present=TRUE and absent=FALSE in each r_repo.",
            v=verbose)
        r_repo_vars <- unique(pkgs$r_repo)
        pkgs[,dummy:=TRUE]
        pkgs <- data.table::dcast.data.table(
            pkgs, 
            formula = "package + installed ~ r_repo", 
            fun.aggregate = length,
            value.var = "dummy") 
        pkgs[,(r_repo_vars):=lapply(.SD, as.logical),.SDcols=r_repo_vars]
    }
    return(pkgs)
}
