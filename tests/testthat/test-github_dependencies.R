test_that("github_dependencies works", {
  
    dt <- github_dependencies(owner = "neurogenomics",
                              repo = "rworkflows")
    cols <- c("target","workflow","workflow_url",
              "action","action_url","subaction","count")
    testthat::expect_true(all(cols %in% names(dt)))
    testthat::expect_true(
        all(c("rworkflows_static.yml","rworkflows.yml") %in% dt$workflow)
    )
})
