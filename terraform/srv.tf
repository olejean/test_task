resource "yandex_compute_instance" "srv" {

  name                      = "srv"
  allow_stopping_for_update = true
  platform_id               = "standard-v1"
  zone                      = "ru-central1-a"

  resources {
    cores  = 2
    memory = 4
  }

  boot_disk {
    initialize_params {
      image_id = "fd8autg36kchufhej85b"
    }
  }

  network_interface {
    subnet_id = "${yandex_vpc_subnet.mysubnet.id}"
    nat       = true
  }

  metadata = {
    user-data = "${file("./meta.yaml")}"
  }

  scheduling_policy {
    preemptible = true
  }
}



