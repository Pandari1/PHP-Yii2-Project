provider "aws" {
    region = "us-east-1"
}

//creating VPC
resource "aws_vpc" "main" {
    cidr_block = "10.11.0.0/16"
    enable_dns_support = true
    enable_dns_hostnames = true
    tags = {
        Name = "main-vpc"
    }
}

// creating internet gateway
resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.main.id
    tags = {
        Name = "main-igw"
    }
}

//creating public subnet in us east 1a

resource "aws_subnet" "public-subnet1" {
    vpc_id = aws_vpc.main.id
    cidr_block = "10.11.1.0/24"
    availability_zone = "us-east-1a"
    map_public_ip_on_launch = true
    tags = {
        Name = "Public Subnet 1a"
    }
}



# Security Group
resource "aws_security_group" "web_sg" {
  name        = "web-sg"
  description = "Allow HTTP and SSH"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "web-sg"
  }
}

# Public Route Table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public-rt"
  }
}

# Associate public subnets with route table
resource "aws_route_table_association" "subnet-assocation" {
  subnet_id      = aws_subnet.public-subnet1.id
  route_table_id = aws_route_table.public_rt.id
}


# EC2 in Public Subnet
resource "aws_instance" "yii2_app" {
  ami                    = var.ami
  instance_type          = "t2.medium"
  subnet_id              = aws_subnet.public-subnet1.id
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  key_name               = var.key_name # key_name = "your-keypair-name" # Uncomment and add if needed
  
  tags = {
    Name = "Yii2App"
  }
  provisioner "remote-exec" {
    inline = [
      "sudo apt update -y",
      "sudo apt install -y docker.io docker-compose nginx git",
      "sudo systemctl enable docker && sudo systemctl start docker",
      "docker swarm init || true"
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("C:/Users/Pandu/.ssh/my-terraform-key.pem")
      host        = self.public_ip
    }
  }
}