test_that("description_find works", {
    
    desc_file <- description_find(repo="data.table")
    testthat::expect_true(methods::is(desc_file,"packageDescription"))
})
