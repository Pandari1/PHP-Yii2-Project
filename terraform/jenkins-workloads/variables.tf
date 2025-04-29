
variable "aws_region" {
  type        = string
  default     = "us-east-1"
  description = "Deploying in us east"

}
variable "ami" {
  type    = string
  default = "ami-084568db4383264d4"

}
variable "key_name" {
  type    = string
  default = "my-terraform-key"

}