#' Find a DESCRIPTION file
#' 
#' Find  DESCRIPTION file for a given R package. 
#' @param desc_file When \code{owner} or \code{repo} are NULL, 
#' these arguments are inferred from the \emph{DESCRIPTION} file.
#' If a  \emph{DESCRIPTION} file cannot be found in the current working directory, 
#' it then searches for one in the remote GitHub repository.
#' @param use_github Prioritize getting the \emph{DESCRIPTION} file
#'  from GitHub.
#' @inheritParams github_files
#' 
#' @export
#' @importFrom methods is
#' @importFrom utils installed.packages packageDescription 
#' @importFrom testthat is_testing
#' @examples 
#' \dontrun{
#' desc_file <- description_find(repo="data.table")
#' }
description_find <- function(desc_file = NULL,
                             owner = NULL,
                             repo = NULL,
                             use_github = FALSE,
                             verbose = TRUE){
    
    if(!is.null(owner) && 
       !is.null(repo) &&
       (isTRUE(use_github) | 
        testthat::is_testing())){
        dt <- github_files(owner = owner,
                           repo = repo, 
                           query = "^DESCRIPTION$",
                           download = TRUE,
                           verbose = verbose)
        dfile <- description_read(dcf = dt$path_local)
        return(dfile)
    }
    
    # if(isTRUE(testthat::is_testing())){
    #     out <- rprojroot::find_root_file(criterion = rprojroot::has_file("DESCRIPTION"))
    #     list.files(out)
    #     list.files(,rprojroot::find_root(rprojroot::is_testthat))
    # }
    #### From R object ####
    if(methods::is(desc_file,"matrix")){
        messager("Getting DESCRIPTION file from matrix object.",v=verbose)
        dfile <- description_read(dcf = desc_file)
        return(dfile)
    } else if(methods::is(desc_file,"packageDescription")){
        messager("Getting DESCRIPTION file from packageDescription object.",
                 v=verbose)
        return(desc_file)
    #### From R installation ####
    } else if(!is.null(repo) && 
              repo %in% rownames(utils::installed.packages())){
        messager("Getting DESCRIPTION file from the R library.",v=verbose)
        dfile <- utils::packageDescription(repo)
        return(dfile)
    #### From local file ####
    } else if(!is.null(desc_file) && 
              file.exists(desc_file)) {
        messager("Getting DESCRIPTION file from a local file.",v=verbose)
        dfile <- description_read(dcf = desc_file)
        return(dfile)
    #### From remote file ####
    } else if(file.exists("DESCRIPTION")) {
        messager("Getting DESCRIPTION file from a local file in the",
                 "current working directory.",v=verbose)
        dfile <- description_read(dcf = "DESCRIPTION")
        return(dfile) 
    #### From remote file ####
    } else if(is_url(desc_file)){
        messager("Getting DESCRIPTION file from a remote file.",v=verbose)
        file <- utils::download.file(desc_file)
        dfile <- description_read(dcf = file)
        return(dfile)
    #### From GitHub Repo ####
    } else if (!is.null(owner) && !is.null(repo)){
        messager("Getting DESCRIPTION file from GitHub repository.",v=verbose)
        dt <- github_files(owner = owner,
                           repo = repo, 
                           query = "DESCRIPTION$",
                           download = TRUE,
                           verbose = verbose)
        dfile <- description_read(dcf = dt$path_local)
        return(dfile)
    #### Fail ####
    } else {
        stp <- "Could not find DESCRIPTION file."
        stop(stp)
    }
}
