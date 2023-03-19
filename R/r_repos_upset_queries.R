#' R repos upset plot queries
#' 
#' Function to generate queries passed to .
#' @param highlight Groups to highlight.
#' @param color Highlight color.
#' @inheritParams r_repos
#' @returns Named list of query parameters
#' 
#' @export
#' @examples 
#' queries <- r_repos_upset_queries(which=NULL)
r_repos_upset_queries <- function(which,
                                  upset_plot = TRUE,
                                  highlight=list("GitHub"),
                                  color="darkred"){
    
    if(isTRUE(upset_plot) &&
       (is.null(which) || all(unlist(highlight) %in% which))){
        requireNamespace("UpSetR")
        queries <- list(list(query = UpSetR::intersects, 
                             params = highlight,
                             color = color, 
                             active = TRUE)
        )
    } else {
        queries <- NULL
    }
    return(queries) 
}