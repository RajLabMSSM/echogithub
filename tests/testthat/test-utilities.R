## ---- split_batches ----

test_that("split_batches splits vector into correct number of batches", {
    v <- 1:100
    res <- echogithub:::split_batches(v, n_batches = 10)
    testthat::expect_true(is.list(res))
    testthat::expect_equal(length(res), 10)
    ## All elements should be present
    testthat::expect_equal(sort(unlist(res, use.names = FALSE)), v)
})

test_that("split_batches handles small vectors", {
    v <- 1:3
    res <- echogithub:::split_batches(v, n_batches = 10)
    testthat::expect_true(is.list(res))
    ## Each element should get its own batch when n_batches > length(v)
    testthat::expect_equal(sort(unlist(res, use.names = FALSE)), v)
})

test_that("split_batches handles single element", {
    v <- 42
    res <- echogithub:::split_batches(v, n_batches = 5)
    testthat::expect_true(is.list(res))
    testthat::expect_equal(length(res), 1)
    testthat::expect_equal(unlist(res, use.names = FALSE), 42)
})

test_that("split_batches with custom batch_size", {
    v <- 1:20
    res <- echogithub:::split_batches(v, batch_size = 5)
    testthat::expect_equal(length(res), 4)
    testthat::expect_equal(length(res[[1]]), 5)
})

test_that("split_batches with character vector", {
    v <- letters[1:12]
    res <- echogithub:::split_batches(v, n_batches = 3)
    testthat::expect_true(is.list(res))
    testthat::expect_equal(sort(unlist(res, use.names = FALSE)), sort(v))
})

## ---- author_fields ----

test_that("author_fields returns expected field names", {
    res <- echogithub:::author_fields()
    testthat::expect_true(is.character(res))
    testthat::expect_true(length(res) > 0)
    testthat::expect_true("Authors@R" %in% res)
    testthat::expect_true("Author" %in% res)
    testthat::expect_true("authors" %in% res)
})

test_that("author_fields returns consistent results", {
    res1 <- echogithub:::author_fields()
    res2 <- echogithub:::author_fields()
    testthat::expect_identical(res1, res2)
})

## ---- check_pkgs ----

test_that("check_pkgs converts character vector to data.table", {
    pkgs <- c("ggplot2", "data.table", "dplyr")
    res <- echogithub:::check_pkgs(pkgs)
    testthat::expect_true(data.table::is.data.table(res))
    testthat::expect_true("package" %in% names(res))
    testthat::expect_equal(nrow(res), 3)
    testthat::expect_equal(res$package, pkgs)
})

test_that("check_pkgs passes through data.table unchanged", {
    dt <- data.table::data.table(package = c("ggplot2", "dplyr"),
                                 version = c("3.4.0", "1.1.0"))
    res <- echogithub:::check_pkgs(dt)
    testthat::expect_true(data.table::is.data.table(res))
    testthat::expect_equal(nrow(res), 2)
    testthat::expect_true("version" %in% names(res))
})

test_that("check_pkgs handles single package", {
    res <- echogithub:::check_pkgs("ggplot2")
    testthat::expect_true(data.table::is.data.table(res))
    testthat::expect_equal(nrow(res), 1)
    testthat::expect_equal(res$package, "ggplot2")
})

## ---- report_time ----

test_that("report_time works with default units", {
    start <- Sys.time() - 120  ## 2 minutes ago
    end <- Sys.time()
    ## Should print a message, not error
    testthat::expect_message(
        echogithub:::report_time(start = start, end = end, verbose = TRUE),
        "Done in"
    )
})

test_that("report_time respects verbose=FALSE", {
    start <- Sys.time() - 60
    end <- Sys.time()
    testthat::expect_no_message(
        echogithub:::report_time(start = start, end = end, verbose = FALSE)
    )
})

test_that("report_time works with different units", {
    start <- Sys.time() - 3600  ## 1 hour ago
    end <- Sys.time()
    testthat::expect_message(
        echogithub:::report_time(start = start, end = end,
                                 units = "secs", verbose = TRUE),
        "secs"
    )
    testthat::expect_message(
        echogithub:::report_time(start = start, end = end,
                                 units = "hours", verbose = TRUE),
        "hours"
    )
})

test_that("report_time includes prefix", {
    start <- Sys.time() - 10
    end <- Sys.time()
    testthat::expect_message(
        echogithub:::report_time(start = start, end = end,
                                 prefix = "MyFunc", verbose = TRUE),
        "Myfunc done in"
    )
})

## ---- stopper ----

test_that("stopper throws error when v=TRUE", {
    testthat::expect_error(
        echogithub:::stopper("Something went wrong", v = TRUE),
        "Something went wrong"
    )
})

test_that("stopper throws blank error when v=FALSE", {
    testthat::expect_error(
        echogithub:::stopper("Something went wrong", v = FALSE)
    )
})

test_that("stopper concatenates multiple arguments", {
    testthat::expect_error(
        echogithub:::stopper("Error:", "file not found", v = TRUE),
        "Error: file not found"
    )
})

## ---- is_url ----

test_that("is_url detects http URLs", {
    testthat::expect_true(
        echogithub:::is_url("http://example.com", check_exists = FALSE)
    )
})

test_that("is_url detects https URLs", {
    testthat::expect_true(
        echogithub:::is_url("https://github.com/user/repo",
                            check_exists = FALSE)
    )
})

test_that("is_url detects ftp URLs", {
    testthat::expect_true(
        echogithub:::is_url("ftp://data.example.com/file.txt",
                            check_exists = FALSE)
    )
})

test_that("is_url rejects non-URLs", {
    testthat::expect_false(
        echogithub:::is_url("/local/path/to/file", check_exists = FALSE)
    )
    testthat::expect_false(
        echogithub:::is_url("just_a_string", check_exists = FALSE)
    )
    testthat::expect_false(
        echogithub:::is_url("file.txt", check_exists = FALSE)
    )
})

test_that("is_url returns FALSE for NULL input", {
    testthat::expect_false(echogithub:::is_url(NULL, check_exists = FALSE))
})

test_that("is_url is case-insensitive for protocol", {
    testthat::expect_true(
        echogithub:::is_url("HTTP://EXAMPLE.COM", check_exists = FALSE)
    )
    testthat::expect_true(
        echogithub:::is_url("Https://Example.com", check_exists = FALSE)
    )
})

test_that("is_url with custom protocols", {
    testthat::expect_true(
        echogithub:::is_url("http://example.com",
                            protocols = c("http"),
                            check_exists = FALSE)
    )
    testthat::expect_false(
        echogithub:::is_url("ftp://example.com",
                            protocols = c("http", "https"),
                            check_exists = FALSE)
    )
})

## ---- add_owner_repo ----

test_that("add_owner_repo creates owner_repo from owner and repo columns", {
    dt <- data.table::data.table(owner = c("user1", "user2"),
                                 repo = c("repoA", "repoB"))
    res <- echogithub::add_owner_repo(dt)
    testthat::expect_true("owner_repo" %in% names(res))
    testthat::expect_equal(res$owner_repo, c("user1/repoA", "user2/repoB"))
})

test_that("add_owner_repo creates ref column by default", {
    dt <- data.table::data.table(owner = c("user1", "user2"),
                                 repo = c("repoA", "repoB"))
    res <- echogithub::add_owner_repo(dt, add_ref = TRUE)
    testthat::expect_true("ref" %in% names(res))
    ## ref should be coalesced from owner_repo (and repo)
    testthat::expect_false(any(is.na(res$ref)))
})

test_that("add_owner_repo with add_ref=FALSE does not add ref column", {
    dt <- data.table::data.table(owner = c("user1"),
                                 repo = c("repoA"))
    res <- echogithub::add_owner_repo(dt, add_ref = FALSE)
    testthat::expect_false("ref" %in% names(res))
})

test_that("add_owner_repo handles custom separator", {
    dt <- data.table::data.table(owner = c("user1"),
                                 repo = c("repoA"))
    res <- echogithub::add_owner_repo(dt, sep = "::")
    testthat::expect_equal(res$owner_repo, "user1::repoA")
})

test_that("add_owner_repo handles NA owner", {
    dt <- data.table::data.table(owner = c("user1", NA),
                                 repo = c("repoA", "repoB"))
    res <- echogithub::add_owner_repo(dt)
    testthat::expect_true(is.na(res$owner_repo[2]))
})

test_that("add_owner_repo handles NA repo", {
    dt <- data.table::data.table(owner = c("user1", "user2"),
                                 repo = c("repoA", NA))
    res <- echogithub::add_owner_repo(dt)
    testthat::expect_true(is.na(res$owner_repo[2]))
})

test_that("add_owner_repo handles subaction column", {
    dt <- data.table::data.table(subaction = c("user1/repoA", "user2/repoB"))
    res <- echogithub::add_owner_repo(dt)
    testthat::expect_true("owner_repo" %in% names(res))
    testthat::expect_equal(res$owner_repo, c("user1/repoA", "user2/repoB"))
})

test_that("add_owner_repo converts data.frame to data.table", {
    df <- data.frame(owner = "user1", repo = "repoA",
                     stringsAsFactors = FALSE)
    res <- echogithub::add_owner_repo(df)
    testthat::expect_true(data.table::is.data.table(res))
    testthat::expect_true("owner_repo" %in% names(res))
})

test_that("add_owner_repo replaces sep in target column", {
    dt <- data.table::data.table(owner = "user1", repo = "repoA",
                                 target = "org/proj")
    res <- echogithub::add_owner_repo(dt, sep = "::")
    testthat::expect_equal(res$target, "org::proj")
})

## ---- r_repos_upset_queries ----

test_that("r_repos_upset_queries returns list when conditions met", {
    testthat::skip_if_not_installed("UpSetR")
    res <- echogithub::r_repos_upset_queries(which = NULL, upset_plot = TRUE)
    testthat::expect_true(is.list(res))
    testthat::expect_equal(length(res), 1)
    testthat::expect_true("color" %in% names(res[[1]]))
    testthat::expect_equal(res[[1]]$color, "darkred")
})

test_that("r_repos_upset_queries returns NULL when upset_plot=FALSE", {
    res <- echogithub::r_repos_upset_queries(which = NULL, upset_plot = FALSE)
    testthat::expect_null(res)
})

test_that("r_repos_upset_queries returns list when highlight in which", {
    testthat::skip_if_not_installed("UpSetR")
    res <- echogithub::r_repos_upset_queries(which = c("GitHub", "CRAN"),
                                 highlight = list("GitHub"))
    testthat::expect_true(is.list(res))
})

test_that("r_repos_upset_queries returns NULL when highlight not in which", {
    res <- echogithub::r_repos_upset_queries(which = c("CRAN", "Bioc"),
                                 highlight = list("GitHub"))
    testthat::expect_null(res)
})

test_that("r_repos_upset_queries uses custom color", {
    testthat::skip_if_not_installed("UpSetR")
    res <- echogithub::r_repos_upset_queries(which = NULL, color = "blue")
    testthat::expect_equal(res[[1]]$color, "blue")
})

## ---- r_repos_data_cast ----

test_that("r_repos_data_cast casts long data with downloads column", {
    pkgs <- data.table::data.table(
        package = rep(c("pkgA", "pkgB"), each = 2),
        installed = rep(TRUE, 4),
        r_repo = rep(c("CRAN", "GitHub"), 2),
        downloads = c(100, 50, 200, 80)
    )
    res <- echogithub:::r_repos_data_cast(pkgs, verbose = FALSE)
    testthat::expect_true(data.table::is.data.table(res))
    testthat::expect_true("total_downloads" %in% names(res))
    testthat::expect_true("CRAN" %in% names(res))
    testthat::expect_true("GitHub" %in% names(res))
    testthat::expect_equal(nrow(res), 2)
})

test_that("r_repos_data_cast sorts by total_downloads descending", {
    pkgs <- data.table::data.table(
        package = rep(c("pkgA", "pkgB"), each = 2),
        installed = rep(TRUE, 4),
        r_repo = rep(c("CRAN", "GitHub"), 2),
        downloads = c(10, 5, 200, 80)
    )
    res <- echogithub:::r_repos_data_cast(pkgs, verbose = FALSE)
    testthat::expect_true(res$total_downloads[1] >= res$total_downloads[2])
})

test_that("r_repos_data_cast without downloads column uses logical", {
    pkgs <- data.table::data.table(
        package = rep(c("pkgA", "pkgB"), each = 2),
        installed = rep(TRUE, 4),
        r_repo = rep(c("CRAN", "GitHub"), 2)
    )
    res <- echogithub:::r_repos_data_cast(pkgs, verbose = FALSE)
    testthat::expect_true(data.table::is.data.table(res))
    testthat::expect_true("CRAN" %in% names(res))
    testthat::expect_true("GitHub" %in% names(res))
    ## Values should be logical
    testthat::expect_true(is.logical(res$CRAN))
    testthat::expect_true(is.logical(res$GitHub))
})

test_that("r_repos_data_cast prints message when verbose", {
    pkgs <- data.table::data.table(
        package = c("pkgA", "pkgA"),
        installed = c(TRUE, TRUE),
        r_repo = c("CRAN", "GitHub"),
        downloads = c(100, 50)
    )
    testthat::expect_message(
        echogithub:::r_repos_data_cast(pkgs, verbose = TRUE),
        "Casting data"
    )
})
