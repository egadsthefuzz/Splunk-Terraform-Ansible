# Splunk-Terraform-Ansible
A terraform and ansible combo that builds a multisite Splunk indexer cluster and a search head cluster in AWS

Combines in https://github.com/egadsthefuzz/terraform-aws-tfstate-backend and https://github.com/egadsthefuzz/s3-backend-tf-setup to have a persistent s3 setup

Also tweaked to work with current TF. Ansible still needs more work

Doing a destroy is by design semi painful so you have to try to remove your s3 backend 
