
variable "regions" {
  type = "list"
  default = [
    "us-east-1",
    "us-west-1",
    "us-west-2",
    "eu-west-1",
    "eu-central-1",
    "ap-northeast-1",
    "ap-northeast-2",
    "ap-southeast-1",
    "ap-southeast-2",
    "ap-south-1",
    "sa-east-1"
  ]
}

variable "availability_zones" {
  type = "map"
  default = {
    us-east-1 = [
      "us-east-1b",
      "us-east-1c",
      "us-east-1d",
      "us-east-1e"
    ]
    us-west-1 = [
      "us-west-1b",
      "us-west-1c"
    ]
    us-west-2 = [
      "us-west-2a",
      "us-west-2b",
      "us-west-2c"
    ]
    eu-west-1 = [
      "eu-west-1a",
      "eu-west-1b",
      "eu-west-1c"
    ]
    eu-central-1 = [
      "eu-central-1a",
      "eu-central-1b"
    ]
    ap-northeast-1 = [
      "ap-northeast-1a",
      "ap-northeast-1c"
    ]
    ap-northeast-2 = [
      "ap-northeast-2a",
      "ap-northeast-2c"
    ]
    ap-southeast-1 = [
      "ap-southeast-1a",
      "ap-southeast-1b"
    ]
    ap-southeast-2 = [
      "ap-southeast-2a",
      "ap-southeast-2b",
      "ap-southeast-2c"
    ]
    ap-south-1 = [
      "ap-south-1a",
      "ap-south-1b"
    ]
    sa-east-1 = [
      "sa-east-1a",
      "sa-east-1c"
    ]
  }
}

variable "elb_principals" {
  type = "map"
  default = {
    us-east-1 = "127311923021"
    us-west-1 = "027434742980"
    us-west-2 = "797873946194"
    eu-west-1 = "156460612806"
    eu-central-1 = "054676820928"
    ap-northeast-1 = "582318560864"
    ap-northeast-2 = "600734575887"
    ap-southeast-1 = "114774131450"
    ap-southeast-2 = "783225319266"
    ap-south-1 = "718504428378"
    sa-east-1 = "507241528517"
  }
}

variable "device_alphabets" {
  type = "list"
  default = [
    "b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"
  ]
}

variable "amis" {
  type = "map"
  default = {
    amazon_linux = "ami-0c11b26d"
    redhat = "ami-5de0433c"
  }
}