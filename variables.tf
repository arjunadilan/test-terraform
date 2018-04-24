variable "aws_region" {}
variable "aws_profile" {}
variable "domain_name" {}

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

#---------------ELB----------

variable "elb_healthy_threshold" {}
variable "elb_unhelthy_threshold" {}
variable "elb_timeout" {}
variable "elb_interval" {}

#-------------lounch configuration

variable "as_max" {}
variable "as_min" {}
variable "health_check" {}
variable "asg_hct" {}
variable "asg_capt" {}

variable "delegation_set" {}
