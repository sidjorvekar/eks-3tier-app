module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = "eks-3tier-cluster"
  cluster_version = "1.34"

  # Networking
  vpc_id                         = module.vpc.vpc_id
  subnet_ids                     = module.vpc.private_subnets
  cluster_endpoint_public_access = true

  # Give the person who creates the cluster admin permissions automatically
  enable_cluster_creator_admin_permissions = true

  eks_managed_node_groups = {
    # This is your worker group
    app_nodes = {
      min_size     = 1
      max_size     = 3
      desired_size = 2

      instance_types = ["t3.micro"] # t3.medium has enough RAM for 3-tier apps
      capacity_type  = "ON_DEMAND"        # Use SPOT to save up to 70-90% on costs!
    }

    # 1. Enable the API to manage access
    authentication_mode = "API_AND_CONFIG_MAP"

    # Grant your specific IAM User/Role access to the UI
    access_entries = {
      console_user = {
        kubernetes_groups = []
        principal_arn     = "arn:aws:iam::652468253519:user/terraform-admin" # Replace with your IAM ARN
        type              = "STANDARD"

        policy_associations = {
          view_access = {
            policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
            access_scope = {
              type = "cluster"
            }
          }
        }
      }
    }
  }

  tags = {
    Environment = "dev"
    Project     = "eks-3tier"
  }
}