#' GitHub code
#' 
#' Search for GitHub code using specific queries.
#' @source 
#' \href{https://docs.github.com/en/search-github/searching-on-github/searching-code}{
#' GitHub Docs: Searching code}
#' @inheritParams github_files
#' @inheritParams gh::gh
#' 
#' @export
#' @importFrom gh gh gh_token
#' @importFrom data.table :=
#' @importFrom methods is
#' @examples
#' \dontrun{
#' ## easily exceeds API limit
#' repos <- github_code(query="Package path:DESCRIPTION", .limit=5)
#' }
github_code <- function(query,
                        token = gh::gh_token(),
                        .limit = Inf,
                        verbose = TRUE){
    owner_repo <- repo <- NULL;
    
    endpoint <- "https://api.github.com/search/code"
    res <-  gh::gh(endpoint,
                   .token = token,
                   .limit = .limit,
                   q = query,
                   #### only beta version supports full-on regex ####
                   # q = "/(?-i)Package/ path:/(?-i)^DESCRIPTION$/", 
                   per_page = 100)  
    dt <- gh_to_dt(gh_response = res$items,
                   verbose = verbose)
    dt[,owner_repo:=mapply(repo, FUN=function(x){x$name})] 
    messager("Returning",formatC(nrow(dt),big.mark = ","),
             "GitHub code files.",v=verbose)
    return(dt)
}
 