description_extract_i <- function(desc_file = NULL,
                                  ref = NULL,
                                  fields = c("owner",
                                             "repo",
                                             "authors"),
                                  names_only = TRUE,
                                  add_html = FALSE,
                                  as_datatable = FALSE, 
                                  verbose = TRUE){
    #### Find or read DESCRIPTION file ####
    
    if(is.null(desc_file)) {
        messager("desc_file is required for description_extract.",
                 "Returning NULL.",v=verbose)
        return(NULL)
    }  
    all_fields <- unique(c("owner","repo","authors","github_url",
                           desc_file$fields()))
    
    if(is.null(fields)) { 
        fields <- all_fields
    } 
    fields <- unique(fields)
    fields <- fields[fields %in% all_fields]
    #### Check package name ####
    if(!desc_file$has_fields("Package")){
        messager("WARNING:","Package field is missing from DECRIPTION.")
    } else {
        pkg <- desc_file$get_field("Package")
    }
    
    #### Extract info ####
    messager("Extracting",length(fields),"DESCRIPTION field(s)",
             "for the package:",pkg,v=verbose)
    res <- lapply(stats::setNames(fields,
                                  fields), 
                  function(f){
      # messager("Inferring",f,"from DESCRIPTION file.",v=verbose)
      #### Check fields ####
      if(f %in% author_fields()) {
          authors <- description_authors(desc_file = desc_file,
                                         add_html = add_html, 
                                         names_only = names_only) 
          return(authors)
      } else if(desc_file$has_fields(f)){
          return(desc_file$get_field(f))
      } else if(f=="github_url"){
          gh_url <- get_github_url(desc_file = desc_file)
          return(gh_url)
      } else if(f=="owner"){
          gh_url <- get_github_url(desc_file = desc_file)
          if(is.null(gh_url)) {
              return(NULL)
          } else {
              return(
                  strsplit(gsub("https://github.com/","",gh_url),"/")[[1]][1]
              )
          }  
      } else if(f=="repo"){
          gh_url <- get_github_url(desc_file = desc_file)
          if(is.null(gh_url)) {
              return(NULL)
          } else {
              return(
                  strsplit(gsub("https://github.com/","",gh_url),"/")[[1]][2]
              )
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