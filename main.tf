# You cannot create a new backend by simply defining this and then
# immediately proceeding to "terraform apply". The S3 backend must
# be bootstrapped according to the simple yet essential procedure in
# https://github.com/cloudposse/terraform-aws-tfstate-backend#usage
module terraform_state_backend {
  source     = "git::https://github.com/egadsthefuzz/terraform-aws-tfstate-backend.git?ref=safety-changes"
  namespace  = "egadsthefuzz"
  stage      = "test"
  name       = "terraform"
  attributes = ["statestore"]

  terraform_backend_config_file_path = "."
  terraform_backend_config_file_name = "backend.tf"
  force_destroy                      = false
}

# Set AWS as the provider and establish creds and default region
provider aws {
  shared_credentials_file = var.shared_credentials
  profile                 = var.profile
  region                  = var.region
}

# Create a data object using the user's public SSH key
# If no such file exists, the user must generate it using ssh-keygen
data local_file "public_key" {
  filename = var.data_local_file_public_key
}

# Create an ec2_key and map it to the local file specified above
resource aws_key_pair "ec2_key" {
  key_name   = var.env_name
  public_key = data.local_file.public_key.content
}

# The comma after the inventory IP is actually right and important '${self.public_ip},' https://stackoverflow.com/questions/17188147/how-to-run-ansible-without-specifying-the-inventory-but-the-host-directly
# Create the vms - Cluster Master
resource aws_instance "master" {
  ami               = var.ami
  instance_type     = var.cluster_master_size
  key_name          = aws_key_pair.ec2_key.key_name
  availability_zone = var.availability_zone_0
  network_interface {
    network_interface_id = aws_network_interface.master.id
    device_index         = 0
    security_groups   = [aws_security_group.splunk_generic.name]
  }
  provisioner local-exec {
    command = "sleep 20; ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u ubuntu -i '${self.public_ip},' master.yml -e 'cluster_master_public_ip=${self.public_ip}' -e 'splunk_password=${var.splunk_password}'  -e 'sites_string=site1,site2,site3' -t cluster_master -e 'ansible_python_interpreter=/usr/bin/python3' -e 'cluster_master_active=true' -e 'cluster_master_site=site1'"
  }
  tags = {
    Name = "Cluster Master Site 1"
  }
}

# Create the vms - Cluster Master Standby 1
resource aws_instance "master2" {
  ami               = var.ami
  instance_type     = var.cluster_master_size
  key_name          = aws_key_pair.ec2_key.key_name
  availability_zone = var.availability_zone_1
  network_interface {
    network_interface_id = aws_network_interface.master2.id
    device_index         = 0
    security_groups   = [aws_security_group.splunk_generic.name]
  }
  provisioner local-exec {
    command = "sleep 20; ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u ubuntu -i '${self.public_ip},' master.yml -e 'cluster_master_public_ip=${self.public_ip}' -e 'splunk_password=${var.splunk_password}'  -e 'sites_string=site1,site2,site3' -t cluster_master -e 'ansible_python_interpreter=/usr/bin/python3' -e 'cluster_master_active=false' -e 'cluster_master_site=site2'"
  }
  tags = {
    Name = "Cluster Master Site 2"
  }
}

# Create the vms - Cluster Master Standby 2
resource aws_instance "master3" {
  ami               = var.ami
  instance_type     = var.cluster_master_size
  key_name          = aws_key_pair.ec2_key.key_name
  availability_zone = var.availability_zone_2
  network_interface {
    network_interface_id = aws_network_interface.master3.id
    device_index         = 0
    security_groups   = [aws_security_group.splunk_generic.name]
  }
  provisioner local-exec {
    command = "sleep 20; ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u ubuntu -i '${self.public_ip},' master.yml -e 'cluster_master_public_ip=${self.public_ip}' -e 'splunk_password=${var.splunk_password}'  -e 'sites_string=site1,site2,site3' -t cluster_master -e 'ansible_python_interpreter=/usr/bin/python3' -e 'cluster_master_active=false' -e 'cluster_master_site=site3'"
  }
  tags = {
    Name = "Cluster Master Site 3"
  }
}

# Create the vms - Indexer 1 - Site 1
resource aws_instance "indexer1" {
  ami               = var.ami
  instance_type     = var.indexer_size
  key_name          = aws_key_pair.ec2_key.key_name
  availability_zone = var.availability_zone_0
  network_interface {
    network_interface_id = aws_network_interface.indexer1.id
    device_index         = 0
    security_groups   = [aws_security_group.splunk_generic.name]
  }
  provisioner local-exec {
    command = "sleep 20; ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u ubuntu -i '${self.public_ip},' master.yml -e 'idx_num=1' -e 'cluster_master_public_ip=${aws_instance.master.public_ip}' -e 'splunk_password=${var.splunk_password}' -e 'site_string=site1' -t indexers -e 'ansible_python_interpreter=/usr/bin/python3'"
  }
  tags = {
    Name = "Indexer 1"
  }
}

# Create the vms - Indexer 2 - Site 2
resource aws_instance "indexer2" {
  ami               = var.ami
  instance_type     = var.indexer_size
  key_name          = aws_key_pair.ec2_key.key_name
  availability_zone = var.availability_zone_1
  network_interface {
    network_interface_id = aws_network_interface.indexer2.id
    device_index         = 0
    security_groups   = [aws_security_group.splunk_generic.name]
  }
  provisioner local-exec {
    command = "sleep 20; ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u ubuntu -i '${self.public_ip},' master.yml -e 'idx_num=2' -e 'cluster_master_public_ip=${aws_instance.master.public_ip}' -e 'splunk_password=${var.splunk_password}' -e 'site_string=site2' -t indexers -e 'ansible_python_interpreter=/usr/bin/python3'"
  }
  tags = {
    Name = "Indexer 2"
  }
}

# Create the vms - Indexer 3 - Site 3
resource aws_instance "indexer3" {
  ami               = var.ami
  instance_type     = var.indexer_size
  key_name          = aws_key_pair.ec2_key.key_name
  availability_zone = var.availability_zone_2
  network_interface {
    network_interface_id = aws_network_interface.indexer3.id
    device_index         = 0
    security_groups   = [aws_security_group.splunk_generic.name]
  }
  provisioner local-exec {
    command = "sleep 20; ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u ubuntu -i '${self.public_ip},' master.yml -e 'idx_num=3' -e 'cluster_master_public_ip=${aws_instance.master.public_ip}' -e 'splunk_password=${var.splunk_password}' -e 'site_string=site3' -t indexers -e 'ansible_python_interpreter=/usr/bin/python3'"
  }
  tags = {
    Name = "Indexer 2"
  }
}

# Create the vms - Search Head Deployer - Site 0
resource aws_instance "search_head_deployer" {
  ami               = var.ami
  instance_type     = var.generic_size
  key_name          = aws_key_pair.ec2_key.key_name
  availability_zone = var.availability_zone_0
  network_interface {
    network_interface_id = aws_network_interface.search_head_deployer.id
    device_index         = 0
    security_groups   = [aws_security_group.splunk_generic.name]
  }
  provisioner local-exec {
    command = "sleep 20; ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u ubuntu -i '${self.public_ip},' master.yml -e 'role_title=search_head_deployer' -e 'deployer_ip=${self.public_ip}' -e 'cluster_master_public_ip=${aws_instance.master.public_ip}' -e 'splunk_password=${var.splunk_password}' -e 'site_string=site0' -t search_head_deployer -e 'ansible_python_interpreter=/usr/bin/python3'"
  }
  tags = {
    Name = "Search Head Deployer"
  }
}


# Create the vms - Search Head 1 - Site 1
resource aws_instance "search_head_1" {
  ami               = var.ami
  instance_type     = var.search_head_size
  key_name          = aws_key_pair.ec2_key.key_name
  availability_zone = var.availability_zone_0
  network_interface {
    network_interface_id = aws_network_interface.search_head_1.id
    device_index         = 0
    security_groups   = [aws_security_group.splunk_generic.name]
  }
  provisioner local-exec {
    command = "sleep 20; ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u ubuntu -i '${self.public_ip},' master.yml -e 'role_title=search_head_1' -e 'shcluster_label=var.shcluster_label' -e 'shc_pass=${var.shc_pass4SymmKey}' -e 'deployer_url=${aws_instance.search_head_deployer.public_ip}' -e 'shc_rep_factor=${var.shc_rep_factor}' -e 'shc_rep_port=${var.shc_rep_port}' -e 'self_ip=${self.public_ip}' -e 'cluster_master_public_ip=${aws_instance.master.public_ip}' -e 'splunk_password=${var.splunk_password}' -e 'site_string=site0' -t search_heads -e 'ansible_python_interpreter=/usr/bin/python3'"
  }
  tags = {
    Name = "Search Head 1"
  }
}

# Create the vms - Search Head 2 - Site 2
resource aws_instance "search_head_2" {
  ami               = var.ami
  instance_type     = var.search_head_size
  key_name          = aws_key_pair.ec2_key.key_name
  availability_zone = var.availability_zone_1
  network_interface {
    network_interface_id = aws_network_interface.search_head_2.id
    device_index         = 0
    security_groups   = [aws_security_group.splunk_generic.name]
}
  provisioner local-exec {
    command = "sleep 20; ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u ubuntu -i '${self.public_ip},' master.yml -e 'role_title=search_head_2' -e 'shcluster_label=${var.shcluster_label}' -e 'shc_pass=${var.shc_pass4SymmKey}' -e 'deployer_url=${aws_instance.search_head_deployer.public_ip}' -e 'shc_rep_factor=${var.shc_rep_factor}' -e 'shc_rep_port=${var.shc_rep_port}' -e 'self_ip=${self.public_ip}' -e 'cluster_master_public_ip=${aws_instance.master.public_ip}' -e 'splunk_password=${var.splunk_password}' -e 'site_string=site0' -t search_heads -e 'ansible_python_interpreter=/usr/bin/python3'"
  }
  tags = {
    Name = "Search Head 2"
  }
}

# Create the vms - Search Head 3 - Site 3 
resource aws_instance "search_head_3" {
  ami               = var.ami
  instance_type     = var.search_head_size
  key_name          = aws_key_pair.ec2_key.key_name
  availability_zone = var.availability_zone_2
  network_interface {
    network_interface_id = aws_network_interface.search_head_3.id
    device_index         = 0
    security_groups   = [aws_security_group.splunk_generic.name]
  }
  provisioner local-exec {
    command = "sleep 20; ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u ubuntu -i '${self.public_ip},' master.yml -e 'role_title=search_head_3' -e 'shcluster_label=${var.shcluster_label}' -e 'shc_pass=${var.shc_pass4SymmKey}' -e 'deployer_url=${aws_instance.search_head_deployer.public_ip}' -e 'shc_rep_factor=${var.shc_rep_factor}' -e 'shc_rep_port=${var.shc_rep_port}' -e 'self_ip=${self.public_ip}' -e 'cluster_master_public_ip=${aws_instance.master.public_ip}' -e 'splunk_password=${var.splunk_password}' -e 'site_string=site0' -e 'sh1=${aws_instance.search_head_1.public_ip}' -e sh2='${aws_instance.search_head_2.public_ip}' -t search_head_captain -e 'ansible_python_interpreter=/usr/bin/python3'"
  }
  tags = {
    Name = "Search Head 3"
  }
}

# shared IP to load balance between the masters so no config fix can happen
# Super duper a WIP
#resource aws_lb "master_node" {
#  name               = "master_nodes"
#  internal           = false
#  load_balancer_type = "network"
#  subnets            = [aws_subnet.public.*.id]
#aws_instance.master.public_ip
#  enable_deletion_protection = true
#
#}
