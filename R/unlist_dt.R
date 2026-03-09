#' Unlist a \link[data.table]{data.table}
#' 
#' Identify columns that are lists and turn them into vectors.
#' @param dt A \link[data.table]{data.table}.
#' @param exclude Columns to exclude from unlisting.
#' @param verbose Print messages.
#' @returns \code{dt} with list columns turned into vectors. 
#' 
#' @keywords internal
#' @importFrom data.table .SD :=
#' @importFrom methods is
unlist_dt <- function(dt,
                      exclude=NULL,
                      verbose=TRUE) {
    .SD <- NULL
    cols <- names(dt)[ unlist(lapply(dt, methods::is,"list")) ]
    cols <- cols[!cols %in% exclude]
    if(length(cols)>0){
        messager("Unlisting",length(cols),"column(s).",v=verbose)
        nr <- nrow(dt)
        for(col in cols){
            vals <- unlist(dt[[col]])
            if(length(vals) == nr){
                data.table::set(dt, j = col, value = vals)
            } else {
                ## If lengths don't match after unlisting, keep only first
                ## element per row to avoid recycling errors.
                vals2 <- vapply(dt[[col]], function(x){
                    x2 <- unlist(x)
                    if(length(x2) == 0) NA_character_ else as.character(x2[[1]])
                }, FUN.VALUE = character(1))
                data.table::set(dt, j = col, value = vals2)
            }
        }
    }
}
