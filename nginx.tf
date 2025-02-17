resource "helm_release" "nginx_ingress" {
  name       = "nginx-ingress"
  namespace  = "nginx-ingress"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  version    = "4.10.1" # Check for the latest version

  create_namespace = true

  values = [
    <<-EOT
controller:
  replicaCount: 2
  service:
    annotations:
      service.beta.kubernetes.io/aws-load-balancer-type: "nlb"  # Use AWS Network Load Balancer
      service.beta.kubernetes.io/aws-load-balancer-scheme: "internet-facing"
    externalTrafficPolicy: Local
  resources:
    requests:
      cpu: 100m
      memory: 128Mi
    limits:
      cpu: 500m
      memory: 512Mi
  metrics:
    enabled: false
    serviceMonitor:
      enabled: true
EOT
  ]
  #  depends_on = [helm_release.aws_lb_controller]
}

# resource "helm_release" "aws_lb_controller" {
#   name       = "aws-load-balancer-controller"
#   repository = "https://aws.github.io/eks-charts"
#   chart      = "aws-load-balancer-controller"
#   namespace  = "kube-system"

#   values = [<<EOF
# region: us-east-1
# clusterName: ${module.eks.eks_name}
# vpcId: ${module.eks.vpc_id}
# serviceAccount:
#   create: true
#   name: aws-load-balancer-controller
#   annotations:
#     eks.amazonaws.com/role-arn: ${module.eks.alb_role_arn}

# EOF
#   ]
# }
