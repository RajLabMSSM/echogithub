#' List files in GitHub repo: via \pkg{gh}
#'
#' Search for files within a public GitHub repository and return their paths.
#' @inheritParams github_files
#' @source \href{https://docs.github.com/en/rest/overview/endpoints-available-for-github-apps}{
#' GitHub endpoints}
#' @source \href{https://docs.github.com/en/rest/git/trees#get-a-tree-recursively}{
#' GitHub trees API}
#' @returns A \link[data.table]{data.table} fo file paths. 
#'
#' @keywords internal
#' @importFrom gh gh gh_token
#' @importFrom data.table :=
github_files_gh <- function(owner,
                            repo,
                            branch = c("master","main"),
                            token = gh::gh_token(), 
                            verbose = TRUE) {
    path <- link <- NULL;
    
    if(is.null(branch)) {
        messager("branch is NULL. Returning NULL.",v=verbose)
        return(NULL)
    }
    endpoint <- paste(
        "https://api.github.com/repos", owner, repo,
        paste0("git/trees/", branch[1], "?recursive=1"),
        sep="/"
    )
    gh_response <- gh::gh(endpoint = endpoint,
                          .token = token,
                          per_page = 100) 
    dt <- gh_to_dt(gh_response$tree)
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
