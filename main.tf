provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}

#------VPC------
resource "aws_vpc" "interview_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "interview_vpc"
    environment = "var.environment"
  }
}

#--------Internet Gateway--------
resource "aws_internet_gateway" "interview_internet_gateway" {
  vpc_id = aws_vpc.interview_vpc.id

  tags = {
    Name = "interview_igw"
    environment = "var.environment"

  }
}

#------Route Tables-----------
resource "aws_route_table" "interview_public_rt" {
  vpc_id = aws_vpc.interview_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.interview_internet_gateway.id
  }
  tags = {
    Name = "interview_public_rt"
    environment = "var.environment"

  }
}

resource "aws_default_route_table" "interview_private_rt" {
  default_route_table_id = aws_vpc.interview_vpc.default_route_table_id

  tags = {
    Name = "interview_private_rt"
    environment = "var.environment"

  }
}


#-------Subnets-------

resource "aws_subnet" "interview_public_subnet_1a" {
  vpc_id                  = aws_vpc.interview_vpc.id
  cidr_block              = var.cidrs["public_1a"]
  map_public_ip_on_launch = true
  availability_zone       = "${data.aws_availability_zones.available.names[0]}"

  tags = {
    Name = "interview_public_1a"
    environment = "var.environment"

  }
}

resource "aws_subnet" "interview_public_subnet_1b" {
  vpc_id                  = aws_vpc.interview_vpc.id
  cidr_block              = var.cidrs["public_1a"]
  map_public_ip_on_launch = true
  availability_zone       = "${data.aws_availability_zones.available.names[1]}"

  tags = {
    Name = "interview_public_1b"
    environment = "var.environment"
  }
}

resource "aws_subnet" "interview_public_subnet_1c" {
  vpc_id                  = aws_vpc.interview_vpc.id
  cidr_block              = var.cidrs["public_1a"]
  map_public_ip_on_launch = true
  availability_zone       = "${data.aws_availability_zones.available.names[2]}"

  tags = {
    Name = "interview_public_1c"
    environment = "var.environment"
  }
}

resource "aws_subnet" "interview_private_subnet_1a" {
  vpc_id                  = aws_vpc.interview_vpc.id
  cidr_block              = var.cidrs["private_1a"]
  map_public_ip_on_launch = true
  availability_zone       = "${data.aws_availability_zones.available.names[0]}"

  tags = {
    Name = "interview_private_1a"
    environment = "var.environment"
  }
}

resource "aws_subnet" "interview_private_subnet_1b" {
  vpc_id                  = aws_vpc.interview_vpc.id
  cidr_block              = var.cidrs["private_1b"]
  map_public_ip_on_launch = true
  availability_zone       = "${data.aws_availability_zones.available.names[1]}"

  tags = {
    Name = "interview_private_1b"
    environment = "var.environment"
  }
}

resource "aws_subnet" "interview_private_subnet_1c" {
  vpc_id                  = aws_vpc.interview_vpc.id
  cidr_block              = var.cidrs["private_1c"]
  map_public_ip_on_launch = true
  availability_zone       = "${data.aws_availability_zones.available.names[2]}"

  tags = {
    Name = "interview_private_1c"
    environment = "var.environment"
  }
}

resource "aws_subnet" "interview_private_db_subnet_1a" {
  vpc_id                  = aws_vpc.interview_vpc.id
  cidr_block              = var.cidrs["private_db_1a"]
  map_public_ip_on_launch = true
  availability_zone       = "${data.aws_availability_zones.available.names[0]}"

  tags = {
    Name = "interview_private_db_1a"
    environment = "var.environment"
  }
}

resource "aws_subnet" "interview_private_db_subnet_1b" {
  vpc_id                  = aws_vpc.interview_vpc.id
  cidr_block              = var.cidrs["private_db_1b"]
  map_public_ip_on_launch = true
  availability_zone       = "${data.aws_availability_zones.available.names[1]}"

  tags = {
    Name = "interview_private_db_1b"
    environment = "var.environment"
  }
}

#-------RDS Subnet Groups----------------

resource "aws_db_subnet_group" "interview_rds_subnetgroup" {
  name = "interview_rds_subnetgroup"

  subnet_ids = ["aws_subnet.interview_private_db_subnet_1a.id",
    "aws_subnet.interview_private_db_subnet_1b.id}"
  ]

  tags = {
    Name = "interview_rds_subnet_group"
    environment = "var.environment"
  }
}

#-----Subnet Associations-------------------

resource "aws_route_table_association" "interview_public_1a_association" {
  subnet_id      = aws_subnet.interview_public_subnet_1a.id
  route_table_id = aws_route_table.interview_public_rt.id
}

resource "aws_route_table_association" "interview_public_1b_association" {
  subnet_id      = aws_subnet.interview_public_subnet_1b.id
  route_table_id = aws_route_table.interview_public_rt.id
}

resource "aws_route_table_association" "interview_public_1c_association" {
  subnet_id      = aws_subnet.interview_public_subnet_1c.id
  route_table_id = aws_route_table.interview_public_rt.id
}

resource "aws_route_table_association" "interview_private_1a_association" {
  subnet_id      = aws_subnet.interview_private_subnet_1a.id
  route_table_id = aws_default_route_table.interview_private_rt.id
}

resource "aws_route_table_association" "interview_private_1b_association" {
  subnet_id      = aws_subnet.interview_private_subnet_1b.id
  route_table_id = aws_default_route_table.interview_private_rt.id
}

resource "aws_route_table_association" "interview_private_1c_association" {
  subnet_id      = aws_subnet.interview_private_subnet_1c.id
  route_table_id = aws_default_route_table.interview_private_rt.id
}

resource "aws_route_table_association" "interview_private_db_1a_association" {
  subnet_id      = aws_subnet.interview_private_db_subnet_1a.id
  route_table_id = aws_default_route_table.interview_private_rt.id
}

resource "aws_route_table_association" "interview_private_db_1b_association" {
  subnet_id      = aws_subnet.interview_private_db_subnet_1b.id
  route_table_id = aws_default_route_table.interview_private_rt.id
}

#--------Public Security group---------------

resource "aws_security_group" "interview_public_sg" {
  name        = "interview_public_sg"
  description = "Used for load balancer access"
  vpc_id      = aws_vpc.interview_vpc.id

  #HTTP 

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  #Outbound internet access

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#----------Private Security Group-----------------

resource "aws_security_group" "interview_private_sg" {
  name        = "interview_private_sg"
  description = "Used for private instances"
  vpc_id      = aws_vpc.interview_vpc.id

  # Access from other security groups

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["${var.vpc_cidr}"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

#-------RDS Security Group-------------
resource "aws_security_group" "interview_rds_sg" {
  name        = "interview_rds_sg"
  description = "Used for DB instances"
  vpc_id      = aws_vpc.interview_vpc.id

  # SQL access from public/private security group

  ingress {
    from_port = 1433
    to_port   = 1433
    protocol  = "tcp"

    security_groups = [aws_security_group.interview_public_sg.id,
      aws_security_group.interview_private_sg.id
    ]
  }
}

#------Elasticache Security Group-----------


resource "aws_security_group" "interview_elasticache_sg" {
  name        = "interview_elasticache_sg"
  description = "Used for elasticache instance"
  vpc_id      = aws_vpc.interview_vpc.id

  # Access from other security groups

  ingress {
    from_port   = 6739
    to_port     = 6739
    protocol    = "-1"
    cidr_blocks = ["${var.vpc_cidr}"]
  }
  egress {
    from_port   = 6739
    to_port     = 6739
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}
#-----------RDS Instance-------------------
resource "aws_db_instance" "interview_db" {
  allocated_storage      = 10
  engine                 = "sql"
  engine_version         = "latest"
  instance_class         = var.db_instance_class
  name                   = var.dbname
  username               = var.dbuser
  password               = var.dbpassword
  db_subnet_group_name   = aws_db_subnet_group.interview_rds_subnetgroup.name
  vpc_security_group_ids = ["${aws_security_group.interview_rds_sg.id}"]
  skip_final_snapshot    = true
}


#------------EC2------------------

resource "aws_instance" "interview_private_1a_1" {
  instance_type = var.interview_instance_type
  ami           = var.interview_ami

  tags = {
    Name = "interview_ec2_instance_private_1a_1"
    environment = "var.environment"
  }

  vpc_security_group_ids = ["${aws_security_group.interview_private_sg.id}"]
  subnet_id              = aws_subnet.interview_private_subnet_1a.id
}

resource "aws_instance" "interview_private_1a_2" {
  instance_type = var.interview_instance_type
  ami           = var.interview_ami

  tags = {
    Name = "interview_ec2_instance_private_1a_2"
    environment = "var.environment"
  }

  vpc_security_group_ids = ["${aws_security_group.interview_private_sg.id}"]
  subnet_id              = aws_subnet.interview_private_subnet_1a.id
}

resource "aws_instance" "interview_private_1a_3" {
  instance_type = var.interview_instance_type
  ami           = var.interview_ami

  tags = {
    Name = "interview_ec2_instance_private_1a_3"
    environment = "var.environment"
  }

  vpc_security_group_ids = ["${aws_security_group.interview_private_sg.id}"]
  subnet_id              = aws_subnet.interview_private_subnet_1a.id
}

resource "aws_instance" "interview_private_1b_1" {
  instance_type = var.interview_instance_type
  ami           = var.interview_ami

  tags = {
    Name = "interview_ec2_instance_private_1b_1"
    environment = "var.environment"
  }

  vpc_security_group_ids = ["${aws_security_group.interview_private_sg.id}"]
  subnet_id              = aws_subnet.interview_private_subnet_1b.id
}

resource "aws_instance" "interview_private_1b_2" {
  instance_type = var.interview_instance_type
  ami           = var.interview_ami

  tags = {
    Name = "interview_ec2_instance_private_1b_2"
    environment = "var.environment"
  }

  vpc_security_group_ids = ["${aws_security_group.interview_private_sg.id}"]
  subnet_id              = aws_subnet.interview_private_subnet_1b.id
}

resource "aws_instance" "interview_private_1c_1" {
  instance_type = var.interview_instance_type
  ami           = var.interview_ami

  tags = {
    Name = "interview_ec2_instance_private_1c_1"
    environment = "var.environment"
  }

  vpc_security_group_ids = ["${aws_security_group.interview_private_sg.id}"]
  subnet_id              = aws_subnet.interview_private_subnet_1c.id
}

#------------Load Balancer----------------

resource "aws_alb" "interview_alb_1" {
  name = "${var.domain_name_1}-alb"

  subnets = ["${aws_subnet.interview_public_subnet_1a.id}",
    "${aws_subnet.interview_public_subnet_1b.id}",
    "${aws_subnet.interview_public_subnet_1c.id}",
  ]

  security_groups = ["${aws_security_group.interview_public_sg.id}"]

  tags = {
    Name = "interview_${var.domain_name_1}-alb"
    environment = "var.environment"
  }
}

resource "aws_alb_target_group" "interview_alb_1_tg" {
    name = "${var.domain_name_1}-alb-tg"
    port = var.alb_listener_port 
    protocol = var.alb_listener_protocol

    tags = {
    Name = "interview_${var.domain_name_1}-alb-tg"
    environment = "var.environment"
  }
}
resource "aws_alb_listener" "interview_alb_listener_1" {  
  load_balancer_arn = aws_alb.interview_alb_1.arn  
  port              = var.alb_listener_port 
  protocol          = var.alb_listener_protocol
  
  default_action {    
    target_group_arn = aws_alb_target_group.interview_alb_1_tg.arn
    type             = "forward"  
  }
}

resource "aws_lb_target_group_attachment" "interview_alb_1_attachment" {
  target_group_arn = aws_alb_target_group.interview_alb_1_tg.arn
  target_id        = aws_instance.interview_private_1a_1.id
  port             = var.alb_listener_port
}

resource "aws_alb" "interview_alb_2" {
  name = "${var.domain_name_2}-alb"

  subnets = ["${aws_subnet.interview_public_subnet_1a.id}",
    "${aws_subnet.interview_public_subnet_1b.id}",
    "${aws_subnet.interview_public_subnet_1c.id}",
  ]

  security_groups = ["${aws_security_group.interview_public_sg.id}"]

  tags = {
    Name = "interview_${var.domain_name_2}-alb"
    environment = "var.environment"
  }
}

resource "aws_alb_target_group" "interview_alb_2_tg" {
    name = "${var.domain_name_1}-alb-tg"
    port = var.alb_listener_port  
    protocol = var.alb_listener_protocol

    tags = {
    Name = "interview_${var.domain_name_1}-alb-tg"
    environment = "var.environment"
  }
}
resource "aws_alb_listener" "interview_alb_listener_2" {  
  load_balancer_arn = aws_alb.interview_alb_2.arn  
  port              = var.alb_listener_port
  protocol          = var.alb_listener_protocol
  
  default_action {    
    target_group_arn = aws_alb_target_group.interview_alb_2_tg.arn
    type             = "forward"  
  }
}

resource "aws_lb_target_group_attachment" "interview_alb_2_attachment_1a" {
  target_group_arn = aws_alb_target_group.interview_alb_2_tg.arn
  target_id        = aws_instance.interview_private_1a_2.id
  port             = var.alb_listener_port
}

resource "aws_lb_target_group_attachment" "interview_alb_2_attachment_2b" {
  target_group_arn = aws_alb_target_group.interview_alb_2_tg.arn
  target_id        = aws_instance.interview_private_1b_1.id
  port             = var.alb_listener_port
}

resource "aws_alb" "interview_alb_private_1" {
  name = "private-1-alb"

  subnets = ["${aws_subnet.interview_private_subnet_1b.id}"]
  security_groups = ["${aws_security_group.interview_public_sg.id}"]

  tags = {
    Name = "private-1-alb"
    environment = "var.environment"
  }
}

resource "aws_alb_target_group" "interview_alb_private_1_tg" {
    name = "private-alb-tg"
    port = var.alb_listener_port
    protocol = var.alb_listener_protocol

    tags = {
    Name = "interview-private-alb-tg"
    environment = "var.environment"
  }
}
resource "aws_alb_listener" "interview_alb_private_listener_1" {  
  load_balancer_arn = aws_alb.interview_alb_private_1.arn  
  port              = var.alb_listener_port 
  protocol          = var.alb_listener_protocol
  
  default_action {    
    target_group_arn = aws_alb_target_group.interview_alb_2_tg.arn
    type             = "forward"  
  }
}

resource "aws_lb_target_group_attachment" "interview_alb_private_attachment_1" {
  target_group_arn = aws_alb_target_group.interview_alb_private_1_tg.arn
  target_id        = aws_instance.interview_private_1c_1.id
  port             = var.alb_listener_port
}

#-------Elasticache Redis Instance--------------

resource "aws_elasticache_cluster" "interview_redis" {
  cluster_id           = "interview-redis"
  engine               = "redis"
  node_type            = "cache.m4.large"
  num_cache_nodes      = 1
  parameter_group_name = "default.redis3.2"
  engine_version       = "3.2.10"
  port                 = 6379
}

resource "aws_elasticache_parameter_group" "interview_redis" {
  name   = "cache-params"
  family = "redis2.8"

  parameter {
    name  = "activerehashing"
    value = "yes"
  }

  parameter {
    name  = "min-slaves-to-write"
    value = "2"
  }
}

resource "aws_elasticache_replication_group" "interview_redis" {
  automatic_failover_enabled    = true
  availability_zones             = ["${data.aws_availability_zones.available.names[1]}", "${data.aws_availability_zones.available.names[2]}"]
  replication_group_id          = "interview-rep-group"
  replication_group_description = "interview replication group"
  node_type                     = "cache.m4.large"
  number_cache_clusters         = 2
  parameter_group_name          = "default.redis3.2"
  port                          = 6379
}

  




