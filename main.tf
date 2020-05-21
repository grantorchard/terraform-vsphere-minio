provider "vsphere" {
  user           = var.vsphere_user
  password       = var.vsphere_password
  vsphere_server = var.vsphere_server

  # If you have a self-signed cert
  allow_unverified_ssl = true
}

module infoblox {
  source     = "../terraform-module-infoblox"
  hostname = var.hostname
  cidr     = var.cidr
  mac_addr = vsphere_virtual_machine.this.network_interface.0.mac_address
  vm_id    = vsphere_virtual_machine.this.id
}

module f5_ip {
  source   = "../terraform-module-infoblox"
  hostname = "minio-lb"
  cidr     = var.lb_cidr
}

module f5 {
  source = "../module-f5-virtual-server"
  virtual_server_hostname = "foo.humblelab.com"
  virtual_server_ip       = module.f5_ip.ip_address
  ip_addresses            = [module.infoblox.ip_address]
  virtual_server_port     = "9000"
}

resource vsphere_virtual_machine "this" {
  name             = var.hostname
  resource_pool_id = data.vsphere_compute_cluster.this.resource_pool_id
  datastore_id     = data.vsphere_datastore.this.id

  num_cpus = 2
  memory   = 1024
  guest_id = data.vsphere_virtual_machine.template.guest_id

  network_interface {
    network_id   = data.vsphere_network.this.id
    adapter_type = data.vsphere_virtual_machine.template.network_interface_types[0]
  }

  wait_for_guest_net_timeout = 0

  disk {
    label            = "disk0"
    size             = data.vsphere_virtual_machine.template.disks.0.size
    eagerly_scrub    = data.vsphere_virtual_machine.template.disks.0.eagerly_scrub
    thin_provisioned = data.vsphere_virtual_machine.template.disks.0.thin_provisioned
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template.id
  }

  extra_config = {
    "guestinfo.metadata"          = base64encode(data.template_file.metadata.rendered)
    "guestinfo.metadata.encoding" = "base64"
    "guestinfo.userdata"          = base64encode(data.template_file.userdata.rendered)
    "guestinfo.userdata.encoding" = "base64"
  }
}

resource vault_pki_secret_backend_cert "this" {
  backend     = "pki"
  name        = "humblelab"
  common_name = "${var.hostname}.${var.dns_suffix}"
  alt_names   = []
  ip_sans     = [module.infoblox.ip_address]
  auto_renew  = true
}

resource vault_approle_auth_backend_role_secret_id "this" {
  role_name = vault_approle_auth_backend_role.this.role_name
  wrapping_ttl  = "2h"
}

resource vault_approle_auth_backend_role "this" {
  role_name = var.hostname
  secret_id_ttl = "300"
  token_policies  = ["cert_requests"]
}