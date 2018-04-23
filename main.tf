provider "aws" {
  region  = "${var.aws_region}"
  profile = "${var.aws_profile}"
}

resource "aws_key_pair" "keys" {
  key_name   = "${var.wpa_key_name}"
  public_key = "${file(var.public_key_file)}"
}

resource "aws_vpc" "teamsys-vpc1" {
  cidr_block           = "${var.cidrs["vpc_cidr"]}"
  enable_dns_hostnames = "True"
  enable_dns_support   = "True"

  tags {
    Name = "Temasys-VPC"
  }
}

resource "aws_network_acl" "teamsys-vpc1-nacl" {
  vpc_id = "${aws_vpc.teamsys-vpc1.id}"

  ingress {
    protocol   = "tcp"
    action     = "Allow"
    rule_no    = "110"
    to_port    = "80"
    from_port  = "80"
    cidr_block = "${var.cidrs["nacl_cidr_main"]}"
  }

  ingress {
    protocol   = "tcp"
    action     = "Allow"
    rule_no    = "120"
    to_port    = "22"
    from_port  = "22"
    cidr_block = "${var.cidrs["nacl_cidr_main"]}"
  }

  egress {
    protocol   = "tcp"
    action     = "Allow"
    rule_no    = "220"
    to_port    = "80"
    from_port  = "80"
    cidr_block = "${var.cidrs["nacl_cidr_main"]}"
  }

  egress {
    protocol   = "tcp"
    action     = "Allow"
    rule_no    = "240"
    to_port    = "22"
    from_port  = "22"
    cidr_block = "${var.cidrs["nacl_cidr_main"]}"
  }

  tags {
    Name = "Temasys_NACL"
  }
}

resource "aws_security_group" "temasys_ec2_sg" {
  name        = "temasys_ec2_sg"
  description = "EC2 Securtiy Group"
  vpc_id      = "${aws_vpc.teamsys-vpc1.id}"

  ingress {
    to_port     = "80"
    from_port   = "80"
    protocol    = "tcp"
    cidr_blocks = ["${var.cidrs["default_cidr"]}"]
  }

  ingress {
    to_port     = "22"
    from_port   = "22"
    protocol    = "tcp"
    cidr_blocks = ["${var.cidrs["default_cidr"]}"]
  }

  egress {
    to_port     = "0"
    from_port   = "0"
    protocol    = "-1"
    cidr_blocks = ["${var.cidrs["default_cidr"]}"]
  }

  tags {
    Name = "Ec2 SG"
  }
}

resource "aws_security_group" "temasys_rds_sg" {
  name        = "temasys_rds_sg"
  description = "RDS Security Group"
  vpc_id      = "${aws_vpc.teamsys-vpc1.id}"

  ingress {
    to_port         = "3306"
    from_port       = "3306"
    protocol        = "tcp"
    security_groups = ["${aws_security_group.temasys_ec2_sg.id}"]
  }
}

resource "aws_internet_gateway" "Temasys_IGW" {
  vpc_id = "${aws_vpc.teamsys-vpc1.id}"

  tags {
    Name = "Temasys_IGW"
  }
}

resource "aws_route_table" "temasys_public_rt" {
  vpc_id = "${aws_vpc.teamsys-vpc1.id}"

  route {
    cidr_block = "${var.cidrs["default_cidr"]}"
    gateway_id = "${aws_internet_gateway.Temasys_IGW.id}"
  }

  tags {
    Name = "Temasys_Public_rt"
  }
}

resource "aws_route_table" "temasys_private_rt" {
  vpc_id = "${aws_vpc.teamsys-vpc1.id}"
}

resource "aws_subnet" "temasys_pub_1" {
  vpc_id                  = "${aws_vpc.teamsys-vpc1.id}"
  cidr_block              = "${var.cidrs["temasys_pub_1"]}"
  map_public_ip_on_launch = "True"
  availability_zone       = "${data.aws_availability_zones.available.names[0]}"

  tags {
    Name = "PublicSub_1"
  }
}

resource "aws_subnet" "temasys_pub_2" {
  vpc_id                  = "${aws_vpc.teamsys-vpc1.id}"
  cidr_block              = "${var.cidrs["temasys_pub_2"]}"
  map_public_ip_on_launch = "True"
  availability_zone       = "${data.aws_availability_zones.available.names[1]}"

  tags {
    Name = "PublicSub_2"
  }
}

resource "aws_subnet" "temasys_pri_1" {
  vpc_id                  = "${aws_vpc.teamsys-vpc1.id}"
  cidr_block              = "${var.cidrs["temasys_pri_1"]}"
  map_public_ip_on_launch = "False"
  availability_zone       = "${data.aws_availability_zones.available.names[0]}"

  tags {
    Name = "PrivateSub_1"
  }
}

resource "aws_subnet" "temasys_pri_2" {
  vpc_id                  = "${aws_vpc.teamsys-vpc1.id}"
  cidr_block              = "${var.cidrs["temasys_pri_2"]}"
  map_public_ip_on_launch = "False"
  availability_zone       = "${data.aws_availability_zones.available.names[1]}"

  tags {
    Name = "PrivateSub_2"
  }
}

resource "aws_subnet" "temasys_rds_1" {
  vpc_id                  = "${aws_vpc.teamsys-vpc1.id}"
  cidr_block              = "${var.cidrs["temasys_rds_1"]}"
  map_public_ip_on_launch = "True"
  availability_zone       = "${data.aws_availability_zones.available.names[0]}"

  tags {
    Name = "temasys_rds_1"
  }
}

resource "aws_subnet" "temasys_rds_2" {
  vpc_id                  = "${aws_vpc.teamsys-vpc1.id}"
  cidr_block              = "${var.cidrs["temasys_rds_2"]}"
  map_public_ip_on_launch = "True"
  availability_zone       = "${data.aws_availability_zones.available.names[1]}"

  tags {
    Name = "temasys_rds_2"
  }
}

resource "aws_subnet" "temasys_rds_3" {
  vpc_id                  = "${aws_vpc.teamsys-vpc1.id}"
  cidr_block              = "${var.cidrs["temasys_rds_3"]}"
  map_public_ip_on_launch = "True"
  availability_zone       = "${data.aws_availability_zones.available.names[2]}"
}

resource "aws_route_table_association" "temasys_public_a" {
  route_table_id = "${aws_route_table.temasys_public_rt.id}"
  subnet_id      = "${aws_subnet.temasys_pub_1.id}"
}

resource "aws_route_table_association" "temasys_public_b" {
  route_table_id = "${aws_route_table.temasys_public_rt.id}"
  subnet_id      = "${aws_subnet.temasys_pub_2.id}"
}

resource "aws_route_table_association" "temasys_private_a" {
  route_table_id = "${aws_route_table.temasys_private_rt.id}"
  subnet_id      = "${aws_subnet.temasys_pri_1.id}"
}

resource "aws_route_table_association" "temasys_private_b" {
  route_table_id = "${aws_route_table.temasys_private_rt.id}"
  subnet_id      = "${aws_subnet.temasys_pri_2.id}"
}

resource "aws_db_subnet_group" "temasys_rds_subnet_group" {
  subnet_ids = ["${aws_subnet.temasys_rds_1.id}",
    "${aws_subnet.temasys_rds_2.id}",
    "${aws_subnet.temasys_rds_3.id}",
  ]
}

resource "aws_db_instance" "temasys_mysql" {
  allocated_storage      = 10
  engine                 = "mysql"
  engine_version         = "5.6.27"
  instance_class         = "${var.db_class}"
  name                   = "${var.db_username}"
  password               = "${var.db_password}"
  db_subnet_group_name   = "${aws_db_subnet_group.temasys_rds_subnet_group.name}"
  vpc_security_group_ids = ["${aws_security_group.temasys_rds_sg.id}"]
  skip_final_snapshot    = "True"
}

resource "aws_instance" "temasys_public_ec2" {
  ami                    = "${var.ec2_ami}"
  instance_type          = "${var.ec2_type}"
  key_name               = "${aws_key_pair.keys.key_name}"
  vpc_security_group_ids = ["${aws_security_group.temasys_ec2_sg.id}"]
  subnet_id              = "${aws_subnet.temasys_pub_1.id}"

  provisionar "chef" {
    attributes_json = <<-EOF
      {
        "key": "value",
        "app": {
          "cluster1": {
            "nodes": [
              "webserver1",
              "webserver2"
            ]
          }
        }
      }
    EOF
  }
}
