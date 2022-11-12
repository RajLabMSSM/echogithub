#' GitHub Pages: Table of Contents
#' 
#' List all GitHub Pages vignettes for one or more GitHub repository.
#' Then construct an HTML Table of Contents (TOC) from the vignette links.
#' @inheritParams github_pages_files
#' @inheritParams github_files
#' @returns HTML character string.
#' 
#' @keywords internal
#' @importFrom stats setNames
github_pages_vignettes_toc <- function(vdt,
                                       bullet1="\U0001F987"){ 
    
    owner <- repo <- owner_repo <- NULL;
    #### Create TOC ####
    # bullet1_ <- paste0("\"","ul {list-style: none};",
    #                    "ul li h2 a:before { content:",shQuote(bullet1),"};","\"")
    # bullet2_ <- paste0("\"","ul {list-style: none};",
    #                    "ul li h2 a:before { content:",shQuote(bullet2),"};","\"")
    vdt[,owner_repo:=paste(owner,repo,sep='/')]
    owner_repo_list <- stats::setNames(
        unique(vdt$owner_repo),
        unique(
            paste0("<a href=",shQuote(unique(vdt$link_ghpages_index)),">",
                   unique(vdt$repo),
                   "</a>"))
    )
    toc <- paste("<ul class='toc-list'>",
                 lapply(owner_repo_list,
                        function(x){
                            paste(
                                paste0("<li><h2>"),
                                bullet1,
                                names(owner_repo_list)[
                                    which(owner_repo_list==x)],
                                "</h2>",
                                "<ul>",
                                paste0("<li><h3>",
                                       vdt[owner_repo==x,]$link_html,
                                       "</h3></li>",
                                       collapse = " "),
                                "</ul>",
                                "</li>"
                            )
                        }) |> unlist() |> paste(collapse = " "),
                 "</ul>"
    )
    cat(toc)
    return(toc) 
}
