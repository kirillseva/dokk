#' Remove docker machine.
#'
#' Remove a machine. This will remove the
#' local reference as well as delete it on the cloud provider or
#' virtualization management platform.
#'
#' @param name character. Name of the machine.
#'
#' @export
machine_rm <- function(name) {
  stopifnot(is.character(name) && length(name) == 1)
  system(paste0("docker-machine rm ", name))
}

#' Config.
#'
#' Show the Docker client configuration for a machine.
#'
#' @param name character. Name of the machine.
#'
#' @export
machine_config <- function(name) {
  stopifnot(is.character(name) && length(name) == 1)
  conf <- system(paste0("docker-machine config ", name), intern = TRUE)
  paste0(conf, collapse = " ")
}

#' ip.
#'
#' Get the IP address of a machine.
#'
#' @param name character. Name of the machine.
#'
#' @export
machine_ip <- function(name) {
  stopifnot(is.character(name) && length(name) == 1)
  conf <- system(paste0("docker-machine ip ", name), intern = TRUE)
  paste0(conf, collapse = " ")
}

#' URL.
#'
#' Get the URL of a host.
#'
#' @param name character. Name of the machine.
#'
#' @export
machine_url <- function(name) {
  stopifnot(is.character(name) && length(name) == 1)
  conf <- system(paste0("docker-machine url ", name), intern = TRUE)
  paste0(conf, collapse = " ")
}

#' start.
#'
#' Gracefully start a machine.
#'
#' @param name character. Name of the machine.
#'
#' @export
machine_start <- function(name) {
  stopifnot(is.character(name) && length(name) == 1)
  system(paste0("docker-machine start ", name))
}

#' stop.
#'
#' Gracefully stop a machine.
#'
#' @param name character. Name of the machine.
#'
#' @export
machine_stop <- function(name) {
  stopifnot(is.character(name) && length(name) == 1)
  system(paste0("docker-machine stop ", name))
}

#' restart.
#'
#' Restart a machine. Oftentimes this is equivalent
#' to \code{docker-machine stop; machine start}.
#'
#' @param name character. Name of the machine.
#'
#' @export
machine_restart <- function(name) {
  stopifnot(is.character(name) && length(name) == 1)
  system(paste0("docker-machine restart ", name))
}

#' ssh.
#'
#' Log into a machine using SSH.
#'
#' @param name character. Name of the machine.
#'
#' @export
machine_ssh <- function(name) {
  stopifnot(is.character(name) && length(name) == 1)
  system(paste0("docker-machine ssh ", name))
}
