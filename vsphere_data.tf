data vsphere_datacenter "this" {
  name = var.datacenter_name
}

data vsphere_compute_cluster "this" {
  name          = var.cluster_name
  datacenter_id = data.vsphere_datacenter.this.id
}

data vsphere_datastore "this" {
  name          = var.datastore_name
  datacenter_id = data.vsphere_datacenter.this.id
}

/*
data vsphere_datastore_cluster "this" {
  name          = var.datastore_name
  datacenter_id = data.vsphere_datacenter.this.id
}
*/

data vsphere_distributed_virtual_switch "this" {
  name          = var.dvs_name
  datacenter_id = data.vsphere_datacenter.datacenter.id
}


data vsphere_network "this" {
  name          = var.network_name
  datacenter_id = data.vsphere_datacenter.this.id
}

data vsphere_virtual_machine "template" {
  name          = var.template_name
  datacenter_id = data.vsphere_datacenter.this.id
}