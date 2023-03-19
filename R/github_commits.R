#' GitHub commits
#'
#' Get metadata for all commits to a given GitHub repo.
#' @inheritParams github_files 
#' @inheritParams gh::gh
#' @return A nested list of metadata
#'
#' @export 
#' @importFrom gh gh gh_token
#' @examples
#' commits <- github_commits(owner="RajLabMSSM", 
#'                           repo="echolocatoR",
#'                           limit=100)
github_commits <- function(owner,
                           repo, 
                           token = gh::gh_token(),
                           .limit = Inf,
                           verbose = TRUE) {
    
    #devoptera::args2vars(github_commits)

    endpoint <- paste("https://api.github.com","repos",
                      owner,repo,"commits",sep="/")
    gh_response <- gh::gh(endpoint = endpoint,
                          .token = token,
                          .limit = .limit,
                          per_page = 100) 
    dt <- gh_to_dt(gh_response)
    return(dt)
}
