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
  tags = {
    Name = "splunk-cluster-env"
  }
}

resource aws_subnet "splunk_subnet_2" {
  vpc_id            = aws_vpc.splunk_vpc.id
  cidr_block        = var.subnet_2
  availability_zone = var.availability_zone_1
  tags = {
    Name = "splunk-cluster-env"
  }
}

resource aws_subnet "splunk_subnet_3" {
  vpc_id            = aws_vpc.splunk_vpc.id
  cidr_block        = var.subnet_3
  availability_zone = var.availability_zone_2
  tags = {
    Name = "splunk-cluster-env"
  }
}

resource aws_network_interface "master" {
  subnet_id   = aws_subnet.splunk_subnet_1.id
  private_ips = ["172.30.1.5"]
  tags = {
    Name = "splunk-cluster-env"
  }
}

resource aws_network_interface "master2" {
  subnet_id   = aws_subnet.splunk_subnet_2.id
  private_ips = ["172.30.2.5"]
  tags = {
    Name = "splunk-cluster-env"
  }
}

resource aws_network_interface "master3" {
  subnet_id   = aws_subnet.splunk_subnet_3.id
  private_ips = ["172.30.3.5"]
  tags = {
    Name = "splunk-cluster-env"
  }
}

resource aws_network_interface "indexer1" {
  subnet_id   = aws_subnet.splunk_subnet_1.id
  private_ips = ["172.30.1.10"]
  tags = {
    Name = "splunk-cluster-env"
  }
}

resource aws_network_interface "indexer2" {
  subnet_id   = aws_subnet.splunk_subnet_2.id
  private_ips = ["172.30.2.10"]
  tags = {
    Name = "splunk-cluster-env"
  }
}

resource aws_network_interface "indexer3" {
  subnet_id   = aws_subnet.splunk_subnet_3.id
  private_ips = ["172.30.3.10"]
  tags = {
    Name = "splunk-cluster-env"
  }
}

resource aws_network_interface "search_head_deployer" {
  subnet_id   = aws_subnet.splunk_subnet_1.id
  private_ips = ["172.30.1.50"]
  tags = {
    Name = "splunk-cluster-env"
  }
}

resource aws_network_interface "search_head_1" {
  subnet_id   = aws_subnet.splunk_subnet_1.id
  private_ips = ["172.30.1.51"]
  tags = {
    Name = "splunk-cluster-env"
  }
}

resource aws_network_interface "search_head_2" {
  subnet_id   = aws_subnet.splunk_subnet_2.id
  private_ips = ["172.30.1.51"]
  tags = {
    Name = "splunk-cluster-env"
  }
}

resource aws_network_interface "search_head_3" {
  subnet_id   = aws_subnet.splunk_subnet_3.id
  private_ips = ["172.30.3.51"]
  tags = {
    Name = "splunk-cluster-env"
  }
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
