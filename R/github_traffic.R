#' GitHub traffic
#'
#' Get traffic info on a target GitHub repository.
#' @param na_fill Value to fill NAs with.
#' @inheritParams github_files 
#' @inheritParams gh::gh
#' @return A \link[data.table]{data.table}.
#'
#' @export
#' @importFrom data.table data.table setnafill
#' @importFrom gh gh gh_token
#' @examples
#' dt <- github_traffic(owner="RajLabMSSM", 
#'                      repo="echolocatoR")
github_traffic <- function(owner,
                           repo, 
                           token = gh::gh_token(),
                           .limit = Inf,
                           na_fill = NULL,
                           verbose = TRUE) {
    
    #devoptera::args2vars(github_traffic)
    
    #### Check permissions ####
    ## Must have push access to repository
    permissions <- github_permissions(owner = owner,
                                      repo = repo, 
                                      token = token, 
                                      verbose = verbose)
    if(!isTRUE(permissions$push)){
        messager("WARNING:",
                 "Must have push access to repository to get traffic metadata.",
                 "Returning NULL.",v=verbose)
        return(NULL)
    } 
    messager("Gathering traffic metadata for repo:",paste(owner,repo,sep="/"),
             v=verbose) 
    #### clones ####
    endpoint <- paste("https://api.github.com","repos",
                      owner,repo,"traffic","clones",sep="/")
    ghr_clones <- gh::gh(endpoint = endpoint,
                          .token = token,
                          .limit = .limit,
                          per_page = 100)
    clones <- data.table::data.table(
        clones_count=ghr_clones$count,
        clones_uniques=ghr_clones$uniques,
        clones=list(ghr_clones$clones))
    
    #### views ####
    endpoint <- paste("https://api.github.com","repos",
                      owner,repo,"traffic","views",sep="/")
    ghr_views <- gh::gh(endpoint = endpoint,
                          .token = token,
                          .limit = Inf,
                          per_page = 100)
    views <- data.table::data.table(
        views_count=ghr_views$count,
        views_uniques=ghr_views$uniques,
        views=list(ghr_views$views))
    #### Bind together ####
    dt <- cbind(owner = owner, 
                repo = repo,
                clones, views)
    
    #### Fill NAs ####
    if(!is.null(na_fill)){
        #### Must be numeric to use nafill ####
        cols <- c("clones_count","clones_uniques",
                  "views_count","views_uniques") 
        dt[,(cols):= lapply(.SD, as.integer), .SDcols = cols] 
        data.table::setnafill(x = dt,
                              type = "const",
                              cols = cols,
                              fill = na_fill) 
    }
    return(dt)
}
