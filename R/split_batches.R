split_batches <- function(v,
                          n_batches=10,
                          batch_size=ceiling(length(v)/n_batches)){
    split(v, ceiling(seq_along(v)/batch_size))
}