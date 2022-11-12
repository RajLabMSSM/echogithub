#' Read a \emph{DESCRIPTION} file
#' 
#' Read in a \emph{DESCRIPTION} file as a nicely organized
#'  \link[utils]{packageDescription} object.
#' @param dcf A path to a \emph{DESCRIPTION} file or a matrix object from 
#' \link[base]{read.dcf}.
#' 
#' Code adapted from the function \link[utils]{packageDescription}.
#' @inheritParams utils::packageDescription
#' @keywords internal
#' @importFrom methods is
description_read <- function(dcf, 
                             fields = NULL,
                             drop = TRUE,
                             encoding = ""){

    if(!methods::is(dcf,"matrix") &&
       methods::is(dcf,"character")){
        dcf <- read.dcf(dcf) 
        file <- dcf
    } else {
        file <- NULL
    }
    retval <- list()
    if (!is.null(fields)) {
        fields <- as.character(fields)
        retval[fields] <- NA
    }
    desc <- as.list(dcf[1, ])
    enc <- desc[["Encoding"]]
    if (!is.null(enc) && !is.na(encoding)) {
        if (missing(encoding) && Sys.getlocale("LC_CTYPE") == 
            "C") 
            encoding <- "ASCII//TRANSLIT"
        if (encoding != enc) {
            newdesc <- try(lapply(desc, iconv, from = enc, 
                                  to = encoding))
            dOk <- function(nd) !inherits(nd, "error") && 
                !anyNA(nd)
            ok <- dOk(newdesc)
            if (!ok) 
                ok <- dOk(newdesc <- try(lapply(desc, iconv, 
                                                from = enc, to = paste0(encoding, "//TRANSLIT"))))
            if (!ok) 
                ok <- dOk(newdesc <- try(lapply(desc, iconv, 
                                                from = enc, to = "ASCII//TRANSLIT", sub = "?")))
            if (ok) 
                desc <- newdesc
            else warning("'DESCRIPTION' file has an 'Encoding' field and re-encoding is not possible", 
                         call. = FALSE)
        }
    }
    if (!is.null(fields)) {
        ok <- names(desc) %in% fields
        retval[names(desc)[ok]] <- desc[ok]
    } else {
        retval[names(desc)] <- desc
    }
    if (drop && length(fields) == 1L) return(retval[[1L]])
    class(retval) <- "packageDescription"
    if (!is.null(fields)) attr(retval, "fields") <- fields
    attr(retval, "file") <- file
    return(retval)
}
