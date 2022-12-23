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
    all_fields <- unique(c("owner","repo","authors","github_url",
                           names(desc_file)))
    if(is.null(desc_file)) {
        stopper("desc_file is required for description_extract")
    }
    if(is.null(fields)) { 
        fields <- all_fields
    } 
    fields <- unique(fields)
    fields <- fields[fields %in% all_fields]
    #### Extract info ####
    messager("Extracting",length(fields),"field(s).",v=verbose)
    res <- lapply(stats::setNames(fields,
                                  fields), 
                  function(f){
        # messager("Inferring",f,"from DESCRIPTION file.",v=verbose)
        #### Check fields ####
        if(f %in% c("authors","Authors@R","Author")) {
            authors <- description_authors(desc_file = desc_file,
                                           add_html = add_html) 
            return(authors)
        } else if(f %in% names(desc_file)){
            return(desc_file[[f]])
        } else if(f=="github_url"){
            gh_url <- get_github_url(desc_file = desc_file)
            return(gh_url)
        } else if(f=="owner"){
            gh_url <- get_github_url(desc_file = desc_file)
            if(is.null(gh_url)) {
                return(NULL)
            } else {
                return(rev(strsplit(gh_url,"/")[[1]])[2])
            }  
        } else if(f=="repo"){
            gh_url <- get_github_url(desc_file = desc_file)
            if(is.null(gh_url)) {
                return(NULL)
            } else {
                return(rev(strsplit(gh_url,"/")[[1]])[1])
            }  
        } 
    })
    #### Return ####
    if(isTRUE(as_datatable)){
        return(data.table::as.data.table(res))
    } else {
        return(res)
    }
}
