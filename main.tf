provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "project" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "project"
  }
}

resource "aws_subnet" "public1" {
  vpc_id     = aws_vpc.project.id
  cidr_block = "10.0.0.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "public1"
  }
}

resource "aws_subnet" "public2" {
  vpc_id     = aws_vpc.project.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1b"


  tags = {
    Name = "public2"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.project.id

  tags = {
    Name = "igw"
  }
}

resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.project.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }


  tags = {
    Name = "rt"
  }
}

resource "aws_route_table_association" "rta1" {
  subnet_id      = aws_subnet.public1.id
  route_table_id = aws_route_table.rt.id
}

resource "aws_route_table_association" "rta2" {
  subnet_id      = aws_subnet.public2.id
  route_table_id = aws_route_table.rt.id
}



resource "aws_security_group" "sg" {

  name        = "sg"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.project.id

  tags = {
    Name = "sg"
  }

  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
    egress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}

resource "aws_s3_bucket" "example" {
  bucket = "tcbucket-project-storage"

  tags = {
    Name        = "My bucket"
   
  }
}

resource "aws_instance" "server1" {
  instance_type = "t2.micro"
  ami = "ami-07d9b9ddc6cd8dd30"
  associate_public_ip_address = true
  user_data = base64encode(file("webserver2.sh"))
  vpc_security_group_ids = [aws_security_group.sg.id]
  subnet_id = aws_subnet.public1.id
}

resource "aws_instance" "server2" {
  instance_type = "t2.micro"
  ami = "ami-07d9b9ddc6cd8dd30"
  associate_public_ip_address = true
  user_data = base64encode(file("webserver1.sh"))
  vpc_security_group_ids = [aws_security_group.sg.id]
  subnet_id = aws_subnet.public2.id
}


resource "aws_lb" "alb" {
  name               = "alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.sg.id]
  subnets            = [aws_subnet.public1.id, aws_subnet.public2.id]

  enable_deletion_protection = true


  tags = {
    Environment = "production"
  }
}

resource "aws_lb_target_group" "test" {
  name     = "test"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.project.id
}

resource "aws_lb_target_group_attachment" "attach1" {
  target_group_arn = aws_lb_target_group.test.arn
  target_id        = aws_instance.server1.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "attach2" {
  target_group_arn = aws_lb_target_group.test.arn
  target_id        = aws_instance.server2.id
  port             = 80
}

resource "aws_lb_listener" "server" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"


  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.test.arn
  }
}


output "loadbalancerdns" {
  value = aws_lb.alb.dns_name
}


