#' Download files from GitHub
#'
#' Download files from GitHub, e.g. those that have been found with
#' \link[echogithub]{github_files}.
#' @param filelist A list of remote URLs to download from GitHub.
#' @inheritParams github_files
#' 
#' @export
#' @importFrom stringr str_split
#' @importFrom parallel mclapply
#' @importFrom utils download.file 
#' @examples
#' dt <- github_files(owner = "RajLabMSSM",
#'                    repo = "Fine_Mapping_Shiny",
#'                    query = ".md$")
#' filelist_local <- github_files_download(filelist = dt$link_raw)
github_files_download <- function(filelist,
                                  download_dir = tempdir(),
                                  overwrite = FALSE,
                                  timeout = 5*60,
                                  nThread = 1,
                                  verbose = TRUE) {
    
    messager("+ Downloading", length(filelist), "files.", v = verbose)
    local_files <- parallel::mclapply(stats::setNames(filelist,
                                                      filelist), 
                                             function(x) { 
        branch <- stringr::str_split(string = x, pattern = "/")[[1]][7]
        folder_structure <- paste(stringr::str_split(
            string = x,
            pattern = "/"
        )[[1]][-c(seq_len(7))], collapse = "/")
        destfile <- gsub("/www/data", "", file.path(
            download_dir,
            folder_structure
        ))
        dir.create(dirname(destfile),
            showWarnings = FALSE,
            recursive = TRUE
        )
        if (!file.exists(destfile) &
            isFALSE(overwrite)) {
            messager(paste("Downloading:", x),v=verbose)
            options(timeout = timeout)
            utils::download.file(url = x, 
                                 destfile = destfile)
        } else {
            messager("Returning pre-existing file:",x,v=verbose)
        }
        return(destfile)
    }, mc.cores = nThread)
    return(local_files)
}
