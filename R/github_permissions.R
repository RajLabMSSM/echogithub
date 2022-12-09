#' GitHub permissions
#'
#' Get permissions metadat on a GitHub repository.
#' @inheritParams github_files 
#' @return A \link[data.table]{data.table}.
#'
#' @export
#' @importFrom data.table as.data.table   
#' @importFrom gh gh gh_token
#' @examples
#' permissions <- github_permissions(owner="RajLabMSSM", 
#'                                   repo="echolocatoR")
github_permissions <- function(owner,
                               repo, 
                               token = gh::gh_token(),
                               verbose = TRUE) { 
    
    messager("Gathering permissions metadata for repo:",
             paste(owner,repo,sep="/"),
             v=verbose)
    dt <- github_metadata(owner = owner, 
                          repo = repo, 
                          token = token, 
                          verbose = verbose)
    return(dt$permissions[[1]])
}
