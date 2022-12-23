.onLoad <- function(libname, pkgname){
    requireNamespace("data.table")
    .datatable.aware <- TRUE 
    data.table::setDTthreads(threads = 1)
}
