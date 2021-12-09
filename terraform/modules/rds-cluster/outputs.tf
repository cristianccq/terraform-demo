output "db_instance_endpoint" {
  value = "${module.rds-aurora.cluster_endpoint}"
}

output "db_username" {
   value = "${module.rds-aurora.cluster_master_username}"
}

output "db_password" {
   value = "${module.rds-aurora.cluster_master_password
}"
}
