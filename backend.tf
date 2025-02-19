provider "aws" {
  region = "us-east-1"
}


provider "helm" {
  kubernetes {
    host                   = module.eks.eks_endpoint
    token                  = data.aws_eks_cluster_auth.auth.token
    cluster_ca_certificate = base64decode(module.eks.eks_certificate_authority)
  }
}




terraform {
  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "~> 1.14.0" # Use latest stable version
    }
  }
}
