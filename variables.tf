variable "aws_region" {}
variable "aws_profile" {}
data "aws_availability_zones" "available" {}
variable "vpc_cidr" {}
variable "cidrs" {
  type = map
}
variable "db_instance_class" {}
variable "dbname" {}
variable "dbuser" {}
variable "dbpassword" {}
variable "key_name" {}
variable "public_key_path" {}
variable "domain_name_1" {}
variable "domain_name_2" {}
variable "interview_instance_type" {}
variable "interview_ami" {}
variable "alb_healthy_threshold" {}
variable "alb_unhealthy_threshold" {}
variable "alb_timeout" {}
variable "alb_interval" {}
variable "alb_listener_port" {}
variable "alb_listener_protocol" {}
variable "environemnt" {}