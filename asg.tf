resource "aws_autoscaling_group" "argo_tunnel_autoscaling_group" {
  name                      = "${local.prefix}-asg"
  max_size                  = 1
  min_size                  = 1
  desired_capacity          = 1
  health_check_grace_period = 300
  health_check_type         = "EC2"
  force_delete              = true
  vpc_zone_identifier       = var.private_subnet_ids

  launch_template {
    id      = aws_launch_template.default.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = local.prefix
    propagate_at_launch = true
  }
}

resource "aws_launch_template" "default" {
  name = "${local.prefix}-lt"

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size = 8
      volume_type = "gp2"
      encrypted   = true
    }
  }

  image_id = data.aws_ami.amazon-linux-2.id

  instance_type = var.instance_type

  key_name = local.prefix

  iam_instance_profile {
    name = aws_iam_instance_profile.profile.name
  }

  monitoring {
    enabled = true
  }

  vpc_security_group_ids = [
    aws_security_group.default.id,
  ]

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = local.prefix
    }
  }

  user_data = base64encode(templatefile("${path.module}/user_data.sh", {
    cert_pem_secret_id  = aws_secretsmanager_secret.secret.id
    my_service_url      = var.my_service_url,
    my_service_domain   = var.my_service_domain,
    my_service_hostname = var.my_service_hostname,
  }))
}
