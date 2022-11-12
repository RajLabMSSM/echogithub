#' List files in GitHub repo: via \pkg{httr}
#'
#' Search for files within a public GitHub repository and return their paths. 
#' @inheritParams github_files
#' @inheritParams httr::timeout
#' @returns A \link[data.table]{data.table} fo file paths. 
#'
#' @keywords internal
#' @importFrom data.table data.table :=
github_files_httr <- function(owner,
                              repo,
                              branch = c("main", "master"),
                              seconds = 5*60, 
                              verbose = TRUE) {
    requireNamespace("httr")
    path <- link <- NULL;
    
    #### Setup API ####
    repo_api <- paste(
        "https://api.github.com/repos", owner, repo,
        paste0("git/trees/", branch[1], "?recursive=1"),
        sep="/"
    )
    #### Search ####
    httr::timeout(seconds = seconds)
    req <- httr::GET(repo_api)
    httr::message_for_status(req)
    filelist <- unlist(lapply(httr::content(req)$tree, "[", "path"),
        use.names = FALSE
    ) 
    #### Format as data.table ####
    dt <- data.table::data.table(
        path=filelist
    )
    dt[,link:=paste("https://github.com",owner,repo,
                    "blob/master",path,sep="/")]
    #### Report ####
    messager(paste(
        formatC(nrow(dt),big.mark = ","),
        "files found in GitHub repo:",
        file.path(owner, repo)
    ), v = verbose)
    #### Return ####
    return(dt) 
}
