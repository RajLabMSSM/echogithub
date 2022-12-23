#' Check if the input is url e.g. http:// or ftp://
#' @param path Path to local file or remote URL.
#' @param protocols URL protocols to search for.
#' @param check_exists Throw an error if the remote file does not exist.
#' @source \href{https://rdrr.io/cran/seqminer/src/R/seqminer.R}{
#' Borrowed from \code{seqminer} internal function}
#' 
#' @keywords internal
#' @importFrom RCurl url.exists
is_url <- function(path,
                   protocols=c("http","https",
                               "ftp","ftps",
                               "fttp","fttps"),
                   check_exists=TRUE) {
    
    if(is.null(path)) return(FALSE)
    pattern <- paste(paste0("^",protocols,"://"),collapse = "|")
    if (grepl(pattern = pattern, x = path, ignore.case = TRUE)) {
        if(isTRUE(check_exists)){ 
            return(RCurl::url.exists(path))
        }
        return(TRUE)
    }
    return(FALSE)
}
