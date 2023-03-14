#' Add owner/repo
#' 
#' Try to add a new column named "owner_repo" that combines both the owner of 
#' and name of each GitHub repository.
#' @param dt \link[data.table]{data.table}.
#' @param add_ref Coalesce multiple columns 
#' (\code{e.g. c("owner_repo","repo","package","Package")}) into a single "ref"
#' column. Tries to fill in \code{NA} values as much as possible.
#' @param ref_cols Columns to consider when coalescing into the "ref" column.
#' @param sep Separator value between "owner" and "repo".
#' @returns \link[data.table]{data.table}.
#' 
#' @export
#' @examples 
#' dt <- data.table::data.table(owner=letters, repo=LETTERS)
#' dt <- add_owner_repo(dt)
add_owner_repo <- function(dt,
                           add_ref=TRUE,
                           ref_cols=c("ref","owner_repo","repo",
                                      "package","Package"),
                           sep="/"){
    
    owner <- repo <- owner_repo <- subaction <- target <- ref <- NULL;
    
    if(!methods::is(dt,"data.table")) dt <- data.table::data.table(dt)
    #### Add subaction names ####
    if("subaction" %in% names(dt)){
        dt[,owner_repo:=gsub("/",sep,subaction)]
    } else if(all(c("owner","repo") %in% names(dt))){
        dt[,owner_repo:=paste(owner,repo,sep=sep)]
    }
    default_sep <- "/"
    if("target" %in% names(dt) && sep!=default_sep){
        dt[,target:=gsub(default_sep,sep,target)]
    }
    if(all(c("owner","owner_repo") %in% names(dt))){
        dt[is.na(owner),owner_repo:=NA]    
    }
    if(all(c("repo","owner_repo") %in% names(dt))){
        dt[is.na(repo),owner_repo:=NA]    
    } 
    #### Coalesce columns into one "ref" column ####
    if(isTRUE(add_ref)){ 
        ref_cols <- ref_cols[ref_cols %in% names(dt)]
        dt[,ref:=data.table::fcoalesce(dt[,ref_cols,with=FALSE])]  
    } 
    return(dt)
}
