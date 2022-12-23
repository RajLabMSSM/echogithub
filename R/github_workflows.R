#' GitHub workflows
#' 
#' Get metadata on workflows that have been run via GitHub Actions.
#' This includes the "conclusion" columns showing whether 
#' the workflow is currently passing.
#' @param latest_only Only return the latest run of each workflow.
#' @param workflows Select which workflows to return metadata for.
#' @inheritParams github_files
#' @returns \link[data.table]{data.table} containing workflow metadata.
#' 
#' @export
#' @importFrom gh gh gh_token
#' @importFrom data.table .SD rbindlist setnames
#' @examples 
#' dt <- github_workflows(owner="neurogenomics", repo="orthogene")
github_workflows <- function(owner,
                             repo,
                             token = gh::gh_token(),
                             latest_only = TRUE,
                             workflows = NULL,
                             verbose = TRUE){
    
    conclusion <- name <- NULL;
    
    messager("Searching for GitHub Actions in:",paste(owner,repo,sep="/"),
             v=verbose)
    ##### Check inputs ####
    out <- check_owner_repo(owner = owner, 
                            repo = repo, 
                            verbose = verbose)
    owner <- out$owner
    repo <- out$repo
    #### Iterate over repos ####
    wdt <- lapply(seq_len(length(repo)), function(i){
        endpoint <- paste("https://api.github.com/repos",
                          owner[i],repo[i],"actions/runs",sep="/")
        gh_response <- gh::gh(endpoint = endpoint,
                              .token = token,
                              per_page = 100)
        dt <- gh_to_dt(gh_response$workflow_runs) 
        dt <- cbind(owner=owner[i], repo=repo[i], dt)
        #### Filter ####
        if(isTRUE(latest_only)){
            dt <- dt[conclusion!="cancelled",.SD[1], by="name"]
        }
        if(!is.null(workflows)){
            dt <- dt[name %in% workflows,]
        }
        return(dt)
    }) |> data.table::rbindlist(fill=TRUE)
    #### Check rows ####
    if(nrow(wdt)==0){
        messager("No matching workflows identified.",v=verbose)
    } else {
        data.table::setnames(wdt,"name","workflow")
    }
  return(wdt)
}
