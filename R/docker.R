#' Run \code{docker build} in a directory
#'
#' @param machine_name character. Existing Docker Machine machine_name.
#' @param dir character. Directory that contains a Dockerfile
#' @param params character. Additional parameters for \code{docker build}
#' @param intern logical. If set to TRUE the building process will be invisible,
#' and the function will return the hash of the built image. If false,
#' the build steps will be shown, but the function will return the exit status
#'
#' @export
build_image <- function(machine_name, dir = ".", params = "", intern = TRUE) {
  stopifnot(is.character(dir) && length(dir) == 1)
  stopifnot(is.character(params) && length(params) == 1)
  stopifnot(is.character(machine_name) && length(machine_name) == 1)

  flags <- paste0("$(docker-machine config ", machine_name, ")")
  cat("Building your image...\n")
  if (isTRUE(intern)) {
    built <- system(paste0("docker ", flags, " build ", params, " ", dir), intern = intern)
    if(str_split(built[length(built)], " ")[[1]][1] == "Successfully") {
      hash <- str_split(built[length(built)], " ")[[1]][3]
      cat("Successfully built ", hash, "\n")
      hash
    } else {
      cat("Something went wrong!\n")
      print(built)
      FALSE
    }
  } else {
    system(paste0("docker ", flags, " build ", params, " ", dir))
  }
}

#' Run your container in the docker machine
#'
#' @param machine_name character. Existing Docker Machine machine_name.
#' @param image character. A hash or a tag of docker image to be run.
#' @param params character. Additional parameters for \code{docker run}, i.e. \code{-ti}.
#' @param command character. The command to be executed in the container. Leave blank for default CMD.
#'
#' @export
run_image <- function(machine_name, image, params = "", command = "") {
  stopifnot(is.character(image) && length(image) == 1)
  stopifnot(is.character(params) && length(params) == 1)
  stopifnot(is.character(machine_name) && length(machine_name) == 1)
  stopifnot(is.character(command) && length(command) == 1)

  flags <- paste0("$(docker-machine config ", machine_name, ")")
  system(paste0("docker ", flags, " run ", params, " ", image, " ", command))
}
