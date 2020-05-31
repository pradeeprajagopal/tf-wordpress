provider "aws" {
  region                  = var.region
  profile                 = var.profile

}

# Create a new static IP address for our instance
resource "aws_lightsail_static_ip" "staticip" {
  name = "${var.name}_ip"
}

# Attached a static IP address to the instance
# Reference : https://www.terraform.io/docs/providers/aws/r/lightsail_static_ip_attachment.html
resource "aws_lightsail_static_ip_attachment" "assignip" {
  static_ip_name = aws_lightsail_static_ip.staticip.id
  instance_name  = aws_lightsail_instance.wordpress.id
}

# Create a new Lightsail Key Pair
resource "aws_lightsail_key_pair" "my_new_key_pair" {
  name = "${var.name}_key_pair"
}
# Create a new Wordpress Lightsail Instance
# Reference : https://www.terraform.io/docs/providers/aws/r/lightsail_instance.html
resource "aws_lightsail_instance" "wordpress" {
  name              = "${var.name}_wordpress"
  availability_zone = "us-west-2b"
  blueprint_id      = "wordpress_4_9_8"
  bundle_id         = "nano_2_0"
  key_pair_name     = aws_lightsail_key_pair.my_new_key_pair.id
  tags = {
    Name = var.name
  }
}

output "instance_name" {
  value = aws_lightsail_instance.wordpress.id
}

output "keypair" {
  value = aws_lightsail_instance.wordpress.key_pair_name
}

output "staticip" {
  value = aws_lightsail_static_ip.staticip.id
}