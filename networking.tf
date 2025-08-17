resource "aws_vpc" "merapar" {
  cidr_block = var.vpc_cidr

  tags = {
    Project = "Merapar"
  }
}

resource "aws_subnet" "merapar_pubic" {
  vpc_id     = aws_vpc.merapar.id
  cidr_block = var.subnet_public_cidr

  tags = {
    Project = "Merapar"
  }
}

resource "aws_subnet" "merapar_private" {
  vpc_id     = aws_vpc.merapar.id
  cidr_block = var.subnet_private_cidr

  tags = {
    Project = "Merapar"
  }
}