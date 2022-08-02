# Create Node Group
resource "aws_eks_node_group" "eks-nodes-t2" {
  cluster_name    = aws_eks_cluster.GoormEKSCluster.name
  node_group_name = "eks-nodes-t2"
  subnet_ids      = [aws_subnet.GoormProject-Public1.id]
  node_role_arn   = aws_iam_role.Goorm-eks-nodes-role.arn
  instance_types  = ["t2.large"]
  disk_size = 20

  labels = {
    "role" = "eks-t2-medium"
  }

  scaling_config {
    desired_size = 2
    min_size     = 2
    max_size     = 4
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks-node-EKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.eks-node-EKS_CNI_Policy,
    aws_iam_role_policy_attachment.eks-node-EC2ContainerRegistryReadOnly,
  ]

  tags = {
    "Name" = "${aws_eks_cluster.GoormEKSCluster.name}-eks-t2-medium-Node"
  }
}
