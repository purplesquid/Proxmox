variable "iso_file" {
  type    = string
  default = "nfs:iso/debian-11.5.0-amd64-netinst.iso"
}

variable "cloudinit_storage_pool" {
  type    = string
  default = "nfs"
}

variable "cores" {
  type    = string
  default = "1"
}

variable "disk_format" {
  type    = string
  default = "qcow2"
}

variable "disk_size" {
  type    = string
  default = "16G"
}

variable "disk_storage_pool" {
  type    = string
  default = "nfs"
}

variable "disk_storage_pool_type" {
  type    = string
  default = "nfs"
}

variable "memory" {
  type    = string
  default = "1024"
}

variable "network_vlan" {
  type    = string
  default = "20"
}

variable "proxmox_api_password" {
  type      = string
  sensitive = true
}

variable "proxmox_api_user" {
  type = string
}

variable "proxmox_host" {
  type = string
}

variable "proxmox_node" {
  type = string
}

source "proxmox-iso" "debian11" {
  proxmox_url              = "https://${var.proxmox_host}/api2/json"
  insecure_skip_tls_verify = true
  username                 = var.proxmox_api_user
  token                    = var.proxmox_api_password

  node                 = var.proxmox_node
  network_adapters {
    bridge   = "vmbr1"
    firewall = true
    model    = "virtio"
    vlan_tag = var.network_vlan
  }
  disks {
    disk_size         = var.disk_size
    format            = var.disk_format
    io_thread         = true
    storage_pool      = var.disk_storage_pool
    storage_pool_type = var.disk_storage_pool_type
    type              = "scsi"
  }
  scsi_controller = "virtio-scsi-single"

  iso_file       = var.iso_file
  http_directory = "./"
  boot_wait      = "10s"
  boot_command   = ["<esc><wait>auto url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed.cfg<enter>"]
  unmount_iso    = true

  cloud_init              = true
  cloud_init_storage_pool = var.cloudinit_storage_pool

  vm_name  = "debian"
  memory   = var.memory
  cores    = var.cores
  sockets  = "1"

  ssh_username = "root"
  ssh_password = ""
  ssh_timeout = "20m"
}

build {
  sources = ["source.proxmox-iso.debian11"]

  provisioner "file" {
    destination = "/etc/cloud/cloud.cfg"
    source      = "cloud.cfg"
  }
}