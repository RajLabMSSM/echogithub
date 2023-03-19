#' GitHub user events
#' 
#' Return all events (e.g. commits, pull requests, comments, etc.) 
#' for a GitHub user across all repositories.
#' @param error Throw an error when the GitHub repository does not exist 
#' (default: \code{TRUE}).
#' @param as_datatable Return query results as a \link[data.table]{data.table} 
#' instead of a nested list.
#' @param public_only Only include public events. 
#' To include private events as well,set \code{public_only=FALSE} and provide a 
#' valid GitHub \code{token}.
#' @inheritParams github_files
#' @inheritParams gh::gh
#' 
#' @export
#' @importFrom gh gh gh_token
#' @importFrom data.table :=
#' @importFrom methods is
#' @examples
#' events <- github_user_events(owner="bschilder", .limit=100)
github_user_events <- function(owner,  
                               error = TRUE,
                               token = gh::gh_token(),
                               .limit = Inf,
                               public_only = TRUE,
                               as_datatable = TRUE,
                               verbose = TRUE){
    owner_repo <- repo <- NULL;
    
    endpoint <- paste("https://api.github.com","users",
                      owner,if(isTRUE(public_only)){
                          "events/public"
                      } else {
                          "events"
                      },sep="/") 
    res <- tryCatch({  
        gh::gh(endpoint = endpoint,
               .token = token,
               .limit = .limit,
               per_page = 100) 
    }, error = function(e){return(e)})  
    #### Stop if the repo doesn't exist #####
    if(methods::is(res,"github_error")){
        if(isTRUE(error)){
            stop(res)
        } else {
            messager("Cannot find GitHub events for owner",owner,
                     "Returning NULL.",v=verbose)
            return(NULL)
        }
    } 
    dt <- gh_to_dt(gh_response = res,
                   verbose = verbose)
    dt[,owner_repo:=mapply(repo, FUN=function(x){x$name})]
    dt[,owner:=owner]
    messager("Returning",formatC(nrow(dt),big.mark = ","),
             "valid GitHub events for owner:",owner,v=verbose)
    return(dt)
}
