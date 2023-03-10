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
#' dt <- github_dependencies(owner = "neurogenomics", 
#'                           repo = "rworkflows")
github_dependencies <- function(owner,
                                repo, 
                                token = gh::gh_token(),
                                verbose = TRUE) {
    
    #devoptera::args2vars(github_insights) 
    
    requireNamespace("rvest")
    type <- NULL;
    ## NOTE: GitHub API does not currently support getting deps from repo, 
    ## so need to use webscraping instead.
    messager("Searching for dependents of:",paste(owner,repo,sep="/"),
             v=verbose)
    #### Get latest commit ####
    URL <- paste("https://github.com",owner,repo,"network/dependencies",
                 sep = "/")
    html <- rvest::read_html(URL) 
    boxes <- rvest::html_elements(html,".Box")
    boxes <- boxes[rvest::html_attr(boxes,"class")=="Box mb-3"]
    dt <- lapply(boxes, function(box){
        #### Get workflow name ####
        workflow_url <- paste0("https://github.com",
                               (rvest::html_elements(box,".Box-header") |> 
                                    rvest::html_elements(".Link--primary") |>
                                    rvest::html_attr("href"))) 
        #### Get workflow dependencies ####  
        box_rows <- rvest::html_children(box) |>
            rvest::html_elements(".Box-row") 
        d <- lapply(box_rows, function(r){
            data.table::data.table(
                action = r |> 
                    rvest::html_elements("a") |> 
                    rvest::html_attr("href") |>
                    trimws(whitespace = "/"),
                action_url =  paste0("https://github.com",
                              r |> 
                                  rvest::html_elements("a") |> 
                                  rvest::html_attr("href")
                              ),
                subaction = r |>  
                    rvest::html_elements("small") |> 
                    rvest::html_text(), 
                type =  r |> 
                    rvest::html_elements("a") |> 
                    rvest::html_attr("data-hovercard-type"),
                count = r |>
                    rvest::html_elements(".d-flex") |>
                    rvest::html_elements("code") |>
                    rvest::html_text()
            )[type=="repository",][,-c("type")]
        }) |> 
            data.table::rbindlist(fill=TRUE) 
        cbind(
            target=paste(owner,repo,sep="/"),
            workflow=basename(workflow_url),
            workflow_url=workflow_url,
            d)  
    }) |> data.table::rbindlist(fill = TRUE) 
    #### Add owner/repo for each action ####
    dt <- cbind(dt,
          data.table::data.table(
              stringr::str_split(dt$action,"/", simplify = TRUE)
          )|> `colnames<-`(c("owner","repo")))
    ## Unsure why some rows have the branch name instead of a number.
    #### Report ####
    messager("Found",formatC(nrow(dt),big.mark = ","),
             "dependencies across",
             formatC(length(unique(dt$workflow)),big.mark = ","),
             "workflows.",v=verbose)
    #### Return ####
    return(dt)
}
