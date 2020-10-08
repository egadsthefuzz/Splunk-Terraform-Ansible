resource aws_internet_gateway "splunk_gw" {
  vpc_id = aws_vpc.splunk_vpc.id
  tags = {
    Name = "splunk-cluster-env"
  }
}

# Define the virtual private cloud
resource aws_vpc "splunk_vpc" {
  cidr_block                = var.cidr_block
  enable_dns_hostnames      = true
  enable_dns_support        = true
  tags = {
    Name = "splunk-cluster-env"
  }
}

resource aws_subnet "splunk_subnet_1" {
  vpc_id            = aws_vpc.splunk_vpc.id
  cidr_block        = var.subnet_1
  availability_zone = var.availability_zone_0
  map_public_ip_on_launch = true
  depends_on = [aws_internet_gateway.splunk_gw]
  tags = {
    Name = "splunk-cluster-env"
  }
}

resource aws_subnet "splunk_subnet_2" {
  vpc_id            = aws_vpc.splunk_vpc.id
  cidr_block        = var.subnet_2
  availability_zone = var.availability_zone_1
  map_public_ip_on_launch = true
  depends_on = [aws_internet_gateway.splunk_gw]
  tags = {
    Name = "splunk-cluster-env"
  }
}

resource aws_subnet "splunk_subnet_3" {
  vpc_id            = aws_vpc.splunk_vpc.id
  cidr_block        = var.subnet_3
  availability_zone = var.availability_zone_2
  map_public_ip_on_launch = true
  depends_on = [aws_internet_gateway.splunk_gw]
  tags = {
    Name = "splunk-cluster-env"
  }
}

resource aws_network_interface "master" {
  subnet_id   = aws_subnet.splunk_subnet_1.id
  private_ips = [var.master_private_ip]
  security_groups   = [aws_security_group.splunk_generic.id]
  tags = {
    Name = "splunk-cluster-env"
  }
}

resource aws_network_interface "master2" {
  subnet_id   = aws_subnet.splunk_subnet_2.id
  private_ips = [var.master2_private_ip]
  security_groups   = [aws_security_group.splunk_generic.id]
  tags = {
    Name = "splunk-cluster-env"
  }
}

resource aws_network_interface "master3" {
  subnet_id   = aws_subnet.splunk_subnet_3.id
  private_ips = [var.master3_private_ip]
  security_groups   = [aws_security_group.splunk_generic.id]
  tags = {
    Name = "splunk-cluster-env"
  }
}

resource aws_network_interface "indexer1" {
  subnet_id   = aws_subnet.splunk_subnet_1.id
  private_ips = [var.indexer1_private_ip]
  security_groups   = [aws_security_group.splunk_generic.id]
  tags = {
    Name = "splunk-cluster-env"
  }
}

resource aws_network_interface "indexer2" {
  subnet_id   = aws_subnet.splunk_subnet_2.id
  private_ips = [var.indexer2_private_ip]
  security_groups   = [aws_security_group.splunk_generic.id]
  tags = {
    Name = "splunk-cluster-env"
  }
}

resource aws_network_interface "indexer3" {
  subnet_id   = aws_subnet.splunk_subnet_3.id
  private_ips = [var.indexer3_private_ip]
  security_groups   = [aws_security_group.splunk_generic.id]
  tags = {
    Name = "splunk-cluster-env"
  }
}

resource aws_network_interface "search_head_deployer" {
  subnet_id   = aws_subnet.splunk_subnet_1.id
  private_ips = [var.search_head_deployer_private_ip]
  security_groups   = [aws_security_group.splunk_generic.id]
  tags = {
    Name = "splunk-cluster-env"
  }
}

resource aws_network_interface "search_head_1" {
  subnet_id   = aws_subnet.splunk_subnet_1.id
  private_ips = [var.search_head_1_private_ip]
  security_groups   = [aws_security_group.splunk_generic.id]
  tags = {
    Name = "splunk-cluster-env"
  }
}

resource aws_network_interface "search_head_2" {
  subnet_id   = aws_subnet.splunk_subnet_2.id
  private_ips = [var.search_head_2_private_ip]
  security_groups   = [aws_security_group.splunk_generic.id]
  tags = {
    Name = "splunk-cluster-env"
  }
}

resource aws_network_interface "search_head_3" {
  subnet_id   = aws_subnet.splunk_subnet_3.id
  private_ips = [var.search_head_3_private_ip]
  security_groups   = [aws_security_group.splunk_generic.id]
  tags = {
    Name = "splunk-cluster-env"
  }
}

resource "aws_eip" "master" {
  vpc = true
  instance                  = aws_instance.master.id
  associate_with_private_ip = var.master_private_ip
  depends_on                = [aws_internet_gateway.splunk_gw]
}

resource "aws_eip" "master2" {
  vpc = true
  instance                  = aws_instance.master2.id
  associate_with_private_ip = var.master2_private_ip
  depends_on                = [aws_internet_gateway.splunk_gw]
}

resource "aws_eip" "master3" {
  vpc = true
  instance                  = aws_instance.master3.id
  associate_with_private_ip = var.master3_private_ip
  depends_on                = [aws_internet_gateway.splunk_gw]
}

resource "aws_eip" "indexer1" {
  vpc = true
  instance                  = aws_instance.indexer1.id
  associate_with_private_ip = var.indexer1_private_ip
  depends_on                = [aws_internet_gateway.splunk_gw]
}

resource "aws_eip" "indexer2" {
  vpc = true
  instance                  = aws_instance.indexer2.id
  associate_with_private_ip = var.indexer2_private_ip
  depends_on                = [aws_internet_gateway.splunk_gw]
}

resource "aws_eip" "indexer3" {
  vpc = true
  instance                  = aws_instance.indexer3.id
  associate_with_private_ip = var.indexer3_private_ip
  depends_on                = [aws_internet_gateway.splunk_gw]
}

resource "aws_eip" "search_head_deployer" {
  vpc = true
  instance                  = aws_instance.search_head_deployer.id
  associate_with_private_ip = var.search_head_deployer_private_ip
  depends_on                = [aws_internet_gateway.splunk_gw]
}

resource "aws_eip" "search_head_1" {
  vpc = true
  instance                  = aws_instance.search_head_1.id
  associate_with_private_ip = var.search_head_1_private_ip
  depends_on                = [aws_internet_gateway.splunk_gw]
}

resource "aws_eip" "search_head_2" {
  vpc = true
  instance                  = aws_instance.search_head_2.id
  associate_with_private_ip = var.search_head_2_private_ip
  depends_on                = [aws_internet_gateway.splunk_gw]
}

resource "aws_eip" "search_head_3" {
  vpc = true
  instance                  = aws_instance.search_head_3.id
  associate_with_private_ip = var.search_head_3_private_ip
  depends_on                = [aws_internet_gateway.splunk_gw]
}

# Define a security group with ingress/egress rules
resource aws_security_group "splunk_generic" {
  name        = "Security Group"
  description = "Allows traffic on required ports"
  vpc_id      = aws_vpc.splunk_vpc.id

  ingress {
    # Splunk web
    from_port = var.splunkweb_port
    to_port   = var.splunkweb_port
    protocol  = "tcp"
    # Please restrict your ingress to only necessary IPs and ports.
    # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
    cidr_blocks = [var.cidr_block,"103.216.190.94/32"] # My static IP at home
    # cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    # Splunk data flow for indexers
    from_port   = var.splunk_tcpin
    to_port     = var.splunk_tcpin
    protocol    = "tcp"
    cidr_blocks = [var.cidr_block,"103.216.190.94/32"] 
  }

  ingress {
    # Splunk management port
    from_port   = var.splunk_mgmt_port
    to_port     = var.splunk_mgmt_port
    protocol    = "tcp"
    cidr_blocks = [var.cidr_block,"103.216.190.94/32"] 
  }

  ingress {
    # Clustered indexer replication port
    from_port   = var.indexer_replication_port
    to_port     = var.indexer_replication_port
    protocol    = "tcp"
    cidr_blocks = [var.cidr_block,"103.216.190.94/32"] 
  }

  ingress {
    # Clustered search head replication port - this is set by the customer and so will change
    from_port   = var.shc_rep_port
    to_port     = var.shc_rep_port
    protocol    = "tcp"
    cidr_blocks = [var.cidr_block,"103.216.190.94/32"] 
  }

  ingress {
    # KV Store replication
    from_port   = var.kvstore_replication_port
    to_port     = var.kvstore_replication_port
    protocol    = "tcp"
    cidr_blocks = [var.cidr_block,"103.216.190.94/32"] 
  }

  ingress {
    # HTTP Event Collector
    from_port   = var.hec_port
    to_port     = var.hec_port
    protocol    = "tcp"
    cidr_blocks = [var.cidr_block,"103.216.190.94/32"] 
  }

  ingress {
    # SSH access for administration
    from_port   = var.ssh_port
    to_port     = var.ssh_port
    protocol    = "tcp"
    cidr_blocks = [var.cidr_block,"103.216.190.94/32"] # My static IP at home, the office IPs

  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    #prefix_list_ids = ["pl-12c4e678"]
  }
  tags = {
    Name = "splunk-cluster-env"
  }
}
