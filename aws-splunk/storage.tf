# Attach data disks
resource "aws_volume_attachment" "master_ebs_att" {
  device_name = "/dev/xvdz"
  volume_id   = aws_ebs_volume.master.id
  instance_id = aws_instance.master.id
  skip_destroy = true
}

# create those disks
resource "aws_ebs_volume" "master" {
  availability_zone = var.availability_zone_0
  size              = 1
  tags = {
    Application = "splunk-cluster-env"
  }
}

# Attach data disks
resource "aws_volume_attachment" "master2_ebs_att" {
  device_name = "/dev/xvdz"
  volume_id   = aws_ebs_volume.master2.id
  instance_id = aws_instance.master2.id
  skip_destroy = true
}

# create those disks
resource "aws_ebs_volume" "master2" {
  availability_zone = var.availability_zone_1
  size              = 1
  tags = {
    Application = "splunk-cluster-env"
  }
}

# Attach data disks
resource "aws_volume_attachment" "master3_ebs_att" {
  device_name = "/dev/xvdz"
  volume_id   = aws_ebs_volume.master3.id
  instance_id = aws_instance.master3.id
  skip_destroy = true
}

# create those disks
resource "aws_ebs_volume" "master3" {
  availability_zone = var.availability_zone_2
  size              = 1
  tags = {
    Application = "splunk-cluster-env"
  }
}

# Attach data disks
resource "aws_volume_attachment" "indexer1_ebs_att" {
  device_name = "/dev/xvdz"
  volume_id   = aws_ebs_volume.indexer1.id
  instance_id = aws_instance.indexer1.id
  skip_destroy = true
}

# create those disks
resource "aws_ebs_volume" "indexer1" {
  availability_zone = var.availability_zone_0
  size              = 1
  tags = {
    Application = "splunk-cluster-env"
  }
}

# Attach data disks
resource "aws_volume_attachment" "indexer2_ebs_att" {
  device_name = "/dev/xvdz"
  volume_id   = aws_ebs_volume.indexer2.id
  instance_id = aws_instance.indexer2.id
  skip_destroy = true
}

# create those disks
resource "aws_ebs_volume" "indexer2" {
  availability_zone = var.availability_zone_1
  size              = 1
  tags = {
    Application = "splunk-cluster-env"
  }
}

# Attach data disks
resource "aws_volume_attachment" "indexer3_ebs_att" {
  device_name = "/dev/xvdz"
  volume_id   = aws_ebs_volume.indexer3.id
  instance_id = aws_instance.indexer3.id
  skip_destroy = true
}

# create those disks
resource "aws_ebs_volume" "indexer3" {
  availability_zone = var.availability_zone_2
  size              = 1
  tags = {
    Application = "splunk-cluster-env"
  }
}

# Attach data disks
resource "aws_volume_attachment" "search_head_1_ebs_att" {
  device_name = "/dev/xvdz"
  volume_id   = aws_ebs_volume.search_head_1.id
  instance_id = aws_instance.search_head_1.id
  skip_destroy = true
}

# create those disks
resource "aws_ebs_volume" "search_head_1" {
  availability_zone = var.availability_zone_0
  size              = 1
  tags = {
    Application = "splunk-cluster-env"
  }
}

# Attach data disks
resource "aws_volume_attachment" "search_head_2_ebs_att" {
  device_name = "/dev/xvdz"
  volume_id   = aws_ebs_volume.search_head_2.id
  instance_id = aws_instance.search_head_2.id
  skip_destroy = true
}

# create those disks
resource "aws_ebs_volume" "search_head_2" {
  availability_zone = var.availability_zone_1
  size              = 1
  tags = {
    Application = "splunk-cluster-env"
  }
}

# Attach data disks
resource "aws_volume_attachment" "search_head_3_ebs_att" {
  device_name = "/dev/xvdz"
  volume_id   = aws_ebs_volume.search_head_3.id
  instance_id = aws_instance.search_head_3.id
  skip_destroy = true
}

# create those disks
resource "aws_ebs_volume" "search_head_3" {
  availability_zone = var.availability_zone_2
  size              = 1
  tags = {
    Application = "splunk-cluster-env"
  }
}

# Attach data disks
resource "aws_volume_attachment" "search_head_deployer_ebs_att" {
  device_name = "/dev/xvdz"
  volume_id   = aws_ebs_volume.search_head_deployer.id
  instance_id = aws_instance.search_head_deployer.id
  skip_destroy = true
}

# create those disks
resource "aws_ebs_volume" "search_head_deployer" {
  availability_zone = var.availability_zone_0
  size              = 1
  tags = {
    Application = "splunk-cluster-env"
  }
}
