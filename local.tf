resource "null_resource" "this" {
  provisioner "local-exec" {
    command = "aws eks --region ap-northeast-2 update-kubeconfig --name GoormEKSCluster"
  }
  
  provisioner "local-exec" {
    command = "kubectl create namespace argocd"
  }
  
  provisioner "local-exec" {
    command = "kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml"
  }
    
  provisioner "local-exec" {
    command = "sudo curl -sSL -o /usr/local/bin/argocd https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64"
  }
    
  provisioner "local-exec" {
    command = "sudo chmod +x /usr/local/bin/argocd"
  }
    
  provisioner "local-exec" {
    command = "kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'"
  }
    
  provisioner "local-exec" {
    command = "kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml"
  }
  
  depends_on = [
    aws_eks_cluster.GoormEKSCluster,
    aws_eks_node_group.eks-nodes-t2
  ]
  
}
