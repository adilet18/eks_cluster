terraform {
  required_version = ">= 0.13"

  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.0.0"
    }

    kubernetes = {
      version = ">= 2.0.0"
      source  = "hashicorp/kubernetes"
    }

    kubectl = {
      source  = "alekc/kubectl"
      version = ">= 2.0.2"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}


provider "helm" {
  kubernetes {
    host                   = module.eks.eks_endpoint
    token                  = data.aws_eks_cluster_auth.auth.token
    cluster_ca_certificate = base64decode(module.eks.eks_certificate_authority)
    config_path            = "~/.kube/config"
  }
}

provider "kubernetes" {
  host                   = module.eks.eks_endpoint
  cluster_ca_certificate = base64decode(module.eks.eks_certificate_authority)
  config_path            = "~/.kube/config"
}


provider "kubectl" {
  load_config_file       = false
  host                   = module.eks.eks_endpoint
  cluster_ca_certificate = base64decode(module.eks.eks_certificate_authority)
  token                  = data.aws_eks_cluster_auth.auth.token
  config_path            = "~/.kube/config"
}

# data "aws_eks_cluster" "cluster_name" {
#   name       = module.eks.eks_name
#   depends_on = [module.eks]
# }
# data "aws_eks_cluster_auth" "cluster_auth" {
#   name       = "${module.eks.eks_name}_auth"
#   depends_on = [module.eks]
# }
