# Description authors

Parse authors from the *DESCRIPTION* file of an R package.

## Usage

``` r
description_authors(
  desc_file,
  names_only = TRUE,
  add_html = FALSE,
  verbose = TRUE
)
```

## Arguments

- desc_file:

  When `owner` or `repo` are NULL, these arguments are inferred from the
  *DESCRIPTION* file.

- names_only:

  Only return author names (and not other subfields). For example: "Jim
  Hester \\james.f.hester\\gmail.com\\ \\aut\\" would become "Jim
  Hester".

- add_html:

  Add HTML styling to certain fields (e.g "authors").

- verbose:

  Print messages.

## Value

Authors as an HTML character string.
