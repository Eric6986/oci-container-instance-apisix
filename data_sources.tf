data "oci_identity_availability_domain" "ad" {
  compartment_id = var.tenancy_ocid
  ad_number      = var.availability_domain_number
}

data "oci_core_images" "autonomous_ol7" {
  compartment_id   = var.compartment_ocid
  operating_system = "Oracle Autonomous Linux"
  sort_by          = "TIMECREATED"
  sort_order       = "DESC"
  state            = "AVAILABLE"

  # filter restricts to OL 7
  filter {
    name   = "operating_system_version"
    values = ["7\\.[0-9]"]
    regex  = true
  }
}

data  "oci_core_vnic" "apisix_vnic_0_info" {
  #Required
  vnic_id = oci_container_instances_container_instance.demo_container_instance_apisix.vnics[0].vnic_id
}

data  "oci_core_vnic" "apisix_dashboard_vnic_0_info" {
  #Required
  vnic_id = oci_container_instances_container_instance.demo_container_instance_apisix_dashboard.vnics[0].vnic_id
}
