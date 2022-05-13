module "aws_vpc_create" {
  source = "./modules/aws_vpc_module"
  vpc_cidr = var.vpc_cidr
  vpc_name = var.vpc_name
  private_subnet_cidrs = var.private_subnet_cidrs
  public_subnet_cidrs = var.public_subnet_cidrs
}

module "aws_elasticbeanstalk_create" {
  source = "./modules/aws_elastic_bean_stalk"
  vpc_id=module.aws_vpc_create.vpc_id
  public_subnet_ids=module.aws_vpc_create.public_subnet_ids
  private_subnet_ids=module.aws_vpc_create.private_subnet_ids
  
}
