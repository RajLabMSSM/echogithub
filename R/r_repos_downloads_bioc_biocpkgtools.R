r_repos_downloads_bioc_biocpkgtools <- function(pkgs){
    requireNamespace("BiocPkgTools")
    package <- NULL;
    
    bioc <- BiocPkgTools::biocDownloadStats() |> 
        data.table::data.table() |> 
        data.table::setnames("Package","package") |>
        data.table::setnames(c("Nb_of_distinct_IPs","Nb_of_downloads"),
                             c("downloads_unique","downloads"),
                             skip_absent = TRUE)
    if(!is.null(pkgs)){
        bioc <- bioc[package %in% pkgs$package,]   
    }
    return(bioc)
}