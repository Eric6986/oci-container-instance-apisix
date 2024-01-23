# ------------------------------------------------------------------------------------------------ container instance

data "oci_identity_availability_domains" "local_ads" {
  compartment_id = var.compartment_ocid
}

resource "oci_container_instances_container_instance" "demo_container_instance_etcd" {

  # create the container instance in AD1
  availability_domain      = local.availability_domain
  compartment_id           = var.compartment_ocid
  freeform_tags            = { "project-name" = var.container_instance_tag_etcd }
  display_name             = var.container_instance_display_name_etcd
  container_restart_policy = var.container_restart_policy_etcd
  shape                    = var.container_instance_compute_shape_etcd
  shape_config {

    memory_in_gbs = var.container_instance_flex_shape_memory_in_gbs_etcd
    ocpus         = var.container_instance_flex_shape_ocpus_etcd
  }

  vnics {
    subnet_id             = local.use_existing_network ? var.subnet_private_id : oci_core_subnet.container_instance_private_subnet[0].id
    display_name          = var.container_instance_display_name_etcd
    hostname_label        = var.container_instance_hostname_label_etcd
    is_public_ip_assigned = var.is_public_ip_assigned_etcd
    nsg_ids               = [oci_core_network_security_group.container_instance_nsg.id]
  }

  containers {
    image_url    = var.container_instance_image_url_etcd
    display_name = var.container_instance_display_name_etcd
    environment_variables = local.etcd_environment_variable
    
    volume_mounts {
      # Required
      mount_path = "/opt/bitnami/etcd/conf/"
      volume_name = "etcd_config"

      #Optional
      #Please refer the OCI terraform document https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/container_instances_container_instance#volume_mounts
    }

    volume_mounts {
      # Required
      mount_path = "/bitnami/etcd"
      volume_name = "etcd_data"

      #Optional
      #Please refer the OCI terraform document https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/container_instances_container_instance#volume_mounts
    }
  }

  volumes {
    name         = "etcd_config"
    volume_type  = "CONFIGFILE"
    configs {

      #Optional
      # Please refer the apisix docker github about the etcd config file. 
      #https://github.com/apache/apisix-docker/blob/master/example/etcd_conf/etcd.conf.yml
      #data      = filebase64("${path.module}/config/etcd.conf.yml")
      data = base64encode(join("\n", [
          for line in split("\n", file("${path.module}/config/etcd.conf.yml")) : 
            (
              length(regexall("localhost:2379", line)) > 0 ? replace(line, "localhost:2379", "${lookup(local.apisix_environment_variable, "ETCD_HOST", "localhost:2379")}:2379") : 
              (
                length(regexall("localhost:2380", line)) > 0 ? replace(line, "localhost:2380", "${lookup(local.apisix_environment_variable, "ETCD_HOST", "localhost:2380")}:2380") : line
              )
            )
       ]))
      file_name = "etcd.conf.yml"
    }
  }

  volumes {
    name         = "etcd_data"
    volume_type  = "EMPTYDIR"
  }
}

resource "oci_container_instances_container_instance" "demo_container_instance_apisix" {
  depends_on                 = [ oci_container_instances_container_instance.demo_container_instance_etcd ]
  # create the container instance in AD1
  availability_domain      = local.availability_domain
  compartment_id           = var.compartment_ocid
  freeform_tags            = { "project-name" = var.container_instance_tag_apisix }
  display_name             = var.container_instance_display_name_apisix
  container_restart_policy = var.container_restart_policy_apisix
  shape                    = var.container_instance_compute_shape_apisix
  shape_config {

    memory_in_gbs = var.container_instance_flex_shape_memory_in_gbs_apisix
    ocpus         = var.container_instance_flex_shape_ocpus_apisix
  }

  vnics {
    subnet_id             = local.use_existing_network ? var.subnet_public_id : oci_core_subnet.container_instance_public_subnet[0].id
    display_name          = var.container_instance_display_name_apisix
    hostname_label        = var.container_instance_hostname_label_apisix
    is_public_ip_assigned = var.is_public_ip_assigned_apisix
    nsg_ids               = [oci_core_network_security_group.container_instance_nsg.id]
  }

  containers {
    image_url    = var.container_instance_image_url_apisix
    display_name = var.container_instance_display_name_apisix
    environment_variables = local.apisix_environment_variable

    # In OCI container instance, you have to use the mount file as your apisix config file. 
    # Please refer the apisix github about the config file. 
    # https://github.com/apache/apisix/tree/master/conf
    volume_mounts {
      #Required            
      mount_path = "/usr/local/apisix/conf/"
      volume_name = "apisix_config"

      #Optional
      #Please refer the OCI terraform document https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/container_instances_container_instance#volume_mounts
    }
    volume_mounts {
      #Required
      mount_path = "/usr/local/apisix/conf/cert/"
      volume_name = "apisix_config_cert"

      #Optional
      #Please refer the OCI terraform document https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/container_instances_container_instance#volume_mounts
    }
    security_context {
      #Optional
      run_as_group = 0
      run_as_user = 0
    }
  }

  volumes {
    name         = "apisix_config"
    volume_type  = "CONFIGFILE"
    configs {

        #Optional
        data = filebase64("${path.module}/config/config-default.yaml")
        file_name = "config-default.yaml"
    }
    configs {

        #Optional
        data = filebase64("${path.module}/config/config.yaml")
        file_name = "config.yaml"
    }
    configs {

        #Optional
        data = filebase64("${path.module}/config/mime.types")
        file_name = "mime.types"
    }
    configs {

        #Optional
        data = filebase64("${path.module}/config/debug.yaml")
        file_name = "debug.yaml"
    }
  }

  volumes {
    name         = "apisix_config_cert"
    volume_type  = "CONFIGFILE"
    configs {

        #Optional
        data = filebase64("${path.module}/config/cert/ssl_PLACE_HOLDER.crt")
        file_name = "ssl_PLACE_HOLDER.crt"
    }
    configs {

        #Optional
        data = filebase64("${path.module}/config/cert/ssl_PLACE_HOLDER.key")
        file_name = "ssl_PLACE_HOLDER.key"
    }
  }
}

resource "oci_container_instances_container_instance" "demo_container_instance_apisix_dashboard" {
  depends_on                 = [ oci_container_instances_container_instance.demo_container_instance_apisix ]
  # create the container instance in AD1
  availability_domain      = local.availability_domain
  compartment_id           = var.compartment_ocid
  freeform_tags            = { "project-name" = var.container_instance_tag_apisix_dashboard }
  display_name             = var.container_instance_display_name_apisix_dashboard
  container_restart_policy = var.container_restart_policy_apisix_dashboard
  shape                    = var.container_instance_compute_shape_apisix_dashboard
  shape_config {

    memory_in_gbs = var.container_instance_flex_shape_memory_in_gbs_apisix_dashboard
    ocpus         = var.container_instance_flex_shape_ocpus_apisix_dashboard
  }

  vnics {
    subnet_id             = local.use_existing_network ? var.subnet_public_id : oci_core_subnet.container_instance_public_subnet[0].id
    display_name          = var.container_instance_display_name_apisix_dashboard
    hostname_label        = var.container_instance_hostname_label_apisix_dashboard
    is_public_ip_assigned = var.is_public_ip_assigned_apisix_dashboard
    nsg_ids               = [oci_core_network_security_group.container_instance_nsg.id]
  }

  containers {
    image_url    = var.container_instance_image_url_apisix_dashboard
    display_name = var.container_instance_display_name_apisix_dashboard

    # In OCI container instance, you have to use the mount file as your apisix config file. 
    # Please refer the apisix github about the config file. 
    # https://github.com/apache/apisix/tree/master/conf
    volume_mounts {
      #Required            
      mount_path = "/usr/local/apisix-dashboard/conf/"
      volume_name = "apisix_dashboard_config"

      #Optional
      #Please refer the OCI terraform document https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/container_instances_container_instance#volume_mounts
    }
  }

  volumes {
    name         = "apisix_dashboard_config"
    volume_type  = "CONFIGFILE"
    configs {

        #Optional
        data = base64encode(join("\n", [
          for line in split("\n", file("${path.module}/config/conf.yaml")) : 
            (
              length(regexall("127.0.0.1:2379", line)) > 0 ? replace(line, "127.0.0.1:2379", "${lookup(local.apisix_environment_variable, "ETCD_HOST", "127.0.0.1:2379")}:2379") : 
              (
                length(regexall("127.0.0.1", line)) > 0 ? replace(line, "127.0.0.1", "0.0.0.0/0") : line
              )
            )
       ]))
        file_name = "conf.yaml"
    }
    configs {

        #Optional
        data = filebase64("${path.module}/config/customize_schema.json")
        file_name = "customize_schema.json"
    }
    configs {

        #Optional
        data = filebase64("${path.module}/config/schema.json")
        file_name = "schema.json"
    }
  }
}