#Task: Leverage spot instances in an auto-scaling group for cost optimization.

resource "aws_launch_template" "spot_template" {
  name_prefix   = "spot-template"
  instance_type = "t2.micro"

  instance_market_options {
    market_type = "spot"
  }
}

resource "aws_autoscaling_group" "spot_asg" {
  desired_capacity     = 2
  max_size             = 5
  min_size             = 1
  launch_template {
    id      = aws_launch_template.spot_template.id
    version = "$Latest"
  }
  vpc_zone_identifier = ["subnet-12345678", "subnet-87654321"]
}
