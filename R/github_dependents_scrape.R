github_dependents_scrape <- function(owner,
                                     repo, 
                                     token = gh::gh_token(),
                                     max_pages = 1000,
                                     verbose = TRUE){
    
    requireNamespace("rvest")
    owner_repo <- NULL;
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
    ### Bind data from all pages ####
    all_dat <- data.table::rbindlist(all_dat,
                                     use.names = TRUE, idcol = "page")
    return(all_dat)
}