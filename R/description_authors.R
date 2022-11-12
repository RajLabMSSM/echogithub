description_authors <- function(desc_file,
                                add_html=TRUE){ 
    
    auths <- eval(parse(text = gsub('person','c',desc_file$`Authors@R`)));
    authors <- paste(auths[names(auths)=='given'],
                     auths[names(auths)=='family'], collapse = ', ')
    if(isTRUE(add_html)){
        return(paste0("<h4>Authors: <i>",authors,"</i></h4>"))
    } else {
        return(authors)
    }
}
