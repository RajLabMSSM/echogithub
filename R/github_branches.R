#' GitHub branches
#'
#' List all branches for a given GitHub repository.
#' @param owner Owner of the GitHub repository.
#' If \code{NULL}, will automatically try to infer the owner
#'  name from the \emph{DESCRIPTION file}
#'  (assuming you're working directory is a local R package repo).
#' @param repo GitHub repository name.
#' If \code{NULL}, will automatically try to infer the repo name
#'  name from the \emph{DESCRIPTION file}
#'  (assuming you're working directory is a local R package repo).
#' @param branch [Optional] If \code{branch} is supplied
#' (as a character vector of one or more branch names),
#' will check to see if that branch exists. If it does, only that branch will
#' be returned. If it doesn't, an error will be thrown.
#' @param master_or_main  If \code{branch} is supplied and
#'  is either \code{"master"} or \code{"main"},
#' automatically interpret "master" and "main" as synonymous and return
#' whichever branch exists.
#' @param as_datatable Return the results as a \link[data.table]{data.table}
#' (\code{TRUE}), or as a character vector of branch names
#'  (default: \code{FALSE}).
#' @param error Throw an error when no matching branches are fond.
#' @inheritParams github_files
#' @inheritParams description_extract
#' @returns Character vector or \link[data.table]{data.table} of branches.
#'
#' @export
#' @importFrom gh gh_token gh
#' @examples
#' branches <- github_branches(owner="RajLabMSSM", repo="echolocatoR")
github_branches <- function(owner = NULL,
                            repo = NULL,
                            branch = NULL,
                            master_or_main = TRUE,
                            as_datatable = FALSE,
                            token = gh::gh_token(),
                            desc_file = NULL,
                            error = FALSE,
                            verbose = TRUE){
    name <- NULL;

    out <- infer_owner_repo(owner = owner,
                            repo = repo,
                            desc_file = desc_file,
                            verbose = verbose)
    owner <- out$owner
    repo <- out$repo
    #### Search branches ####
    messager("Searching for all branches in:",paste(owner,repo,sep="/"),
             v=verbose)
    endpoint <- paste(
        "https://api.github.com/repos",owner,repo,"branches",
        sep="/"
    )
    page <- 1
    repeat {
      # Keep iterating pages until we find the branch or run out of pages
        gh_response <- gh::gh(endpoint = endpoint,
                              .token = token,
                              per_page = 100,
                              page = page)
        if(length(gh_response) == 0) break
        dt <- gh_to_dt(gh_response)
        dt <- cbind(owner=owner, repo=repo, dt)
        #### Filter branches ####
        if(!is.null(branch)){
            #### Detect synonymous branches ####
            if(isTRUE(master_or_main) &&
               any(c("master","main") %in% branch)){
                   branch <- unique(c("master","main",branch))
               }
            dt <- dt[name %in% branch,]
        }
        if(nrow(dt)>0) break
        page <- page + 1
    }

    #### Report ####
    if(nrow(dt)>0){
        messager(paste0(
            formatC(nrow(dt)),if(!is.null(branch)){" matching"}else{NULL},
            " branch(es) found:"
        ), paste("\n -",dt$name,collapse = ""),v=verbose)
    } else {
        stp <- paste("0 matching branches found.")
        if(isTRUE(error)) {
            stop(stp)
        } else {
            messager("WARNING:",stp,"Returning NULL.",v=verbose)
            return(NULL)
        }
    }
    #### Return ####
    if(isTRUE(as_datatable)){
        return(dt)
    } else {
        return(dt$name)
    }
}
