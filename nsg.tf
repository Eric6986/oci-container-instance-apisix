resource "oci_core_network_security_group" "container_instance_nsg" {
  #Required
  compartment_id = var.compartment_ocid
  vcn_id         = local.use_existing_network ? var.vcn_id : oci_core_vcn.container_instance_network.0.id

  #Optional
  display_name = var.nsg_display_name

  freeform_tags = {(var.tag_key_name) = (var.tag_value)}
}

# Allow Egress traffic to all networks
resource "oci_core_network_security_group_security_rule" "container_instance_rule_egress" {
  network_security_group_id = oci_core_network_security_group.container_instance_nsg.id

  direction   = "EGRESS"
  protocol    = "all"
  destination = "0.0.0.0/0"

}

# Allow SSH (TCP port 22) Ingress traffic from any network
resource "oci_core_network_security_group_security_rule" "container_instance_rule_ssh_ingress" {
  network_security_group_id = oci_core_network_security_group.container_instance_nsg.id
  protocol                  = "6"
  direction                 = "INGRESS"
  source                    = var.nsg_source_cidr
  stateless                 = false

  tcp_options {
    destination_port_range {
      min = var.nsg_ssh_port
      max = var.nsg_ssh_port
    }
  }
}

# Allow HTTPS (TCP port 443) Ingress traffic from any network
resource "oci_core_network_security_group_security_rule" "container_instance_rule_https_ingress" {
  network_security_group_id = oci_core_network_security_group.container_instance_nsg.id
  protocol                  = "6"
  direction                 = "INGRESS"
  source                    = var.nsg_source_cidr
  stateless                 = false

  tcp_options {
    destination_port_range {
      min = var.nsg_https_port
      max = var.nsg_https_port
    }
  }
}

# Allow HTTP (TCP port 80) Ingress traffic from any network
resource "oci_core_network_security_group_security_rule" "container_instance_rule_http_ingress" {
  network_security_group_id = oci_core_network_security_group.container_instance_nsg.id
  protocol                  = "6"
  direction                 = "INGRESS"
  source                    = var.nsg_source_cidr
  stateless                 = false

  tcp_options {
    destination_port_range {
      min = var.nsg_http_port
      max = var.nsg_http_port
    }
  }
}

# Allow HTTP (TCP port 2379) Ingress traffic from any network
resource "oci_core_network_security_group_security_rule" "container_instance_rule_etcd_ingress" {
  network_security_group_id = oci_core_network_security_group.container_instance_nsg.id
  protocol                  = "6"
  direction                 = "INGRESS"
  source                    = var.nsg_source_cidr
  stateless                 = false

  tcp_options {
    destination_port_range {
      min = var.nsg_etcd_port
      max = var.nsg_etcd_port
    }
  }
}

# Allow HTTP (TCP port 9180) Ingress traffic from any network
resource "oci_core_network_security_group_security_rule" "container_instance_rule_apisix_9180_ingress" {
  network_security_group_id = oci_core_network_security_group.container_instance_nsg.id
  protocol                  = "6"
  direction                 = "INGRESS"
  source                    = var.nsg_source_cidr
  stateless                 = false

  tcp_options {
    destination_port_range {
      min = var.nsg_apisix_9180_port
      max = var.nsg_apisix_9180_port
    }
  }
}

# Allow HTTP (TCP port 9080) Ingress traffic from any network
resource "oci_core_network_security_group_security_rule" "container_instance_rule_apisix_9080_ingress" {
  network_security_group_id = oci_core_network_security_group.container_instance_nsg.id
  protocol                  = "6"
  direction                 = "INGRESS"
  source                    = var.nsg_source_cidr
  stateless                 = false

  tcp_options {
    destination_port_range {
      min = var.nsg_apisix_9080_port
      max = var.nsg_apisix_9080_port
    }
  }
}

# Allow HTTP (TCP port 9091) Ingress traffic from any network
resource "oci_core_network_security_group_security_rule" "container_instance_rule_apisix_9091_ingress" {
  network_security_group_id = oci_core_network_security_group.container_instance_nsg.id
  protocol                  = "6"
  direction                 = "INGRESS"
  source                    = var.nsg_source_cidr
  stateless                 = false

  tcp_options {
    destination_port_range {
      min = var.nsg_apisix_9091_port
      max = var.nsg_apisix_9091_port
    }
  }
}

# Allow HTTP (TCP port 9443) Ingress traffic from any network
resource "oci_core_network_security_group_security_rule" "container_instance_rule_apisix_9443_ingress" {
  network_security_group_id = oci_core_network_security_group.container_instance_nsg.id
  protocol                  = "6"
  direction                 = "INGRESS"
  source                    = var.nsg_source_cidr
  stateless                 = false

  tcp_options {
    destination_port_range {
      min = var.nsg_apisix_9443_port
      max = var.nsg_apisix_9443_port
    }
  }
}

# Allow HTTP (TCP port 9092) Ingress traffic from any network
resource "oci_core_network_security_group_security_rule" "container_instance_rule_apisix_9092_ingress" {
  network_security_group_id = oci_core_network_security_group.container_instance_nsg.id
  protocol                  = "6"
  direction                 = "INGRESS"
  source                    = var.nsg_source_cidr
  stateless                 = false

  tcp_options {
    destination_port_range {
      min = var.nsg_apisix_9092_port
      max = var.nsg_apisix_9092_port
    }
  }
}

# Allow HTTP (TCP port 9000) Ingress traffic from any network
resource "oci_core_network_security_group_security_rule" "container_instance_rule_apisix_dashboard_9000_ingress" {
  network_security_group_id = oci_core_network_security_group.container_instance_nsg.id
  protocol                  = "6"
  direction                 = "INGRESS"
  source                    = var.nsg_source_cidr
  stateless                 = false

  tcp_options {
    destination_port_range {
      min = var.nsg_apisix_dashboard_9000_port
      max = var.nsg_apisix_dashboard_9000_port
    }
  }
}

# Allow ANY Ingress traffic from within simple vcn
resource "oci_core_network_security_group_security_rule" "container_instance_rule_all_container_instance_vcn_ingress" {
  network_security_group_id = oci_core_network_security_group.container_instance_nsg.id
  protocol                  = "all"
  direction                 = "INGRESS"
  source                    = var.vcn_cidr_block
  stateless                 = false
}
