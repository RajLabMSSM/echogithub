#' GitHub dependents
#'
#' Get all GitHub repositories that are dependent on the target
#'  GitHub repository.
#' @inheritParams github_files 
#' @return A \link[data.table]{data.table}.
#'
#' @export
#' @importFrom data.table data.table 
#' @importFrom stringr str_split
#' @examples
#' dt <- github_dependents(owner = "neurogenomics", 
#'                         repo = "rworkflows")
github_dependents <- function(owner,
                              repo, 
                              token = gh::gh_token(),
                              verbose = TRUE) {
    # echoverseTemplate:::source_all()
    # echoverseTemplate:::args2vars(github_insights) 
    
    requireNamespace("rvest")
    ## NOTE: GitHub API does not currently support getting deps from repo, 
    ## so need to use webscraping instead.
    messager("Searching for dependents of:",paste(owner,repo,sep="/"),
             v=verbose)
    #### Get latest commit ####
    URL <- paste("https://github.com",owner,repo,"network/dependents",
                 sep = "/")
    html <- rvest::read_html(URL) 
    box_rows <- rvest::html_elements(html,".Box-row")
    if(length(box_rows)==0){
        messager("WARNING: No dependents could be found. Returning NULL.",
                 v=verbose)
        return(NULL)
    }
    dt <- (rvest::html_text2(box_rows)) |> 
        stringr::str_split(" / |\n|[ ]", simplify = TRUE) |> 
        data.table::data.table() |> 
        `colnames<-`(c("owner","repo","stargazers_count","forks_count"))
    dt <- cbind(target=paste(owner,repo,sep="/"),dt)
    #### Report ####
    messager("Found",formatC(nrow(dt),big.mark = ","),
             "dependents.",v=verbose)
    #### Return ####    
    return(dt)
}
