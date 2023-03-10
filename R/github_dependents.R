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
    
    #devoptera::args2vars(github_insights)  
    
    requireNamespace("rvest")
    owner_repo <- NULL;
    messager("Searching for dependents of:",paste(owner,repo,sep="/"),
             v=verbose) 
    url <- paste0("https://github.com/", owner,"/",repo, "/network/dependents")
    #### Loop over the specified number of pages ####
    all_dat <- list() 
    for (i in seq_len(max_pages)) {
        # Print a message indicating the URL being scraped
        messager(paste0("+ Scraping page ",i,"."),v=verbose) 
        # Retrieve the HTML content of the page
        page <- rvest::read_html(url) 
        box_rows <- rvest::html_elements(page,".Box-row")
        dt <- (rvest::html_text2(box_rows)) |> 
            stringr::str_split(" / |\n|[ ]", simplify = TRUE) |> 
            data.table::data.table() |> 
            `colnames<-`(c("owner","repo","stargazers_count","forks_count"))
        dt[,owner_repo:=paste(owner,repo,sep="/")]
        dt <- cbind(target=paste(owner,repo,sep="/"),dt) 
        all_dat[[i]] <- dt 
        #### Find the button for the next page ####
        buttons <- page |> rvest::html_nodes(".paginate-container .btn")
        next_buttons <- buttons[rvest::html_text(buttons)=="Next"]
        #### Check if the button is disabled ####
        is_disabled <- any(sapply(next_buttons, function(btn) {
            btn_attr <- rvest::html_attr(btn, "disabled")
            !is.na(btn_attr) && btn_attr == "disabled"
        }))
        #### If the button isn't disable, update the URL to scrape ####
        if (isFALSE(is_disabled)) { 
            url <- next_buttons |> rvest::html_attr("href") 
        #### Otherwise, break the loop ####
        } else {
            break 
        }
    }
    #### Bind data from all pages ####
    all_dat <- data.table::rbindlist(all_dat, 
                                     use.names = TRUE, idcol = "page")
    #### Report ####
    messager("Found",formatC(nrow(all_dat),big.mark = ","),
             "dependents.",v=verbose)
    #### Return ####    
    return(all_dat)
}
