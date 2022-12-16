test_that("r_repos_downloads works", {
  
    run_tests <- function(pkgs,
                          pkgs_out){
        testthat::expect_true(all(pkgs$package %in% pkgs_out$package))
        cols <- c("package","r_repo","downloads")
        testthat::expect_true(all(cols %in% names(pkgs_out)))
    }
    #### From data.table ####
    pkgs <- r_repos_data()[r_repo=="CRAN" & installed==TRUE,][seq_len(5),]
    pkgs2 <- r_repos_downloads(pkgs = pkgs)
    run_tests(pkgs = pkgs,
              pkgs_out = pkgs2) 
    
    #### From vector ####
    p <- "echolocatoR"
    dt <- echogithub::description_extract(repo = p,
                                          fields = NULL,
                                          as_datatable = TRUE) |>
        data.table::setnames("Package","package")
    pkgs3 <- r_repos_downloads(pkgs = dt)
    run_tests(pkgs=dt,
              pkgs_out = pkgs3) 
})
