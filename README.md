# Use OCI container instance to create your APISIX gateway

## Project description

The example code will show how to use the OCI container instance to build a APISIX gateway.

## How to use code

```
Before you apply the plan, you can try to use the OpenTofu https://opentofu.org/ to replace the terraform command. It is a fork of Terraform that is open-source, community-driven, and managed by the Linux Foundation. All the command should be same with Terraform. Try it!
```

### STEP 1

Clone the repo from GitHub by executing the command as follows:

```
[~] git clone https://github.com/Eric6986/oci-container-instance-apisix.git
[~] cd oci-container-instance-apisix/
[~/oci-container-instance-apisix] ls -lt
-rw-r--r--  1 erichsieh  staff  10685 Feb  7 15:30 README.md
(...)
```

### STEP 2
```
If you would like to using the default setup, I had download APISIX source configuration code here. You can skip the step and goto STEP 4.  
```
We are using the apisix offical docker image (3.7.0) to build the container instance example, so you can execute the below script to download the apisix github config file. 

```
[~] rm -rf config && mkdir config && wget https://raw.githubusercontent.com/apache/apisix-docker/master/example/etcd_conf/etcd.conf.yml -P ./config && wget https://github.com/apache/apisix/archive/refs/tags/3.7.0.zip && unzip 3.7.0.zip "*apisix-3.7.0/conf/*.*" && mv ./apisix-3.7.0/conf/* ./config && rm -rf ./*3.7.0* && wget https://github.com/apache/apisix-dashboard/archive/refs/tags/v3.0.1.zip && unzip v3.0.1.zip "*apisix-dashboard-3.0.1/api/conf/*.*" && mv ./apisix-dashboard-3.0.1/api/conf/* ./config && rm -rf ./*3.0.1*
```

### STEP 3

https://github.com/apache/apisix/blob/master/conf/config.yaml
In the code comments, it mentioned if you would like to use the different etcd host, like IP or specific host name you have. You can use the environment variable to replace the etcd endpoint. Since we don't know the etcd IP before we create it, in the example, we use the ETCD_HOST environment variable to replcae the localhost etcd endpoint, instead of using the instance labal as our etcd host. Please refer the below example to add etcd host in your apisix config file.

```
# To configure via environment variables, you can use `${{VAR}}` syntax. For instance:
#
# deployment:
#   role: traditional
#   role_traditional:
#     config_provider: etcd
#   etcd:
#     host:
#       - http://${{ETCD_HOST}}:2379
```

### STEP 4

Run source tf_vars_setting.sh to setup terraform environment variable.  I assume you already setup your OCI CLI tool in your operating system. so the default script will to retrieve your OCI CLI config information as default terraform variable. For example: fingerprint, tenancy_ocid, region, and private_key_path etc... But if you would change the target compartment, please use the -c parameter to replace default compartment OCID. 
You can use -h to review the parameter detail.

```
[~/terraform_oke_bastion_private_access] source tf_vars_setting.sh -c ocid1.tenancy.oc1..aaaaaaaakatveh(..................)c6gwlw52nvtq
TF_VAR_user_ocid=ocid1.user.oc1..aaaaaaaa6ldciwat(..................)dtwwa2guxbwvq
TF_VAR_fingerprint=1a:5b:(..................):c7:87
TF_VAR_tenancy_ocid=ocid1.tenancy.oc1..aaaaaaaakatveh(..................)c6gwlw52nvtq
TF_VAR_region=us-phoenix-1
TF_VAR_private_key_path=$HOME/.oci/oci_api_key.pem
TF_VAR_compartment_ocid=ocid1.tenancy.oc1..aaaaaaaakatveh(..................)c6gwlw52nvtq
TF_VAR_ssh_public_key=$HOME/.ssh/id_rsa.pub
```

### STEP 5

Run *terraform init* to download the lastest neccesary providers:

```
[~/terraform_oke_bastion_private_access] terraform init -upgrade
[~/terraform_oke_bastion_private_access] terraform plan
[~/terraform_oke_bastion_private_access] terraform apply
```

Apply complete! Resources: 25 added, 0 changed, 0 destroyed.

Outputs:

apisix_access_ip = "Access APISIX Gateway via http://{APISIX Gateway access IP}:9180"
apisix_dashboard_access_ip = "Access APISIX Dashboard via http://{APISIX Dashboard access IP}:9000"
container_instance_apisix_id = "ocid1.computecontainerinstance.oc1....."

(...)

You can try to access the APISIX Gateway and Dashboard by the Terraform completed output. 


