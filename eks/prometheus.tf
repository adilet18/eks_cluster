

data "aws_eks_node_group" "eks-node-group" {
  cluster_name    = aws_eks_cluster.cluster.name
  for_each        = aws_eks_node_group.workers
  node_group_name = each.value.node_group_name
}


resource "time_sleep" "wait_for_kubernetes" {

  depends_on = [aws_eks_cluster.cluster]

  create_duration = "20s"
}

resource "kubernetes_namespace" "kube-namespace" {
  depends_on = [data.aws_eks_node_group.eks-node-group, time_sleep.wait_for_kubernetes]
  metadata {

    name = "prometheus"
  }
}

resource "helm_release" "prometheus" {
  depends_on       = [kubernetes_namespace.kube-namespace, time_sleep.wait_for_kubernetes]
  name             = "prometheus"
  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "kube-prometheus-stack"
  namespace        = kubernetes_namespace.kube-namespace.id
  create_namespace = true
  version          = "45.7.1"
  values = [
    file("~/terraform-modules/eks/values.yaml")
  ]
  timeout = 2000


  set {
    name  = "podSecurityPolicy.enabled"
    value = true
  }

  set {
    name  = "server.persistentVolume.enabled"
    value = false
  }

  set {
    name = "server\\.resources"
    value = yamlencode({
      limits = {
        cpu    = "200m"
        memory = "50Mi"
      }
      requests = {
        cpu    = "100m"
        memory = "30Mi"
      }
    })
  }
}


resource "aws_security_group_rule" "allow_prometheus" {
  type              = "ingress"
  from_port         = 9090
  to_port           = 9090
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.worker_group_mgmt.id
}

resource "aws_security_group_rule" "allow_grafana" {
  type              = "ingress"
  from_port         = 3000
  to_port           = 3000
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.worker_group_mgmt.id
}

