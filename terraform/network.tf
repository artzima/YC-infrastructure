resource "yandex_vpc_network" "network_terraform" {
  name = "nw_terraform"
}

resource "yandex_vpc_subnet" "subnet_a" {
  name           = "sn_terraform-a"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.network_terraform.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}

resource "yandex_vpc_subnet" "subnet_b" {
  name           = "sn_terraform-b"
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.network_terraform.id
  v4_cidr_blocks = ["192.168.11.0/24"]
}