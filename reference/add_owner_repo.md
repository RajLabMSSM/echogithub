# Add owner/repo

Try to add a new column named "owner_repo" that combines both the owner
of and name of each GitHub repository.

## Usage

``` r
add_owner_repo(
  dt,
  add_ref = TRUE,
  ref_cols = c("ref", "owner_repo", "repo", "package", "Package"),
  sep = "/"
)
```

## Arguments

- dt:

  [data.table](https://rdrr.io/pkg/data.table/man/data.table.html).

- add_ref:

  Coalesce multiple columns
  (`e.g. c("owner_repo","repo","package","Package")`) into a single
  "ref" column. Tries to fill in `NA` values as much as possible.

- ref_cols:

  Columns to consider when coalescing into the "ref" column.

- sep:

  Separator value between "owner" and "repo".

## Value

[data.table](https://rdrr.io/pkg/data.table/man/data.table.html).

## Examples

``` r
dt <- data.table::data.table(owner=letters, repo=LETTERS)
dt <- add_owner_repo(dt)
```
