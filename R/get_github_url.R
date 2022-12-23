get_github_url <- function(desc_file){
    if(length(grep("github",desc_file$URL))>0){
        return(desc_file$URL)
    } else if (length(grep("github",desc_file$BugReports))>0){
        return(
            trimws(gsub("issues$","",desc_file$BugReports),
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