#' DESCRIPTION file: extract fields
#' 
#' Extract information from an R package's DESCRIPTION file.
#' @param fields Fields to extract.
#' @param add_html Add HTML styling to certain fields (e.g "authors").
#' @inheritParams description_find
#' @inheritParams github_files
#' @export
#' @examples  
#' res <- description_extract(repo="echolocatoR")
description_extract <- function(repo = NULL,
                                desc_file = NULL,
                                fields = c("owner",
                                           "repo",
                                           "authors"),
                                add_html = FALSE,
                                verbose = TRUE){ 
    #### Find or read DESCRIPTION file ####
    desc_file <- description_find(repo = repo, 
                                  desc_file = desc_file, 
                                  verbose = verbose) 
    #### Extract info ####
    res <- lapply(stats::setNames(fields,
                                  fields), 
                  function(f){
        messager("Inferring",f,"from DESCRIPTION file.",v=verbose)
        #### Check fields ####
        if(f=="owner") {
            i <- 2
        } else if(f=="repo") {
            i <- 1
        } else if(f=="authors") {
            authors <- description_authors(desc_file = desc_file,
                                           add_html = add_html)
            messager("+ Inferred authors:",authors)
            return(authors)
        } else if(f %in% names(desc_file)){
            return(desc_file[[f]])
        }else {
          stp <- paste("fields must be one of:",
                       paste("\n -",c(
                           eval(formals(description_extract)$fields),
                           names(desc_file)
                       ), collapse = ""))
          stop(stp)
        }
        #### Parse info #### 
        URL <- desc_file$URL
        if(is.na(URL)){
            stp <- "Cannot find URL field in DESCRIPTION file."
            stop(stp)
        } 
        i <- if(f=="owner") 2 else if(f=="repo") 1 else {
            stp <- "fields must be 'owner' or 'repo'"
            stop(stp)
        }
        info <- rev(strsplit(URL,"/")[[1]])[i]    
        messager(paste0("+ Inferred ",f,":"),info,v=verbose) 
        return(info)
    })
    #### Return ####
    return(res)
}
