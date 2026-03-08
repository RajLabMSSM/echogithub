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
                                  token = gh::gh_token(),
                                  download_dir = tempdir(),
                                  overwrite = FALSE,
                                  timeout = 5*60,
                                  nThread = 1,
                                  verbose = TRUE) {
    # devoptera::args2vars(github_files_download)
    
    options(timeout = timeout)
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
            messager("Downloading:",x,v=verbose)
            #### Add token to header ####
            extra <- getOption("download.file.extra")
            if(!is.null(token)) { 
                extra <- c(extra, "--fail", "-L")
                headers <- c(Authorization = paste("token", token))
                qh <- shQuote(paste0(names(headers), ": ", headers))
                extra <- c(extra, paste("-H", qh))
            }  
            #### Download ####
            utils::download.file(url = x,
                                 method = "curl",
                                 quiet = verbose<2,
                                 mode = "wb",
                                 extra = extra,
                                 destfile = destfile)
        } else {
            messager("Returning pre-existing file:",x,v=verbose)
        }
        return(destfile)
    }, mc.cores = nThread)
    return(local_files)
}
