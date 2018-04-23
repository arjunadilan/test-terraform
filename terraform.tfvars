aws_region = "us-east-1"

aws_profile = "laTerraAnsible"

#------------ Key file ----------
wpa_key_name = "boogyman"

public_key_file = "/Users/dilan/.ssh/kryptonite.pub"

#--------------CIDRS Map -------

cidrs = {
  vpc_cidr       = "10.0.0.0/16"
  nacl_cidr_main = "10.0.0.0/16"
  default_cidr   = "0.0.0.0/0"
  temasys_pub_1  = "10.0.1.0/24"
  temasys_pub_2  = "10.0.2.0/24"
  temasys_pri_1  = "10.0.3.0/24"
  temasys_pri_2  = "10.0.4.0/24"
  temasys_rds_1  = "10.0.5.0/24"
  temasys_rds_2  = "10.0.6.0/24"
  temasys_rds_3  = "10.0.7.0/24"
}

#------------- RDS Details

db_class = "db.t2.small"

db_username = "admin"

db_password = "123456"

ec2_type = "t2.small"

ec2_ami = "ami-e2adf99e"
