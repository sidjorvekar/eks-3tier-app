module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = "eks-3tier-cluster"
  cluster_version = "1.29"

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

      instance_types = ["t3.medium"] # t3.medium has enough RAM for 3-tier apps
      capacity_type  = "SPOT"        # Use SPOT to save up to 70-90% on costs!
    }
  }

  tags = {
    Environment = "dev"
    Project     = "eks-3tier"
  }
}