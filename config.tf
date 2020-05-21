data template_file "userdata" {
  template = file("${path.module}/templates/userdata.yaml")

  vars = {
    username       = var.username
    ssh_public_key = file(var.ssh_public_key)
    minio_conf     = base64encode(data.template_file.minio_conf.rendered)
    minio_service  = base64encode(file("${path.module}/files/minio.service"))
    certificate    = base64encode(vault_pki_secret_backend_cert.this.certificate)
    private_key    = base64encode(vault_pki_secret_backend_cert.this.private_key)
    vault_roleid   = vault_approle_auth_backend_role.this.role_id
    wrapping_token = vault_approle_auth_backend_role_secret_id.this.wrapping_token
    vault_conf     = base64encode(data.template_file.vault_conf.rendered)
    vault_service  = base64encode(file("${path.module}/files/vault.service"))
  }
}

data template_file "metadata" {
  template = file("${path.module}/templates/metadata.yaml")
  vars = {
    dhcp               = var.dhcp
    hostname           = var.hostname
    ip_address         = module.infoblox.ip_address
    netmask            = split("/", var.cidr)[1]
    nameservers        = jsonencode(var.nameservers)
    gateway            = cidrhost(var.cidr, 1)
  }
}

data template_file "minio_conf" {
  template = file("${path.module}/templates/minio")
  vars = {
    ip_address = module.infoblox.ip_address
  }
}

data template_file "vault_conf" {
  template = file("${path.module}/templates/vault.conf")
  vars = {
    vault_addr          = var.vault_addr
    public_cert         = vault_pki_secret_backend_cert.this.certificate
    cert_file_location  = var.cert_file_location
    private_key         = vault_pki_secret_backend_cert.this.private_key
    key_file_location   = var.key_file_location
    vault_secretid_path = "${vault_approle_auth_backend_role.this.id}/secret-id"
    response_wrapping_path = "auth/approle/role/minio/secret-id"
    template_command    = var.template_command #systemctl restart minio
    common_name         = "${var.hostname}.${var.dns_suffix}"
  }
}