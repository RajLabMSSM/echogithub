#' DESCRIPTION file: extract fields
#' 
#' Extract information from an R package's DESCRIPTION file.
#' @param fields Fields to extract.
#' @param add_html Add HTML styling to certain fields (e.g "authors").
#' @param as_datatable Convert the results into a \link[data.table]{data.table}.
#' @inheritParams description_find
#' @inheritParams github_files
#' @returns A named list or \link[data.table]{data.table}.
#' 
#' @export
#' @importFrom data.table as.data.table
#' @examples  
#'\dontrun{
#' res <- description_extract(repo="echolocatoR")
#'}
description_extract <- function(desc_file = NULL,
                                repo = NULL,
                                fields = c("owner",
                                           "repo",
                                           "authors"),
                                add_html = FALSE,
                                as_datatable = FALSE,
                                verbose = TRUE){ 
    #### Find or read DESCRIPTION file ####
    if(is.null(desc_file)){
        desc_file <- description_find(repo = repo,
                                      desc_file = desc_file,
                                      verbose = verbose)
    }
    force(desc_file)
    if(is.null(desc_file)) {
        stopper("desc_file is required for description_extract")
    }
    if(is.null(fields)) { 
        fields <- c("owner","repo",names(desc_file))
    }
    fields <- unique(fields)
    fields <- fields[fields %in% c("owner","repo",names(desc_file))]
    #### Extract info ####
    messager("Extracting",length(fields),"field(s).",v=verbose)
    res <- lapply(stats::setNames(fields,
                                  fields), 
                  function(f){
        # messager("Inferring",f,"from DESCRIPTION file.",v=verbose)
        #### Check fields ####
        if(f=="owner") {
            i <- 2
        } else if(f=="repo") {
            i <- 1
        } else if(f %in% c("authors","Authors@R")) {
            authors <- description_authors(desc_file = desc_file,
                                           add_html = add_html) 
            return(authors)
        } else if(f %in% names(desc_file)){
            return(desc_file[[f]])
        } else {
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
        # messager(paste0("+ ",f,":"),info,v=verbose)
        return(info)
    })
    #### Return ####
    if(isTRUE(as_datatable)){
        return(data.table::as.data.table(res))
    } else {
        return(res)
    }
}
