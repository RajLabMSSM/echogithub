#' DESCRIPTION file: extract fields
#' 
#' Extract information from an R package's DESCRIPTION file.
#' @param fields Fields to extract.
#' @param add_html Add HTML styling to certain fields (e.g "authors").
#' @param as_datatable Convert the results into a \link[data.table]{data.table}.
#' @param desc_file When \code{owner} or \code{repo} are NULL, 
#' these arguments are inferred from the \emph{DESCRIPTION} file.
#' @inheritParams rworkflows::get_description
#' @inheritDotParams rworkflows::get_description
#' @inheritParams github_files
#' @inheritParams description_authors
#' @returns A named list or \link[data.table]{data.table}.
#' 
#' @export
#' @importFrom rworkflows get_description
#' @importFrom data.table as.data.table
#' @examples  
#' res <- description_extract(refs="RajLabMSSM/echolocatoR")
description_extract <- function(desc_file = NULL,
                                refs = NULL,
                                fields = c("owner",
                                           "repo",
                                           "authors"),
                                names_only = TRUE,
                                add_html = FALSE,
                                as_datatable = FALSE, 
                                nThread = 1,
                                verbose = TRUE,
                                ...){ 
    
    # devoptera::args2vars(description_extract) 
    
    refs <- check_pkgs(pkgs = refs)    
    if(length(refs)==0 && is.null(desc_file)){
        messager("Must supply either refs or desc_file.",
                 "Returning NULL.",v=verbose)
        return(NULL)
    }
    dl <- rworkflows::get_description(refs = refs$package, 
                                      paths = desc_file,
                                      verbose = verbose,
                                      ...)
    meta_desc <- lapply(dl, function(desc_file){
        description_extract_i(desc_file= desc_file,
                              fields = fields,
                              as_datatable = TRUE,
                              verbose = FALSE)
    })  |>
        data.table::rbindlist(fill = TRUE, use.names = TRUE, idcol = "package")   
    if(nrow(meta_desc)==0){
        messager("WARNING: No metadata retrieved from any DESCRIPTION files.",
                 v=verbose)
    } else {
        if("repo" %in% names(meta_desc)) data.table::setkeyv(meta_desc,"repo")
    } 
    return(meta_desc)
   
}
