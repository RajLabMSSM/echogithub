#' GitHub dependents
#'
#' Get all GitHub repositories that are dependent on the target
#'  GitHub repository.
#' \emph{NOTE: }
#' The \href{https://docs.github.com/en/rest/dependency-graph}{GitHub API} 
#'  does not currently support getting deps from repo, 
#'  so need to use webscraping instead.
#' @source \href{https://github.com/nvuillam/github-dependents-info}{
#' github-dependents-info (python)}
#' @source \href{https://github.com/manusa/github-dependents-scraper}{
#' github-dependents-scraper (CLI)}
#' @source \href{https://chat.openai.com/chat}{
#' Made with a little help from ChatGPT}
#' @param max_pages The maximum number of pages to extract before stopping.
#' @inheritParams github_files 
#' @return A \link[data.table]{data.table}.
#'
#' @export
#' @importFrom data.table data.table := 
#' @importFrom stringr str_split
#' @examples
#' dt <- github_dependents(owner = "neurogenomics", 
#'                         repo = "rworkflows")
github_dependents <- function(owner,
                              repo, 
                              token = gh::gh_token(),
                              max_pages = 1000,
                              verbose = TRUE) {
    
    # devoptera::args2vars(github_dependents)  
    
    messager("Searching for dependents of:",paste(owner,repo,sep="/"),
             v=verbose) 
    
    #### Method 1: JSON file ####
    # URL <- paste0("https://github.com/", owner,"/",repo, "/dependency-graph/sbom")
    # j <- jsonlite::fromJSON("~/Downloads/rworkflows_neurogenomics_b017b7a1aeda0026dda330b01cb798ddb5f1d264.json")
    # j$packages
    
    #### Method 2: Webscraping ####
    all_dat <- github_dependents_scrape(owner = owner,
                                        repo = repo, 
                                        token = token,
                                        max_pages = max_pages,
                                        verbose = verbose)
    #### Report ####
    messager("Found",formatC(nrow(all_dat),big.mark = ","),
             "dependents.",v=verbose)
    #### Return ####    
    return(all_dat)
}
