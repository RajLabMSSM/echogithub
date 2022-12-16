#' R repository options
#' 
#' A character vector of R packages repositories.
#' @return Character vector
#' @export
#' @examples 
#' which <- r_repos_opts()
r_repos_opts <- function(){
    c("base","CRAN","Bioc",
      "rOpenSci","Rforge","GitHub",
      "local")
}