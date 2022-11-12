#' Find pages
#' 
#' Find html files on GitHub Pages.
#' @param subdir Only search for files within a given subdirectory 
#' (e.g. "docs").
#' @param save_path Path to save the results to (as a ".csv").
#' @param local_repo Search a cloned local folder of a git repo instead of 
#' the remote GitHub repo. If not \code{NULL}, expects a path to the local repo.
#' @inheritParams github_files
#' 
#' @export
#' @importFrom data.table := fwrite data.table
#' @examples 
#' dt <- github_pages_files(owner="RajLabMSSM", repo="echolocatoR")
github_pages_files <- function(owner,
                               repo,
                               branch = "gh-pages",
                               subdir = NULL,
                               query = NULL,
                               local_repo = NULL,
                               save_path = NULL,
                               token = gh::gh_token(),
                               verbose = TRUE) { 
    
    link_ghpages_index <- link_ghpages <- link_html <- path <- NULL;
    
    #### Filter by subdir ####
    if(!is.null(subdir)){
        query <- paste0("^",subdir,"/",query)
    }
    #### Search ####
    if (is.null(local_repo)) {
        dt <- github_files(owner = owner,
                           repo = repo,
                           query = query,
                           branch = branch, 
                           token = token,
                           verbose = verbose)
    } else {
        dt <- data.table::data.table(
            path=gsub("^[.][/]", "", 
                      list.files(
                          path = local_repo,
                          pattern = query,
                          full.names = TRUE,
                          recursive = TRUE
                      ))
        )
    }
    #### Report ####
    if(is.null(dt) || nrow(dt)==0) {
        messager("WARNING: No files identified.",v=verbose)
        return(NULL)
    }
    gh_pages_url <- github_pages(owner = owner, 
                                 repo = repo, 
                                 error = FALSE,
                                 verbose = verbose)
    # paste(paste0("https://", owner, ".github.io"), repo,sep="/")
    if(!is.null(gh_pages_url)){
        dt[,link_ghpages_index:=gh_pages_url]
        dt[,link_ghpages:=paste(gh_pages_url, path, sep="/")]
        dt[,link_html:=paste0(
            "<a href='",link_ghpages,"' target='blank'>",
            gsub("_"," ",gsub("\\.html$","",basename(link_ghpages))),
            "</a>"
        )]
    }
    dt <- cbind(owner=owner,dt)
    dt <- cbind(repo=repo,dt) 
    #### Save ####
    if(!is.null(save_path)) {
        messager(paste("Writing links to ==>", save_path),v=verbose)
        data.table::fwrite(dt, save_path, sep = ",") 
    }
    #### Return ####
    return(dt)
}
