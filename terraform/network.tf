resource "aws_vpc" "amma_pickles" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "${local.name_prefix}-vpc"
  }
}

resource "aws_subnet" "public" {
  for_each = local.public_subnets

  vpc_id                  = aws_vpc.amma_pickles.id
  cidr_block              = each.value.cidr
  availability_zone       = each.value.az
  map_public_ip_on_launch = false

  tags = {
    Name = each.value.name
  }
}

resource "aws_subnet" "private_app" {
  for_each = local.private_app_subnets

  vpc_id            = aws_vpc.amma_pickles.id
  cidr_block        = each.value.cidr
  availability_zone = each.value.az

  tags = {
    Name = each.value.name
  }
}

resource "aws_subnet" "private_db" {
  for_each = local.private_db_subnets

  vpc_id            = aws_vpc.amma_pickles.id
  cidr_block        = each.value.cidr
  availability_zone = each.value.az

  tags = {
    Name = each.value.name
  }
}

resource "aws_internet_gateway" "amma_pickles" {
  vpc_id = aws_vpc.amma_pickles.id

  tags = {
    Name = "${local.name_prefix}-igw"
  }
}

resource "aws_eip" "nat" {
  count  = var.nat_eip_count
  domain = "vpc"
}

data "aws_nat_gateway" "amma_pickles" {
  id = var.nat_gateway_id
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.amma_pickles.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.amma_pickles.id
  }

  tags = {
    Name = "${local.name_prefix}-public-rt"
  }
}

resource "aws_route_table" "private_app" {
  vpc_id = aws_vpc.amma_pickles.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = data.aws_nat_gateway.amma_pickles.id
  }

  tags = {
    Name = "${local.name_prefix}-private-rt"
  }
}

resource "aws_route_table" "private_db" {
  vpc_id = aws_vpc.amma_pickles.id

  tags = {
    Name = "${local.name_prefix}-db-rt"
  }
}

resource "aws_route_table_association" "public" {
  for_each = local.public_subnets

  subnet_id      = aws_subnet.public[each.key].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private_app" {
  for_each = local.private_app_subnets

  subnet_id      = aws_subnet.private_app[each.key].id
  route_table_id = aws_route_table.private_app.id
}

resource "aws_route_table_association" "private_db" {
  for_each = local.private_db_subnets

  subnet_id      = aws_subnet.private_db[each.key].id
  route_table_id = aws_route_table.private_db.id
}
