data "aws_ebs_volume" "buildsvr_ebs" {
  most_recent = true

  filter {
    name   = "volume-type"
    values = ["gp2"]
  }

  filter {
    name   = "tag:owner"
    values = ["build"]
  }
}

resource "aws_volume_attachment" "buildsvr_ebs_att" {
  device_name = "/dev/xvdb"
  volume_id   = data.aws_ebs_volume.buildsvr_ebs.id
  instance_id = aws_instance.buildsvr.id
}