# R repos upset plot queries

Function to generate queries passed to .

## Usage

``` r
r_repos_upset_queries(
  which,
  upset_plot = TRUE,
  highlight = list("GitHub"),
  color = "darkred"
)
```

## Arguments

- which:

  Which R repositories to extract data from.

- upset_plot:

  Whether to create an upset plot showing R package overlap between
  repositories.

- highlight:

  Groups to highlight.

- color:

  Highlight color.

## Value

Named list of query parameters

## Examples

``` r
if (FALSE) { # \dontrun{
queries <- r_repos_upset_queries(which=NULL)
} # }
```
