#' Create a local docker machine, driver = virtualbox
#'
#' @param name character. Name of the machine.
#'
#' @export
machine_local <- function(name) {
  stopifnot(is.character(name) && length(name) == 1)
  system(paste0("docker-machine create --driver virtualbox ", name))
}

#' Create a docker machine on AWS.
#'
#' Defaults are pretty sensible. You must provide only the following:
#' \itemize{
#'   \item name. Name of the docker machine.
#'   \item cores. Number of cores. Defaults to 2.
#'   \item vpc_id. The id of your VPC.
#'   \item set options(dokk.AWS_ACCESS_KEY_ID) to your AWS access key.
#'   \item set options(dokk.AWS_SECRET_KEY) to your AWS secret.
#' }
#'
#' Note that this can be expensive, so make sure you clean up after yourself!
#'
#' Creates an EC2 instance for you.
#'
#' @param name character. Required. The name of the machine.
#' @param vpc_id character. Required. The VPC id. Get it from AWS console.
#' @param cores integer. Number of cores. More cores = more expensive!
#' @param ami character. AMI to use. Don't touch if you don't know what you are doing.
#' If you do, then see https://docs.docker.com/machine/#drivers for more details.
#'
#' @param region character. EC2 region. Default is us-east-1.
#' @param root_size integer. The root disk size of the instance (in GB). Default: 16
#' @param security_group character. AWS VPC security group name. Default: docker-machine
#' @param session_token character. Your session token for the Amazon Web Services API.
#' @param subnet_id character. AWS VPC subnet id.
#' @param iam character. IAM role for the instance.
#' @param zone character.  The AWS zone launch the instance in (i.e. one of a,b,c,d,e). Default: a
#'
#' @export
machine_AWS <- function(name, vpc_id, cores = 2, ami = "ami-4ae27e22",
                        root_size = 16, security_group = "docker-machine",
                        zone = "a", iam = NULL, region = NULL,
                        session_token = NULL, subnet_id = NULL) {
  machines <- list(
    `2` = "r3.large",
    `4` = "r3.xlarge",
    `8` = "c4.2xlarge",
    `16`= "c4.4xlarge",
    `36`= "c4.8xlarge"
  )
  stopifnot(length(cores) == 1)
  stopifnot(is.character(name) && length(name) == 1)
  stopifnot(is.character(ami) && length(ami) == 1)

  if(!cores %in% names(machines)) stop("Choose a valid number of cores from:", paste(names(machines), sep='; '))
  ec2 <- list()
  ec2$access_key <- paste("--amazonec2-access-key", getOption("dokk.AWS_ACCESS_KEY_ID") %||% Sys.getenv('AWS_ACCESS_KEY_ID'))
  ec2$secret_key <- paste("--amazonec2-secret-key", getOption("dokk.AWS_SECRET_KEY") %||% Sys.getenv('AWS_SECRET_KEY'))
  ec2$vpc_id <- paste("--amazonec2-vpc-id", vpc_id)
  ec2$instance_type <- paste("--amazonec2-instance-type", machines[[paste(cores)]])
  ec2$root_size <- paste("--amazonec2-root-size", root_size)
  ec2$security_group <- paste("--amazonec2-security-group", security_group)
  ec2$zone <- paste("--amazonec2-zone", zone)
  ec2$iam <- ifelse(is.null(iam), "", paste("--amazonec2-iam-instance-profile", iam))
  ec2$session_token <- ifelse(is.null(session_token), "", paste("--amazonec2-session-token", session_token))
  ec2$subnet_id <- ifelse(is.null(subnet_id), "", paste("--amazonec2-subnet-id", subnet_id))
  ec2$region <- ifelse(is.null(region), "", paste("--amazonec2-region", region))
  ec2creds <- paste0(ec2, collapse = " ")
  system(paste0("docker-machine create --driver amazonec2 ", ec2creds, " ", name))
}

#' Create a docker machine on Digital Ocean.
#'
#' Defaults are pretty sensible. You must provide only the following:
#' \itemize{
#'   \item name. Name of the docker machine.
#'   \item size. The size of the droplet. Defaults to 2gb.
#'   \item set options(dokk.DIGITAL_OCEAN_ACCESS_TOKEN) to your digitalocean access token.
#' }
#'
#' Note that this can be expensive, so make sure you clean up after yourself!
#'
#' Creates a digital ocean droplet for you.
#' The DigitalOcean driver will use ubuntu-14-04-x64 as the default image.
#'
#' @param name character. Required. The name of the machine.
#' @param size character. The size of the droplet. More memory - more expensive!
#' @param image character. The name of the Digital Ocean image to use. Default: docker
#' @param region character. The region to create the droplet in, see \code{Regions API} for how to get a list. Default: nyc3
#' @param ipv6 character. Enable IPv6 support for the droplet. Default: false
#' @param private_networking logical. Enable private networking support for the droplet. Default: false
#' @param backups logical. Enable Digital Oceans backups for the droplet. Default: false
#'
#' @export
machine_DigitalOcean <- function(name, size = '2gb', image = NULL, region = NULL,
                                 ipv6 = NULL, private_networking = NULL, backups = NULL) {
  available_memory <- c('512mb', '1gb', '2gb', '4gb', '8gb', '16gb', '32gb', '48gb', '64gb')
  stopifnot(length(size) == 1)
  if(!(size %in% available_memory))
    stop("Please set correct size. Available options are: ", paste(available_memory))

  do <- list()
  do$size <- paste("--digitalocean-size", size)
  do$access_token <- paste("--digitalocean-access-token", getOption("dokk.DIGITAL_OCEAN_ACCESS_TOKEN") %||% Sys.getenv('DIGITAL_OCEAN_ACCESS_TOKEN'))
  do$region <- ifelse(is.null(region), "", paste("--digitalocean-region", region))
  do$image <- ifelse(is.null(image), "", paste("--digitalocean-image", image))
  do$ipv6 <- ifelse(is.null(ipv6), "", paste("--digitalocean-ipv6", ipv6))
  do$private_networking <- ifelse(is.null(private_networking), "", paste("--digitalocean-private-networking", private_networking))
  do$backups <- ifelse(is.null(backups), "", paste("--digitalocean-backups", backups))
  DO_creds <- paste0(do, collapse = " ")
  system(paste0("docker-machine create --driver digitalocean ", DO_creds, " ", name))
}
