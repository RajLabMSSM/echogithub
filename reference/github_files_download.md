# Download files from GitHub

Download files from GitHub, e.g. those that have been found with
[github_files](https://rajlabmssm.github.io/echogithub/reference/github_files.md).

## Usage

``` r
github_files_download(
  filelist,
  token = gh::gh_token(),
  download_dir = tempdir(),
  overwrite = FALSE,
  timeout = 5 * 60,
  nThread = 1,
  verbose = TRUE
)
```

## Arguments

- filelist:

  A list of remote URLs to download from GitHub.

- token:

  GitHub Personal Authentication Token (PAT). See [here for further
  instructions](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token).

- download_dir:

  Directory to download files into.

- overwrite:

  If a local file already exists, overwrite it.

- timeout:

  How long to wait before timing out during queries/downloads (in units
  of seconds).

- nThread:

  Number of threads to parallelize queries/downloads across.

- verbose:

  Print messages.

## Examples

``` r
if (FALSE) { # \dontrun{
dt <- github_files(owner = "RajLabMSSM",
                   repo = "Fine_Mapping_Shiny",
                   query = ".md$")
filelist_local <- github_files_download(filelist = dt$link_raw)
} # }
```
