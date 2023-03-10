#' R repository options
#' 
#' A character vector of R packages repositories.
#' @param exclude Repositories to exclude.
#' @return Character vector
#' @export
#' @examples 
#' which <- r_repos_opts()
r_repos_opts <- function(exclude=NULL){
    r_repos <- c("base","CRAN","Bioc",
                 "rOpenSci","Rforge","GitHub",
                 "local")
    r_repos[!r_repos %in% exclude]
}