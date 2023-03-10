#' GitHub metadata
#'
#' Get metadata on a GitHub repository.
#' @param add_traffic Add traffic metadata 
#' with \link[echogithub]{github_traffic}.
#' @inheritParams github_files 
#' @return A \link[data.table]{data.table}.
#'
#' @export
#' @importFrom data.table as.data.table   
#' @importFrom gh gh gh_token
#' @examples
#' dt <- github_metadata(owner="RajLabMSSM", 
#'                       repo="echolocatoR")
github_metadata <- function(owner,
                            repo, 
                            add_traffic = FALSE, 
                            token = gh::gh_token(),
                            verbose = TRUE) { 
    
    #devoptera::args2vars(github_metadata)
    if(is.null(owner) || is.na(owner)){
        messager("owner is required to collect github_metadata. Skipping.",
                 v=verbose)
        return(NULL)
    }
    if(is.null(repo) || is.na(repo)){
        messager("repo is required to collect github_metadata. Skipping.",
                 v=verbose)
        return(NULL)
    }
    messager(paste0(
        "Gathering metadata",
        if(isTRUE(add_traffic))" (with traffic data)" else NULL
    ),"for repo:",paste(owner,repo,sep="/"),v=verbose)
    endpoint <- paste("https://api.github.com","repos",
                      owner,repo,sep="/")
    gh_response <- gh::gh(endpoint = endpoint,
                          .token = token, 
                          per_page = 100)
    dt <- cbind(
        owner=owner,
        repo=repo,
        data.table::as.data.table(gh_response[!sapply(gh_response, is.list)])   
    )
    for(x in names(gh_response[sapply(gh_response, is.list)])){
        if(x %in% c("owner","repo")){
            x2 <- paste(x,"info",sep="_")
        }else {
            x2 <- x
        }
        dt[[x2]] <- list(gh_response[[x]])
    }
    #### Add traffic metadata ####
    if(isTRUE(add_traffic)){
        traffic <- github_traffic(owner = owner,
                                  repo = repo, 
                                  token = token,
                                  verbose = FALSE) 
        if(!is.null(traffic)){
            dt <- merge(dt,traffic,by=c("owner","repo"))
        } 
    }
    return(dt)
}
