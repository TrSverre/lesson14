terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
}

provider "yandex" {
  token     = "y0_AgAAAAAO1GhRAATuwQAAAADwfbjiwVF7KSoART-TAOluuX1KvBwTwxk"
  cloud_id  = "b1g6o30rad2hkh87j34f"
  folder_id = "b1gum68ifoa9fbhijk7v"
  zone = "ru-central1-a"
}
  
data "yandex_compute_image" "ubuntu_image" {
  family = "ubuntu-2004-lts"
}
resource "yandex_compute_instance" "vm-1" {
  name = "terraform1"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu_image.id
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat       = true
  }

  metadata = {
    user-data = "${file("/home/user/schablon/user")}"
  }
}

resource "yandex_vpc_network" "network-1" {
  name = "network1"
}

resource "yandex_vpc_subnet" "subnet-1" {
  name           = "subnet1"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.network-1.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}