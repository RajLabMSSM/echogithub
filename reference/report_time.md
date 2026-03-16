# Report time

Report time at end of function.

## Usage

``` r
report_time(
  start,
  end = Sys.time(),
  prefix = NULL,
  verbose = TRUE,
  units = "min",
  digits = 2
)
```

## Arguments

- units:

  character string. Units in which the results are desired. Can be
  abbreviated.

- digits:

  integer indicating the number of decimal places (`round`) or
  significant digits (`signif`) to be used. For `round`, negative values
  are allowed (see ‘Details’).
