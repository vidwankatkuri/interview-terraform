aws_profile = "sandbox"
aws_region  = "us-east-1"
vpc_cidr    = "10.0.0.0/16"
cidrs = {
  public_1a     = "10.0.1.0/24"
  public_1b     = "10.0.2.0/24"
  public_1c     = "10.0.3.0/24"
  private_1a    = "10.0.4.0/24"
  private_1b    = "10.0.5.0/24"
  private_1c    = "10.0.6.0/24"
  private_db_1a = "10.0.7.0/24"
  private_db_1b = "10.0.8.0/24"
}
db_instance_class       = "db.t2.micro"
dbname                  = "interview_db"
dbuser                  = "interview"
dbpassword              = "interview"
key_name                = "interview"
public_key_path         = "~/.ssh/interview.pub"
domain_name_1           = "interview-content-manager"
domain_name_2           = "interview-website"
interview_instance_type = "t2.micro"
interview_ami           = "ami-b73b63a0"
alb_healthy_threshold   = "2"
alb_unhealthy_threshold = "2"
alb_timeout             = "3"
alb_interval            = "30"
alb_listener_port       = "443"
alb_listener_protocol   = "https"
environemnt             = "dev"