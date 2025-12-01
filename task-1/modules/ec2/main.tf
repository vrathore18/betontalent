locals {
  common_tags = merge(var.tags, {
    Module = "ec2"
  })
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "main" {
  ami                    = var.ami_id != "" ? var.ami_id : data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = var.security_group_ids
  key_name               = var.key_name

  root_block_device {
    volume_type           = var.root_volume_type
    volume_size           = var.root_volume_size
    encrypted             = var.encrypt_root_volume
    delete_on_termination = true
  }

  monitoring           = var.enable_detailed_monitoring
  user_data            = var.user_data
  iam_instance_profile = var.iam_instance_profile

  tags = merge(local.common_tags, {
    Name = "${var.environment}-${var.project_name}-ec2"
  })

  volume_tags = merge(local.common_tags, {
    Name = "${var.environment}-${var.project_name}-ec2-root"
  })

  lifecycle {
    ignore_changes = [ami]
  }
}

resource "aws_eip" "main" {
  count    = var.assign_elastic_ip ? 1 : 0
  instance = aws_instance.main.id
  vpc      = true

  tags = merge(local.common_tags, {
    Name = "${var.environment}-${var.project_name}-ec2-eip"
  })
}
