test_that("readme_header works", { 
    
    #### As character ####
    h1 <- readme_header()
    testthat::expect_true(is.character(h1))
    
    #### As list ####
    h2 <- readme_header(as_list = TRUE)
    testthat::expect_true(is.list(h2))
})
