variable "aws_region" {}
variable "aws_profile" {}

#---------- Key File -----
variable "wpa_key_name" {}

variable "public_key_file" {}

variable cidrs {
  type = "map"
}

#---------- Availability Zones ----------

data "aws_availability_zones" "available" {}

#----------- RDS Details  ---------

variable "db_class" {}

variable "db_username" {}

variable "db_password" {}

#------------- EC2 deatils ---------

variable "ec2_type" {}
variable "ec2_ami" {}
