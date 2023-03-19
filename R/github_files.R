#' Find, filter, and download files in a GitHub repository
#'
#' Search for files within a GitHub repository and filter them 
#' by a regex \code{query}. Optionally, can download these selected files to 
#' your local computer using the original folder structure.
#' \emph{NOTE}: To search your private repos, make sure you
#' GitHub token is supplied to the \code{token} argument, or is saved as in your
#' \emph{~.Renviron} file, e.g.: \code{GITHUB_TOKEN=<token_here>}
#' @param owner Repo owner name
#'  (can be organization or individual GitHub account name).
#' @param repo GitHub repository name.
#' @param branch Which branch to search.
#' @param query Regex query to filter files by.
#' @param method Method to perform queries with:
#' \itemize{
#' \item{"gh"}{Uses the R package \pkg{gh}. 
#' Uses GitHub token to avoid query limits.}
#' \item{"httr"}{Uses the R package \pkg{httr}.
#' More flexible but quickly runs into webscraping limits imposed by GitHub.}
#' }
#' @param token GitHub Personal Authentication Token (PAT).
#' See \href{https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token}{
#' here for further instructions}.
#' @param download Whether to download the files. The downloaded file paths
#' will be added to a new column named "path_local".
#' @param download_dir Directory to download files into.
#' @param overwrite If a local file already exists, overwrite it.
#' @param timeout How long to wait before timing out during queries/downloads
#' (in units of seconds).
#' @param nThread Number of threads to parallelize queries/downloads across.
#' @param verbose Print messages.
#' @inheritParams github_files_download
#' @inheritParams base::grepl
#' @inheritParams gh::gh
#'
#' @return A list of paths.
#'
#' @export
#' @importFrom data.table := 
#' @examples
#' files <- github_files(owner = "RajLabMSSM", 
#'                       repo = "Fine_Mapping_Shiny",
#'                       query = ".md$")
github_files <- function(owner,
                         repo,
                         branch = c("master"),
                         query = NULL,
                         ignore.case = FALSE,
                         method = "gh", 
                         token = gh::gh_token(),
                         .limit = Inf,
                         download = FALSE,
                         download_dir = tempdir(),
                         overwrite = FALSE,
                         timeout = 5*60,
                         nThread = 1,
                         verbose = TRUE) {
    
    #devoptera::args2vars(github_files) 
    
    path <- link_raw <- path_local <- NULL; 
    #### Check args ####
    method <- tolower(method)[[1]]
    branch <- github_branches(owner = owner, 
                              repo = repo, 
                              branch = branch,  
                              token = token, 
                              verbose = verbose)
    if(is.null(branch)) return(NULL)
    #### Query ####
    if(method=="httr"){
        dt <- github_files_httr(owner = owner,
                                repo = repo,
                                branch = branch, 
                                seconds = timeout,
                                verbose = verbose)
    } else if(method=="gh"){
        dt <- github_files_gh(owner = owner,
                              repo = repo,
                              branch = branch,
                              token = token,
                              .limit = .limit,
                              verbose = verbose)
    } 
    #### Return NULL early ####
    if(is.null(dt)) return(NULL)
    #### Add download link ####
    dt[,link_raw:=paste(
        "https://github.com", owner, repo, "raw",
        branch, path, sep="/"
    )] 
    #### Unlist cols ####
    unlist_dt(dt = dt, 
              exclude = "size",
              verbose = FALSE)
    #### Filter ####
    if (!is.null(query)) {
        dt <- dt[grepl(query,path,ignore.case = ignore.case),]
        messager(paste(formatC(nrow(dt), big.mark = ","),
                       "file(s) found matching query."),v = verbose)
    }
    #### Return ####
    if(isTRUE(download)){
        files <- github_files_download(filelist = dt$link_raw,
                                       download_dir = download_dir,
                                       overwrite = overwrite,
                                       timeout = timeout,
                                       nThread = nThread,
                                       verbose = verbose)
        dt[,path_local:=files]
        return(dt)
    } else {
        return(dt)
    }
}
