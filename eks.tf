# create cluster
resource "aws_eks_cluster" "GoormEKSCluster" {
  name = "GoormEKSCluster"
  role_arn = aws_iam_role.GoormEKSRole.arn
  version  = "1.22"

  # enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]

  vpc_config {
    security_group_ids      = [aws_security_group.GoormEKSClusterSG.id]
    subnet_ids              = [aws_subnet.GoormProject-Public1.id, aws_subnet.GoormProject-Pravate1.id]
    endpoint_private_access = true
    endpoint_public_access  = true
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks-cluster-EKSClusterPolicy,
    aws_iam_role_policy_attachment.eks-cluster-EKSVPCResourceController,
  ]
}
