#' GitHub Pages vignettes
#' 
#' List all GitHub Pages vignettes for one or more GitHub repository.
#' @param as_toc Return the list of vignettes as a
#'  table of contents (TOC) HTML string.
#' \emph{NOTE}: If you want to show the TOC in an Rmarkdown file, 
#' make sure you change the code chunk settings to: 
#' \code{{r, results='asis'}}.
#' @inheritParams github_pages_files
#' @inheritParams github_files
#' 
#' @export
#' @importFrom data.table rbindlist :=
#' @importFrom stats setNames
#' @examples
#' vdt <- github_pages_vignettes(owner = "RajLabMSSM", 
#'                               repo = c("echolocatoR","echodata"))
github_pages_vignettes <- function(owner,
                                   repo,
                                   as_toc = FALSE,
                                   branch = "gh-pages",
                                   subdir = "articles",
                                   query = "*.*.html$",
                                   local_repo = NULL,
                                   save_path = NULL,
                                   token = gh::gh_token(),
                                   verbose = FALSE){
    # echoverseTemplate:::source_all()
    # echoverseTemplate:::args2vars(github_pages_vignettes)
    # repo <- c("echolocatoR","echodata"); owner <- "RajLabMSSM"
    
    path <- NULL;
    
    ##### Check inputs ####
    out <- check_owner_repo(owner = owner, 
                            repo = repo, 
                            verbose = verbose)
    owner <- out$owner
    repo <- out$repo
    #### Gather vignettes ####
    vdt <- lapply(seq_len(length(repo)), function(i){
        dt <- github_pages_files(owner = owner[[i]],
                                 repo = repo[[i]],
                                 branch = branch,
                                 subdir = subdir,
                                 query = query,
                                 local_repo = local_repo,
                                 save_path = save_path,
                                 token = token,
                                 verbose = verbose)
        if(is.null(dt) || nrow(dt)==0) return(NULL)
        #### Remove index file ####
        dt <- dt[!grepl(pattern = "/index.html$",x = path),]
        #### Remove resource files ###
        dt <- dt[lapply(path,function(x){length(strsplit(x,"/")[[1]])})==2,]
        return(dt)
    }) |> data.table::rbindlist(fill=TRUE)
    #### Return ####
    if(isTRUE(as_toc)){
        toc <- github_pages_vignettes_toc(vdt = vdt)
        return(toc)
    } else {
        return(vdt) 
    }
}
