test_that("github_dependencies works", {

    testthat::skip_on_cran()
    dt <- github_dependencies(owner = "neurogenomics",
                              repo = "rworkflows")
    testthat::expect_true(methods::is(dt, "data.frame"))
    if(nrow(dt) > 0){
        cols <- c("target","workflow","workflow_url",
                  "action","action_url","subaction","count")
        testthat::expect_true(all(cols %in% names(dt)))
    }
})
