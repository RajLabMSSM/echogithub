#' GitHub Pages website
#' 
#' Return the \href{https://pages.github.com/}{GitHub Pages} website URL 
#' for a given repository, if one exists.
#' @param error Throw an error when the GitHub repository does not exist 
#' (default: \code{TRUE}).
#' @inheritParams github_files
#' 
#' @export
#' @importFrom gh gh gh_token
#' @examples 
#' link <- github_pages(owner="RajLabMSSM", repo="echolocatoR")
github_pages <- function(owner, 
                         repo,
                         error = TRUE,
                         token = gh::gh_token(),
                         verbose = TRUE){
    
    endpoint <- paste("https://api.github.com","repos",
                      owner,repo,"pages",sep="/")
    res <- tryCatch({
        gh::gh(endpoint = endpoint,
               .token = token,
               per_page = 100)
    }, error = function(e){return(e)})
    #### Stop if the repo doesn't exist #####
    if(methods::is(res,"github_error")){
        if(isTRUE(error)){
            stop(res)
        } else {
            messager("Cannot find GitHub Pages URL for repo",
                     paste0(owner,"/",repo,"."),
                     "Returning NULL.",v=verbose)
            return(NULL)
        }
    }
    messager("Returning valid GitHub Pages URL for repo:",
             paste0(owner,"/",repo,"."),v=verbose)
    return(res$html_url)
}
