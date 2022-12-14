variable "hcloud-token" {
    type = string
    default = "${env("HCLOUD_TOKEN")}"
    sensitive = true
}

variable "name" {
}

locals {
    build-id = "${uuidv4()}"
    build-labels = {
        "name" = var.name
        "packer.io.build.time" = "{{ timestamp }}"
    }
}

source "hcloud" "base" {
    server_type = "cx21"
    image = "debian-11"
    rescue = "linux64"
    location = "nbg1"
    snapshot_name = var.name
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
