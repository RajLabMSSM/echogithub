r_repos_downloads_cran_cranlogs <- function(pkgs,
                                            grand_total=FALSE,
                                            nThread=1,
                                            verbose=TRUE){
    package <- NULL;
    if(isTRUE(grand_total)){
        requireNamespace("rvest") 
        ## Only counts since October 2012,
        ## the month the RStudio CRAN mirror started publishing logs.
        cran <- parallel::mclapply(pkgs$package,
                                   function(pkg){
            api <- paste0("https://cranlogs.r-pkg.org/badges/grand-total/",pkg)
            v <- (rev(
                    rvest::read_html(api) |>
                        rvest::html_elements("text") |>
                        rvest::html_text()
                )[[1]] |> strsplit(" +|K|\n")
            )[[1]]
            data.table::data.table(package=pkg,
                                   downloads=as.integer(v[v!=""]))
        }, mc.cores = nThread) |> 
            data.table::rbindlist(fill = TRUE)
    } else {
        requireNamespace("cranlogs") 
        #### Get downloads data for each batch #### 
        pkgs <- pkgs[package!="R",]
        cran <- cranlogs::cran_downloads(packages = pkgs$package, 
                                         from = "1990-01-01", 
                                         to = Sys.Date()-1, 
                                         mc.cores = nThread) |>
            data.table::data.table()
        data.table::setnames(cran,"count","downloads")
    }
    return(cran)
}
