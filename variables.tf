# ---------------------------------------------------------------------------------------------------------------------
# VMWARE PROVIDER VARIABLES
# These are used to connect to vCenter.
# ---------------------------------------------------------------------------------------------------------------------

variable "vsphere_server" {
  type = string
}

variable "vsphere_user" {
  type = string
}

variable "vsphere_password" {
  type = string
}

# ---------------------------------------------------------------------------------------------------------------------
# VMWARE DATA SOURCE VARIABLES
# These are used to discover unmanaged resources used during deployment.
# ---------------------------------------------------------------------------------------------------------------------

variable datacenter_name {
  type        = string
  description = "The name of the vSphere Datacenter into which resources will be created."
}

variable cluster_name {
  type        = string
  description = "The vSphere Cluster into which resources will be created."
}

variable datastore_name {
  type        = string
  description = "The vSphere Datastore into which resources will be created."
}

variable datastore_cluster_name {
  type    = string
  default = ""
}

variable network_name {
  type    = string
  default = "Common"
}

variable template_name {
  type = string
}

# ---------------------------------------------------------------------------------------------------------------------
# VMWARE RESOURCE VARIABLES
# Variables used during the creation of resources in vSphere.
# ---------------------------------------------------------------------------------------------------------------------

variable machine_count {
  type    = number
  default = 3
}

variable hostname {
  type        = string
  default     = ""
  description = "A prefix for the virtual machine name."
}

variable infoblox_tenant_id {
  type    = string
  default = "not_applicable"
}

variable cidr {
  type    = string
  default = "10.0.0.0/24"
}

variable network_view_name {
  type    = string
  default = "default"
}

variable dns_suffix {
  type    = string
  default = "humblelab.com"
}

variable dns_view {
  type    = string
  default = "default"
}

# ---------------------------------------------------------------------------------------------------------------------
# CLOUD INIT VARIABLES
# Variables used for generation of metadata and userdata.
# ---------------------------------------------------------------------------------------------------------------------


variable username {
  type = string
}

variable ssh_public_key {
  type        = string
  description = "Location of SSH public key."
}

variable packages {
  type    = list
  default = []
}

variable dhcp {
  type    = string
  default = "true"
}


variable gateway {
  type    = string
  default = ""
}

variable nameservers {
  type    = list
  default = []
}

# ---------------------------------------------------------------------------------------------------------------------
# VAULT VARIABLES
# Variables used for Vault configuration.
# ---------------------------------------------------------------------------------------------------------------------

variable vault_addr {
  type = string
  default = "http://vault.humblelab.com:8200"
}

variable template_command {
  type = string
  default = ""
}

variable cert_file_location {
  type = string
  default = "/etc/minio.d/certs/public.crt"
}

variable key_file_location {
  type = string
  default = "/etc/minio.d/certs/private.key"
}

variable lb_cidr {
  type = string
  default = "192.168.1.0/24"
}