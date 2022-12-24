get_github_url <- function(desc_file){
    ## These fields sometimes contain >1 link.
    ## Find the one that's actually for the GitHub repo.
    get_gh <- function(URL){
        urls <- trimws(strsplit(URL,",")[[1]])
        grep("https://github.com", urls, value = TRUE)
    }
    #### Parse ####
    if(length(grep("github",desc_file$URL))>0){ 
        return(get_gh(desc_file$URL))
    } else if (length(grep("github",desc_file$BugReports))>0){
        return(
            trimws(gsub("issues$","",get_gh(desc_file$BugReports)),
                   whitespace = "/")
        )
    } else if (!is.null(desc_file$git_url)){
        return(
            paste("https://github.com",
                  strsplit(desc_file$git_url,"[.]")[[1]][[2]],
                  basename(desc_file$git_url),sep="/")
        ) 
    } else {
        return(NULL)
    }
}
