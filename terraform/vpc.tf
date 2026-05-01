module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.0.0"

  name = "eks-3tier-vpc"
  cidr = "10.0.0.0/16"

  # We need at least 2 Availability Zones for EKS
  azs             = ["eu-central-1a", "eu-central-1b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"] # For DB and App
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"] # For Load Balancer

  enable_nat_gateway = true # Allows private apps to talk to the internet
  single_nat_gateway = true # Saves money (only creates one instead of two)

  public_subnet_tags = {
    "kubernetes.io/role/elb" = "1" # Required for Load Balancers
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = "1"
  }
}