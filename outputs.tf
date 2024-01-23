###
# compute.tf outputs
###

output "container_instance_etcd_id" {
  value = oci_container_instances_container_instance.demo_container_instance_etcd.id
}

output "container_instance_apisix_id" {
  value = oci_container_instances_container_instance.demo_container_instance_apisix.id
}

output "vcn_id" {
  value = ! local.use_existing_network ? join("", oci_core_vcn.container_instance_network.*.id) : var.vcn_id
}

output "public_subnet_id" {
  value = ! local.use_existing_network ? join("", oci_core_subnet.container_instance_public_subnet.*.id) : var.subnet_public_id
}

output "private_subnet_id" {
  value = ! local.use_existing_network ? join("", oci_core_subnet.container_instance_private_subnet.*.id) : var.subnet_private_id
}

output "vcn_cidr_block" {
  value = ! local.use_existing_network ? join("", oci_core_vcn.container_instance_network.*.cidr_block) : var.vcn_cidr_block
}

output "nsg_id" {
  value = join("", oci_core_network_security_group.container_instance_nsg.*.id)
}

output "apisix_access_ip" {
  value = "Access APISIX Gateway via http://${data.oci_core_vnic.apisix_vnic_0_info.public_ip_address}:9180"
}

output "apisix_dashboard_access_ip" {
  value = "Access APISIX Dashboard via http://${data.oci_core_vnic.apisix_dashboard_vnic_0_info.public_ip_address}:9000"
}