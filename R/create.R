#' Create a local docker machine, driver = virtualbox
#'
#' @param name character. Name of the machine.
#'
#' @export
machine_local <- function(name) {
  stopifnot(is.character(name) && length(name) == 1)
  system(paste0("docker-machine create --driver virtualbox ", name))
}
