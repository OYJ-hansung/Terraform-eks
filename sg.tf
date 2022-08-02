# create security group
resource "aws_security_group" "GoormEKSClusterSG" {
  name        = "GoormEKSClusterSG"
  description = "Goorm Project EKS Cluster"
  vpc_id      = aws_vpc.GoormProject-VPC.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "GoormEKSClusterSG"
  }
}


# add ingress rule of security group
resource "aws_security_group_rule" "GoormEKSClusterSG-ingress-workstation-https" {
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.GoormEKSClusterSG.id
  to_port           = 443
  type              = "ingress"
}

