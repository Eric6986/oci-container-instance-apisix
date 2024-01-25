#Variables declared in this file must be declared in the marketplace.yaml
#Provide a description to your variables.

############################
#  Hidden Variable Group   #
############################
variable "tenancy_ocid" {
}

variable "region" {
}

variable "availability_domain_number" {
  default     = 1
  description = "OCI Availability Domains: 1,2,3  (subject to region availability)"
}



#----------------Hidden Variable Group END----------------------------------------------------------------------


############################
#  Container Instance Configuration - etcd  #
############################

variable "container_instance_display_name_etcd" {
  description = "etcd Container Instance Name"
  default     = "Demo etcd container instance"
}

variable "container_instance_hostname_label_etcd" {
  description = "etcd Container Instance Name"
  default     = "container-instance-etcd"
}

variable "container_instance_compute_shape_etcd" {
  description = "Container Instance Shape"
  default     = "CI.Standard.E4.Flex"
}

variable "container_instance_flex_shape_ocpus_etcd" {
  description = "Flex Shape OCPUs"
  default = 1
}

variable "container_instance_flex_shape_memory_in_gbs_etcd" {
  description = "Flex Shape Memory"
  default = 4
}

variable "container_instance_image_url_etcd" {
  description = "etcd Docker image url"
  default     = "bitnami/etcd:3.5.10"
}

variable "is_public_ip_assigned_etcd" {
  description = "Assigned public to etcd container instance"
  default = false
}

variable "container_restart_policy_etcd" {
  description = "Restart policy for etcd container instance"
  default = "ALWAYS"
}

variable "container_instance_tag_etcd" {
  description = "etcd tag name"
  default = "etcd"
}

############################
#  Container Instance Configuration - APISIX  #
############################

variable "container_instance_display_name_apisix" {
  description = "APISIX Container Instance Name"
  default     = "Demo APISIX container instance"
}

variable "container_instance_hostname_label_apisix" {
  description = "APISIX Container Instance Name"
  default     = "container-instance-apisix"
}

variable "container_instance_compute_shape_apisix" {
  description = "Container Instance Shape"
  default     = "CI.Standard.E4.Flex"
}

variable "container_instance_flex_shape_ocpus_apisix" {
  description = "Flex Shape OCPUs"
  default = 1
}

variable "container_instance_flex_shape_memory_in_gbs_apisix" {
  description = "Flex Shape Memory"
  default = 4
}

variable "container_instance_image_url_apisix" {
  description = "APISIX Docker image url"
  default     = "apache/apisix:3.7.0-debian"
}

variable "is_public_ip_assigned_apisix" {
  description = "Assigned public to APISIX container instance"
  default = true
}

variable "container_restart_policy_apisix" {
  description = "Restart policy for apisix container instance"
  default = "ALWAYS"
}

variable "container_instance_tag_apisix" {
  description = "APISIX tag name"
  default = "APISIX"
}





############################
#  Container Instance Configuration - APISIX Dashboard  #
############################

variable "container_instance_display_name_apisix_dashboard" {
  description = "APISIX Dashboard Container Instance Name"
  default     = "Demo APISIX Dashboard container instance"
}

variable "container_instance_hostname_label_apisix_dashboard" {
  description = "APISIX Dashboard Container Instance Name"
  default     = "container-instance-apisix-dashboard"
}

variable "container_instance_compute_shape_apisix_dashboard" {
  description = "APISIX Dashboard Container Instance Shape"
  default     = "CI.Standard.E4.Flex"
}

variable "container_instance_flex_shape_ocpus_apisix_dashboard" {
  description = "Flex Shape OCPUs"
  default = 1
}

variable "container_instance_flex_shape_memory_in_gbs_apisix_dashboard" {
  description = "Flex Shape Memory"
  default = 4
}

variable "container_instance_image_url_apisix_dashboard" {
  description = "APISIX Dashboard Docker image url"
  default     = "apache/apisix-dashboard:latest"
}

variable "is_public_ip_assigned_apisix_dashboard" {
  description = "Assigned public to APISIX Dashboard container instance"
  default = true
}

variable "container_restart_policy_apisix_dashboard" {
  description = "Restart policy for APISIX Dashboard container instance"
  default = "ALWAYS"
}

variable "container_instance_tag_apisix_dashboard" {
  description = "APISIX Dashboard tag name"
  default = "APISIX Dashboard"
}






































############################
#  Network Configuration   #
############################

variable "network_strategy" {
  #default = "Use Existing VCN and Subnet"
  default = "Create New VCN and Subnet"
}

variable "vcn_id" {
  default = ""
}

variable "vcn_display_name" {
  description = "VCN Name"
  default     = "container-instance-vcn"
}

variable "vcn_cidr_block" {
  description = "VCN CIDR"
  default     = "10.0.0.0/16"
}

variable "vcn_dns_label" {
  description = "VCN DNS Label"
  default     = "civcn"
}

############################
#  Network - Public Subnet Configuration   #
############################

variable "subnet_public_type" {
  description = "Public subnets"
  default     = "Public Subnet"
}

variable "subnet_public_id" {
  default = ""
}

variable "subnet_public_display_name" {
  description = "Public Subnet Name"
  default     = "container-instance-public-subnet"
}

variable "subnet_public_cidr_block" {
  description = "Public Subnet CIDR"
  default     = "10.0.0.0/24"
}

variable "subnet_public_dns_label" {
  description = "Public Subnet DNS Label"
  default     = "public"
}

############################
#  Network - Private Subnet Configuration   #
############################

variable "subnet_private_type" {
  description = "Private subnets"
  default     = "Private Subnet"
}

variable "subnet_private_id" {
  default = ""
}

variable "subnet_private_display_name" {
  description = "Private Subnet Name"
  default     = "container-instance-private-subnet"
}

variable "subnet_private_cidr_block" {
  description = "Private Subnet CIDR"
  default     = "10.0.1.0/24"
}

variable "subnet_private_dns_label" {
  description = "Private Subnet DNS Label"
  default     = "private"
}

############################
# Security Configuration #
############################
variable "nsg_display_name" {
  description = "Network Security Group Name"
  default     = "container-instance-network-security-group"
}

variable "nsg_source_cidr" {
  description = "Allowed Ingress Traffic (CIDR Block)"
  default     = "0.0.0.0/0"
}

variable "nsg_ssh_port" {
  description = "SSH Port"
  default     = 22
}

variable "nsg_https_port" {
  description = "HTTPS Port"
  default     = 443
}

variable "nsg_http_port" {
  description = "HTTP Port"
  default     = 80
}

variable "nsg_etcd_port" {
  description = "ETCD Port"
  default     = 2379
}

variable "nsg_apisix_9180_port" {
  description = "APISIX 9180 Port"
  default     = 9180
}

variable "nsg_apisix_9080_port" {
  description = "APISIX 9080 Port"
  default     = 9080
}

variable "nsg_apisix_9091_port" {
  description = "APISIX 9091 Port"
  default     = 9091
}

variable "nsg_apisix_9443_port" {
  description = "APISIX 9443 Port"
  default     = 9443
}

variable "nsg_apisix_9092_port" {
  description = "APISIX 9092 Port"
  default     = 9092
}

variable "nsg_apisix_dashboard_9000_port" {
  description = "APISIX Dashboard 9000 Port"
  default     = 9000
}

############################
# Additional Configuration #
############################

variable "compartment_ocid" {
  description = "Compartment where Compute and Marketplace subscription resources will be created"
}

variable "tag_key_name" {
  description = "Free-form tag key name"
  default     = "oci-container-instance"
}

variable "tag_value" {
  description = "Free-form tag value"
  default     = "oci-container-instance-template"
}





######################
#    Enum Values     #
######################
variable "network_strategy_enum" {
  type = map
  default = {
    CREATE_NEW_VCN_SUBNET   = "Create New VCN and Subnet"
    USE_EXISTING_VCN_SUBNET = "Use Existing VCN and Subnet"
  }
}

variable "subnet_type_enum" {
  type = map
  default = {
    PRIVATE_SUBNET = "Private Subnet"
    PUBLIC_SUBNET  = "Public Subnet"
  }
}

variable "nsg_config_enum" {
  type = map
  default = {
    BLOCK_ALL_PORTS = "Block all ports"
    OPEN_ALL_PORTS  = "Open all ports"
    CUSTOMIZE       = "Customize ports - Post deployment"
  }
}

variable "availability_domain_name" {
  default     = ""
  description = "Availability Domain name, if non-empty takes precedence over availability_domain_number"
}