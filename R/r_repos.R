#' R repositories
#' 
#' Report on which repositories R packages are distributed through
#'  (i.e. base R, CRAN, Bioc, rOpenSci, R-Forge, and/or GitHub).
#' @param which Which R repositories to extract data from.
#' @param upset_plot Whether to create an upset plot 
#' showing R package overlap between repositories.
#' @param show_plot Print the plot.
#' @param save_path Path to save upset plot to.
#' @param verbose Print messages.
#' @inheritParams BiocManager::repositories
#' @returns Named list.
#' 
#' @export
#' @importFrom data.table data.table
#' @examples 
#' report <- r_repos()
r_repos <- function(which=r_repos_opts(),
                    version=NULL,
                    upset_plot=TRUE,
                    show_plot=TRUE,
                    save_path=tempfile(fileext = "upsetr.pdf"),
                    verbose=TRUE){
    
    if(isTRUE(upset_plot)) requireNamespace("UpSetR")
    total <- percent_all <- percent_exclusive <-
        count_exclusive <- count_all <- count_exclusive <- NULL;
    
    #### Gather data ####
    pkgs <- r_repos_data(which = which,
                         version = version,
                         verbose = verbose)  
    #### Upset plot ####
    if(isTRUE(upset_plot)){
        upset <- r_repos_upset(pkgs = pkgs,
                               save_path = save_path, 
                               show_plot = show_plot,
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
            r_repo=names(stats_1repo),
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
    } else {
        return(pkgs)
    } 
}
