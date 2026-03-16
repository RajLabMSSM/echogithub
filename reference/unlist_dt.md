# Unlist a [data.table](https://rdrr.io/pkg/data.table/man/data.table.html)

Identify columns that are lists and turn them into vectors.

## Usage

``` r
unlist_dt(dt, exclude = NULL, verbose = TRUE)
```

## Arguments

- dt:

  A [data.table](https://rdrr.io/pkg/data.table/man/data.table.html).

- exclude:

  Columns to exclude from unlisting.

- verbose:

  Print messages.

## Value

`dt` with list columns turned into vectors.
