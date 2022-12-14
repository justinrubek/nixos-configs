variable "hcloud-token" {
    type = string
    default = "${env("HCLOUD_TOKEN")}"
    sensitive = true
}

locals {
    build-id = "${uuidv4()}"
    build-labels = {
        "name" = local.name
        "packer.io.build.time" = "{{ timestamp }}"
    }
    name = "hetzner-base-nixos-{{ timestamp }}"
}

source "hcloud" "base" {
    server_type = "cx21"
    image = "debian-11"
    rescue = "linux64"
    location = "nbg1"
    snapshot_name = "hetzner-base-nixos-{{ timestamp }}"
    snapshot_labels = local.build-labels
    ssh_username = "root"
    token = var.hcloud-token
}

build {
    sources = ["source.hcloud.base"]

    provisioner "shell" {
        script = "bootstrap-1.sh"
    }

    provisioner "shell" {
        script = "bootstrap-2.sh"
    }

    post-processor "manifest" {
        custom_data = local.build-labels
    }
}
