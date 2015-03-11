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
                        region = "us-east-1", root_size = 16,
                        security_group = "docker-machine",
                        zone = "a", iam = NULL,
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

  if(!cores %in% names(machines)) stop(productivus::pp("Choose a valid number of cores from: #{names(machines)}"))
  ec2 <- list()
  ec2$access_key <- paste("--amazonec2-access-key", getOption("dokk.AWS_ACCESS_KEY_ID") %||% Sys.getenv('AWS_ACCESS_KEY_ID'))
  ec2$secret_key <- paste("--amazonec2-secret-key", getOption("dokk.AWS_SECRET_KEY") %||% Sys.getenv('AWS_SECRET_KEY'))
  ec2$vpc_id <- paste("--amazonec2-vpc-id", vpc_id)
  ec2$instance_type <- paste("--amazonec2-instance-type", machines[[cores]])
  ec2$region <- paste("--amazonec2-region", region)
  ec2$root_size <- paste("--amazonec2-root-size", root_size)
  ec2$security_group <- paste("--amazonec2-security-group", security_group)
  ec2$zone <- paste("--amazonec2-zone", zone)
  ec2$iam <- ifelse(is.null(iam), "", paste("--amazonec2-iam-instance-profile", iam))
  ec2$session_token <- ifelse(is.null(session_token), "", paste("--amazonec2-session-token", session_token))
  ec2$subnet_id <- ifelse(is.null(subnet_id), "", paste("--amazonec2-subnet-id", subnet_id))
  ec2creds <- paste0(ec2, collapse = " ")
  system(paste0("docker-machine create --driver amazonec2 ", ec2creds, " ", name))
}
