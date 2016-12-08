
# This is a sample configurations


# You have to pass ACCESS_TOKEN and secret TOKEN here or via environmental variables
provider "aws" {
  region = "ap-northeast-1"
}


module "http-cluster" {

  source = "../modules/ec2-cluster"

  account_id = "123456789012"
  public_key = "~/.ssh/aws-kensyu.pub"
  private_key = "~/.ssh/aws-kensyu"
  keypair_name = "aws_mizuno"

  region = "ap-northeast-1"

  shutdown_behavior = "terminate"
  volume_force_detach = true
  bucket_force_destroy = true
  termination_disable = false

  host_prefix = "mizuno"
  server_role = "web"
  domain = "saint.com"

  ami = "ami-0c11b26d"
  instance_type = "t2.micro"
  instance_count = 3

  volume_type = "gp2"
  volume_size = 10

  raid_factor = 2
  raid_level = 0
  raid_mount_dir = "/mnt/ebs/1"

  log_bucket = "saint11"
  log_bucket_prefix = "logs"

  // for logging
  log_paths = {
    messages = "/var/log/messages"
  }

  // for alert
  alert_rules = {
    CPUUtilization = 80
  }
  alert_statistics = "Average"

  // for load balancer
  instance_port = 80 // service port for each instance
  exposed_port = 80 // exposed port on load balancer
  lb_protocol = "HTTP"

  // for health checking
  healthcheck_path  = "/"
  healthy_threshold = 2
  unhealthy_threshold = 2
  healthcheck_interval = 20

  // testing with serverspec (required => 1, not required => 0)
  is_test_required = 1
}