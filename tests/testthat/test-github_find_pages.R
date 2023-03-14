test_that("github_pages_files works", {
    
    files <- github_files(owner = "RajLabMSSM",
                          repo = "Fine_Mapping_Shiny",
                          query = ".md$", 
                          download = TRUE)
    testthat::expect_true(methods::is(files, "data.table"))    
    testthat::expect_true(nrow(files)>=1)    
    
    #### Test echolocatoR #####
    dt <-  github_pages_files(owner = "RajLabMSSM",
                              repo = "echolocatoR",
                              query = "\\.html$") 
    testthat::expect_gte(nrow(dt), 30)
    
    #### Test Fine_Mapping repo #### 
    links_df <- github_pages_files(owner = "RajLabMSSM",
                                   repo = "Fine_Mapping",
                                   branch = "master")
    testthat::expect_gte(nrow(links_df), 4000)
})
