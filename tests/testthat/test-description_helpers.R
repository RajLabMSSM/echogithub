## ---- description_authors ----

test_that("description_authors extracts names from local DESCRIPTION", {
    testthat::skip_if_not_installed("desc")
    desc_path <- system.file("DESCRIPTION", package = "echogithub")
    testthat::skip_if(desc_path == "", message = "echogithub not installed")
    d <- desc::desc(desc_path)
    res <- echogithub:::description_authors(desc_file = d,
                                            names_only = TRUE,
                                            verbose = FALSE)
    testthat::expect_true(is.character(res))
    testthat::expect_true(nchar(res) > 0)
    ## Should contain the known first author
    testthat::expect_true(grepl("Brian", res))
    testthat::expect_true(grepl("Schilder", res))
})

test_that("description_authors returns full author info when names_only=FALSE", {
    testthat::skip_if_not_installed("desc")
    desc_path <- system.file("DESCRIPTION", package = "echogithub")
    testthat::skip_if(desc_path == "", message = "echogithub not installed")
    d <- desc::desc(desc_path)
    res <- echogithub:::description_authors(desc_file = d,
                                            names_only = FALSE,
                                            verbose = FALSE)
    testthat::expect_true(is.character(res))
    ## Should have email or role info when names_only=FALSE
    testthat::expect_true(nchar(res) > 0)
})

test_that("description_authors with add_html=TRUE wraps in HTML tags", {
    testthat::skip_if_not_installed("desc")
    desc_path <- system.file("DESCRIPTION", package = "echogithub")
    testthat::skip_if(desc_path == "", message = "echogithub not installed")
    d <- desc::desc(desc_path)
    res <- echogithub:::description_authors(desc_file = d,
                                            names_only = TRUE,
                                            add_html = TRUE,
                                            verbose = FALSE)
    testthat::expect_true(grepl("<h4>", res))
    testthat::expect_true(grepl("<i>", res))
    testthat::expect_true(grepl("Authors:", res))
})

test_that("description_authors returns collapsed string for multiple authors", {
    testthat::skip_if_not_installed("desc")
    desc_path <- system.file("DESCRIPTION", package = "echogithub")
    testthat::skip_if(desc_path == "", message = "echogithub not installed")
    d <- desc::desc(desc_path)
    res <- echogithub:::description_authors(desc_file = d,
                                            names_only = TRUE,
                                            verbose = FALSE)
    ## echogithub has multiple authors, so there should be a comma separator
    testthat::expect_true(grepl(",", res))
})

## ---- description_extract_i ----

test_that("description_extract_i extracts default fields", {
    testthat::skip_if_not_installed("desc")
    testthat::skip_if_not_installed("rworkflows")
    desc_path <- system.file("DESCRIPTION", package = "echogithub")
    testthat::skip_if(desc_path == "", message = "echogithub not installed")
    d <- desc::desc(desc_path)
    res <- echogithub:::description_extract_i(
        desc_file = d,
        fields = c("owner", "repo", "authors"),
        verbose = FALSE
    )
    testthat::expect_true(is.list(res))
    testthat::expect_true("owner" %in% names(res))
    testthat::expect_true("repo" %in% names(res))
    testthat::expect_true("authors" %in% names(res))
})

test_that("description_extract_i extracts owner correctly", {
    testthat::skip_if_not_installed("desc")
    testthat::skip_if_not_installed("rworkflows")
    desc_path <- system.file("DESCRIPTION", package = "echogithub")
    testthat::skip_if(desc_path == "", message = "echogithub not installed")
    d <- desc::desc(desc_path)
    res <- echogithub:::description_extract_i(
        desc_file = d,
        fields = c("owner"),
        verbose = FALSE
    )
    testthat::expect_equal(res$owner, "RajLabMSSM")
})

test_that("description_extract_i extracts repo correctly", {
    testthat::skip_if_not_installed("desc")
    testthat::skip_if_not_installed("rworkflows")
    desc_path <- system.file("DESCRIPTION", package = "echogithub")
    testthat::skip_if(desc_path == "", message = "echogithub not installed")
    d <- desc::desc(desc_path)
    res <- echogithub:::description_extract_i(
        desc_file = d,
        fields = c("repo"),
        verbose = FALSE
    )
    testthat::expect_equal(res$repo, "echogithub")
})

test_that("description_extract_i returns NULL when desc_file is NULL", {
    testthat::skip_if_not_installed("rworkflows")
    res <- echogithub:::description_extract_i(desc_file = NULL,
                                              verbose = FALSE)
    testthat::expect_null(res)
})

test_that("description_extract_i extracts DESCRIPTION-native fields", {
    testthat::skip_if_not_installed("desc")
    testthat::skip_if_not_installed("rworkflows")
    desc_path <- system.file("DESCRIPTION", package = "echogithub")
    testthat::skip_if(desc_path == "", message = "echogithub not installed")
    d <- desc::desc(desc_path)
    res <- echogithub:::description_extract_i(
        desc_file = d,
        fields = c("Package", "Version"),
        verbose = FALSE
    )
    testthat::expect_true("Package" %in% names(res))
    testthat::expect_equal(res$Package, "echogithub")
})

test_that("description_extract_i as_datatable returns data.table", {
    testthat::skip_if_not_installed("desc")
    testthat::skip_if_not_installed("rworkflows")
    desc_path <- system.file("DESCRIPTION", package = "echogithub")
    testthat::skip_if(desc_path == "", message = "echogithub not installed")
    d <- desc::desc(desc_path)
    res <- echogithub:::description_extract_i(
        desc_file = d,
        fields = c("Package"),
        as_datatable = TRUE,
        verbose = FALSE
    )
    testthat::expect_true(data.table::is.data.table(res))
})

test_that("description_extract_i extracts github_url field", {
    testthat::skip_if_not_installed("desc")
    testthat::skip_if_not_installed("rworkflows")
    desc_path <- system.file("DESCRIPTION", package = "echogithub")
    testthat::skip_if(desc_path == "", message = "echogithub not installed")
    d <- desc::desc(desc_path)
    res <- echogithub:::description_extract_i(
        desc_file = d,
        fields = c("github_url"),
        verbose = FALSE
    )
    testthat::expect_true("github_url" %in% names(res))
    testthat::expect_true(grepl("github.com", res$github_url))
})
