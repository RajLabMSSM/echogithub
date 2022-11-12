test_that("github_pages_vignettes works", {
  
    #### At data.table ####
    vdt <- github_pages_vignettes(owner = "RajLabMSSM",
                                  repo = c("echolocatoR","echodata"),
                                  as_toc = FALSE)
    testthat::expect_true(methods::is(vdt,"data.table"))
    
    #### At toc ####
    toc <- github_pages_vignettes(owner = "RajLabMSSM",
                                  repo = c("echolocatoR","echodata"),
                                  as_toc = TRUE)
    testthat::expect_true(is.character(toc))
})
