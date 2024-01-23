locals {

  # Logic to use AD name provided by user input on ORM or to lookup for the AD name when running from CLI
  availability_domain = (var.availability_domain_name != "" ? var.availability_domain_name : data.oci_identity_availability_domain.ad.name)

  # local.use_existing_network referenced in network.tf
  use_existing_network = var.network_strategy == var.network_strategy_enum["USE_EXISTING_VCN_SUBNET"] ? true : false

  # local.etcd_host referenced in container_instance.tf for apisix to call etcd host
  apisix_environment_variable = {
    ETCD_HOST   = "${var.container_instance_hostname_label_etcd}.${substr(var.subnet_private_dns_label, 0, 15)}.${substr(var.vcn_dns_label, 0, 15)}.oraclevcn.com"
  }

  etcd_environment_variable = {
    ALLOW_NONE_AUTHENTICATION    = "yes"
    ETCD_ADVERTISE_CLIENT_URLS   = "http://${var.container_instance_hostname_label_etcd}.${substr(var.subnet_private_dns_label, 0, 15)}.${substr(var.vcn_dns_label, 0, 15)}.oraclevcn.com:2379"
  }

  # Logic to select Oracle Autonomous Linux 7 platform image (version pegged in data source filter)
  platform_image_id = data.oci_core_images.autonomous_ol7.images[0].id
}
