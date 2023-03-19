#' GitHub repositories
#' 
#' Search for GitHub repositories using specific queries.
#' @source 
#' \href{https://docs.github.com/en/rest/search#search-repositories}{
#' GitHub Docs: Search repositories}
#' @source
#' \href{https://docs.github.com/en/rest/search#constructing-a-search-query}{
#' GitHub Docs: Constructing a search query}
#' @source 
#' \href{https://docs.github.com/en/search-github/searching-on-github/searching-for-repositories}{
#' Searching GitHub repos}
#' @source 
#' \href{https://github.com/orgs/community/discussions/9759}{
#' Case-sensitive GitHub searches}
#' @source \href{https://github.com/r-lib/gh/pull/136}{
#' Examples of using gh to search repositories}
#' @inheritParams github_files
#' @inheritParams gh::gh
#' 
#' @export
#' @importFrom gh gh gh_token
#' @importFrom data.table :=
#' @importFrom methods is
#' @examples
#' repos <- github_repositories(query="language:r", .limit=100)
github_repositories <- function(query,
                                token = gh::gh_token(),
                                .limit = Inf,
                                verbose = TRUE){
    owner_repo <- repo <- NULL;
    
    endpoint <- "https://api.github.com/search/repositories"
    res <-  gh::gh(endpoint,
                   .token = token,
                   .limit = .limit,
                   per_page = 100,
                   q = paste(query, collapse = " ")
                   )  
    dt <- gh_to_dt(gh_response = res$items,
                   verbose = verbose)
    dt[,owner_repo:=mapply(repo, FUN=function(x){x$name})] 
    messager("Returning",formatC(nrow(dt),big.mark = ","),
             "GitHub repositories.",v=verbose)
    return(dt)
}

# make_query <- function(query, 
#                        sep = ":", 
#                        collapse = " ",
#                        encode=FALSE) {
#     txt <- paste(names(query),
#           query,
#           sep = sep, collapse = collapse)
#     if(encode) utils::URLencode(txt, reserved=TRUE) else {txt}
# }
# endpoint <- paste0("https://api.github.com/",
#                   "search?q=", make_query(query, encode = TRUE))
# url <- httr::modify_url("https://api.github.com",
#                         path = "search/",
#                         query = list(q = make_query(query)))
# req <- httr::GET(url = url)
# cont <- httr::content(req)
# dt <- gh_to_dt(gh_response = cont$items,
#                verbose = verbose)
