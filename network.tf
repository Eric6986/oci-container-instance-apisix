# Virtual network setup
resource "oci_core_vcn" "container_instance_network" {
  count          = local.use_existing_network ? 0 : 1
  cidr_block     = var.vcn_cidr_block
  dns_label      = substr(var.vcn_dns_label, 0, 15)
  compartment_id = var.compartment_ocid
  display_name   = var.vcn_display_name

  freeform_tags = {(var.tag_key_name) = (var.tag_value)}
}

# IGW
resource "oci_core_internet_gateway" "container_instance_internet_gateway" {
  count          = local.use_existing_network ? 0 : 1
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.container_instance_network[count.index].id
  enabled        = "true"
  display_name   = "${var.vcn_display_name}-igw"

  freeform_tags = {(var.tag_key_name) = (var.tag_value)}
}

# NATGW
resource "oci_core_nat_gateway" "container_instance_nat_gateway" {
  count          = local.use_existing_network ? 0 : 1
  block_traffic  = "false"
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.container_instance_network[count.index].id
  display_name   = "${var.vcn_display_name}-nat-gw"
  freeform_tags = {(var.tag_key_name) = (var.tag_value)}
}

# For APISIX instance, internet access and expose public IP
resource "oci_core_subnet" "container_instance_public_subnet" {
  count                      = local.use_existing_network ? 0 : 1
  cidr_block                 = var.subnet_public_cidr_block
  compartment_id             = var.compartment_ocid
  vcn_id                     = oci_core_vcn.container_instance_network[count.index].id
  display_name               = var.subnet_public_display_name
  dns_label                  = substr(var.subnet_public_dns_label, 0, 15)
  prohibit_public_ip_on_vnic = false

  freeform_tags = {(var.tag_key_name) = (var.tag_value)}
}

resource "oci_core_route_table" "container_instance_public_route_table" {
  count          = local.use_existing_network ? 0 : 1
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.container_instance_network[count.index].id
  display_name   = "${var.subnet_public_display_name}-rt"

  route_rules {
    network_entity_id = oci_core_internet_gateway.container_instance_internet_gateway[count.index].id
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
  }

  freeform_tags = {(var.tag_key_name) = (var.tag_value)}
}

# For etcd instance, only internal access and access internet by NAT
resource "oci_core_subnet" "container_instance_private_subnet" {
  count                      = local.use_existing_network ? 0 : 1
  cidr_block                 = var.subnet_private_cidr_block
  compartment_id             = var.compartment_ocid
  vcn_id                     = oci_core_vcn.container_instance_network[count.index].id
  display_name               = var.subnet_private_display_name
  dns_label                  = substr(var.subnet_private_dns_label, 0, 15)
  prohibit_public_ip_on_vnic = true

  freeform_tags = {(var.tag_key_name) = (var.tag_value)}
}

resource "oci_core_route_table" "container_instance_private_route_table" {
  count          = local.use_existing_network ? 0 : 1
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.container_instance_network[count.index].id
  display_name   = "${var.subnet_private_display_name}-rt"

  route_rules {
    description       = "Traffic to the internet"
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_nat_gateway.container_instance_nat_gateway[count.index].id
  }

  freeform_tags = {(var.tag_key_name) = (var.tag_value)}
}

resource "oci_core_route_table_attachment" "route_table_public_attachment" {
  count          = local.use_existing_network ? 0 : 1
  subnet_id      = oci_core_subnet.container_instance_public_subnet[count.index].id
  route_table_id = oci_core_route_table.container_instance_public_route_table[count.index].id
}

resource "oci_core_route_table_attachment" "route_table_private_attachment" {
  count          = local.use_existing_network ? 0 : 1
  subnet_id      = oci_core_subnet.container_instance_private_subnet[count.index].id
  route_table_id = oci_core_route_table.container_instance_private_route_table[count.index].id
}

