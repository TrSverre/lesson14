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
    disk_id =  yandex_compute_disk.default
  }

  network_interface {
    subnet_id = "e9bohr7qvj70b390umrp"
    nat       = true
  }

  metadata = {
    user-data = "${file("./user.yml")}"
  }

  allow_stopping_for_update {
      true
  }

}

resource "yandex_compute_disk" "default" {
  type     = "network-hdd"
  zone     = "ru-central1-a"
  image_id = data.yandex_compute_image.ubuntu_image.id
  size = 15
}