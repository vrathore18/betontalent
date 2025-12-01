data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}

resource "aws_instance" "main" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [var.security_group_id]
  iam_instance_profile   = var.instance_profile_name
  key_name               = var.key_name != "" ? var.key_name : null
  monitoring             = var.enable_detailed_monitoring

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
    instance_metadata_tags      = "enabled"
  }

  root_block_device {
    volume_type           = "gp3"
    volume_size           = var.root_volume_size
    encrypted             = true
    kms_key_id            = var.ebs_kms_key_arn
    delete_on_termination = true

    tags = {
      Name = "${var.project_name}-root-volume"
    }
  }

  user_data = base64encode(<<-EOF
    #!/bin/bash
    dnf update -y
    dnf install -y amazon-ssm-agent
    systemctl enable amazon-ssm-agent
    systemctl start amazon-ssm-agent
    dnf install -y amazon-cloudwatch-agent
    sed -i 's/PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config
    dnf install -y dnf-automatic
    sed -i 's/apply_updates = no/apply_updates = yes/' /etc/dnf/automatic.conf
    systemctl enable dnf-automatic.timer
    systemctl start dnf-automatic.timer
    chmod 600 /etc/ssh/sshd_config
    systemctl restart sshd
  EOF
  )

  tags = {
    Name    = "${var.project_name}-ec2-instance"
    Project = var.project_name
  }

  lifecycle {
    ignore_changes = [ami]
  }
}

resource "aws_ebs_volume" "data" {
  count             = var.create_data_volume ? 1 : 0
  availability_zone = var.availability_zone
  size              = var.data_volume_size
  type              = "gp3"
  encrypted         = true
  kms_key_id        = var.ebs_kms_key_arn

  tags = {
    Name = "${var.project_name}-data-volume"
  }
}

resource "aws_volume_attachment" "data" {
  count       = var.create_data_volume ? 1 : 0
  device_name = "/dev/sdf"
  volume_id   = aws_ebs_volume.data[0].id
  instance_id = aws_instance.main.id
}

resource "aws_cloudwatch_log_group" "ec2" {
  name              = "/aws/ec2/${var.project_name}"
  retention_in_days = 30
  kms_key_id        = var.kms_key_arn

  tags = {
    Name = "${var.project_name}-ec2-logs"
  }
}
