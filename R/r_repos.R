#' R repositories
#' 
#' Report on which repositories R packages are distributed through
#'  (e.g. CRAN, Bioc, rOpenSci, and/or GitHub).
#' @param save_path Path to save upset plot to.
#' @param verbose Print messages.
#' @returns Named list.
#' 
#' @export
#' @importFrom data.table data.table
#' @examples 
#' report <- r_repos()
r_repos <- function(save_path=tempfile(pattern = "upsetr.pdf"),
                    verbose=TRUE){
    
    requireNamespace("UpSetR")
    total <- percent_all <- percent_exclusive <-
        count_exclusive <- count_all <- count_exclusive <- NULL;
    
    #### Gather data ####
    pkgs <- r_repos_data(verbose = verbose) 
    #### Upset plot ####
    upset <- r_repos_upset(pkgs = pkgs,
                           save_path = save_path, 
                           verbose = verbose,
                           sets.bar.color = "slategrey",
                           main.bar.color = "slategrey",
                           text.scale = 1.5,
                           queries = list(list(query = UpSetR::intersects, 
                                                  params = list("GitHub"),
                                                  color = "darkred", 
                                                  active = TRUE))
                           ) 
    upset_data <- upset$data
    #### Compute percentages ####
    stats_1repo <- colSums(upset_data[rowSums(upset_data)==1,])
    repo_stats <- data.table::data.table(
        repo=names(stats_1repo),
        total=length(unique(pkgs$package)),
        count_all=colSums(upset_data),
        count_exclusive=stats_1repo
    )[,percent_all:=(
        count_all/total*100)][,percent_exclusive:=(
            count_exclusive/total*100)]
    #### Return ####
    return(list(pkgs=pkgs, 
                repo_stats=repo_stats,
                upset=upset))
}
