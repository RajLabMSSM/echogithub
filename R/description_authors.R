#' Description authors
#' 
#' Parse authors from the \emph{DESCRIPTION} file of an R package.
#' @param names_only Only return author names (and not other subfields).
#' For example:
#' "Jim Hester \<james.f.hester\@gmail.com\> \[aut\]" would become
#' "Jim Hester".
#' @inheritParams description_extract
#' @returns Authors as an HTML character string.
#' 
#' @keywords internal
description_authors <- function(desc_file,
                                names_only=TRUE,
                                add_html=FALSE,
                                verbose=TRUE){  
    # desc_file <- desc::desc(package = "desc")
    # devoptera::args2vars(description_authors)
    
    afields <- author_fields()
    afields <- afields[afields %in% desc_file$fields()][1]
    if(length(afields)>0){
        if(grepl("authors",afields,ignore.case = TRUE)){
            authors <- desc_file$get_authors()
        } else {
            authors <- desc_file$get_author()
            if(is.null(authors)){
                authors <- desc_file$get_field(afields)
            }
        } 
    } else {
        message("No author fields detected. Returning NULL.",v=verbose)
        return(NULL)
    } 
    if(isTRUE(names_only)){
        authors <- gsub("(\\([^()]*\\)|\\[[^\\[\\]*\\]|<[^<>]*>)", "",
                        authors) |>trimws()
    } 
    #### collapse ####
    authors <- paste(authors,collapse = ", ")
    if(isTRUE(add_html)){
        return(paste0("<h4>Authors: <i>",authors,"</i></h4>"))
    } else {
        return(authors)
    }
}
