# Check if the input is url e.g. http:// or ftp://

Check if the input is url e.g. http:// or ftp://

## Usage

``` r
is_url(
  path,
  protocols = c("http", "https", "ftp", "ftps", "fttp", "fttps"),
  check_exists = TRUE
)
```

## Source

[Borrowed from `seqminer` internal
function](https://rdrr.io/cran/seqminer/src/R/seqminer.R)

## Arguments

- path:

  Path to local file or remote URL.

- protocols:

  URL protocols to search for.

- check_exists:

  Throw an error if the remote file does not exist.
