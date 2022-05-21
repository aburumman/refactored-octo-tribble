// For IMT Development Environment


module "vpc" {
  source = "../vpc"
}

module "ec2_iam" {
  source = "../ec2_iam"
}



data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "bastion" {
  ami           = data.aws_ami.ubuntu.id
  //instance_type = var.instance_type
  instance_type = var.bastion_instance_type
  private_ip    = var.bastion_private_ip
  // Use a pre-exist subnet id or a new one
  subnet_id                   = module.vpc.fourth_subnet
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.this.id]
  key_name = var.instance_key
}

resource "aws_eip" "bastion" {
  vpc                       = true
  instance                  = aws_instance.bastion.id
  associate_with_private_ip = var.bastion_private_ip
  depends_on                = [module.vpc.internet_gateway]
}

resource "aws_instance" "this" {
  // Main instance with 500GB
  ami           = data.aws_ami.ubuntu.id
  //instance_type = var.instance-1
  instance_type = "t2.micro"
  //iam_instance_profile = aws_iam_instance_profile.ec2_profile
  iam_instance_profile = module.ec2_iam.main_ec2_role

  // Use a pre-exist subnet id or a new one
  private_ip                  = var.main_instance_ip
  subnet_id                   = module.vpc.this_subnet
  associate_public_ip_address = false
  vpc_security_group_ids      = [aws_security_group.this.id]
  key_name = var.instance_key

  lifecycle {
    ignore_changes = [ami]
  }

  /** To make spot instance Uncomment this block
 create_spot_instance = true
  spot_price           = "0.60"
  spot_type            = "persistent"
**/


  /**
  vpc_security_group_ids = [
    aws_security_group.this.id
  ]
  **/


  root_block_device {
    //delete_on_termination = false
    delete_on_termination = true
    //iops = 150
    volume_size = var.volume_size
    volume_type = "gp2"
  }





  depends_on = [aws_security_group.this, module.vpc.this_subnet]
  tags = {
    env         = var.env_tag
    managed_by  = "terraform-${terraform.workspace}"
    application = var.application

  }
}

//Uncomment Below to enable cloudwatch for this instance

/**
resource "aws_cloudwatch_metric_alarm" "ec2_cpu" {
     alarm_name               = "cpu-utilization"
     comparison_operator       = "GreaterThanOrEqualToThreshold"
     evaluation_periods       = "2"
     metric_name               = "CPUUtilization"
     namespace                 = "AWS/EC2"
     period                   = "120" #seconds
     statistic                 = "Average"
     threshold                 = "80"
   alarm_description         = "This metric monitors ec2 cpu utilization"
     insufficient_data_actions = []

dimensions = {

       InstanceId = aws_instance.this.id

     }

}

**/




/*** To create and Attach EBS
resource "aws_volume_attachment" "this" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.this.id
  instance_id = aws_instance.this.id
}

resource "aws_ebs_volume" "this" {
    availability_zone = us-east-1a
    size              = 1

  tags = {
    env         = var.env_tag
    managed_by = "terraform-${terraform.workspace}"
    application = var.application

  }
}
**/

resource "aws_security_group" "this" {
  name        = var.main_security_group
  description = "Defaut SG for VPC"
  vpc_id      = module.vpc.vpc_id
  #vpc_id      = aws_vpc.this.id
  #depends_on  = [aws_instance.this.id]
  // To Allow SSH Transport
  ingress {
    from_port   = "22"
    protocol    = "tcp"
    to_port     = "22"
    cidr_blocks = ["0.0.0.0/0"]
  }

  // To Allow Port 80 Transport
  /**
  ingress {
    from_port   = 80
    protocol    = "tcp"
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }
  **/

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    env         = var.env_tag
    managed_by  = "terraform-${terraform.workspace}"
    application = var.application

  }
}







