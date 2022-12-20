resource "yandex_compute_image" "ubuntu-2004-lts" {
 source_family = "ubuntu-2004-lts"
}

resource "yandex_compute_image" "lemp" {
 source_family = "lemp"
}

resource "yandex_compute_instance_group" "web-ig" {
  name               = "web-ig"
  folder_id          = var.folder_id
  service_account_id = yandex_iam_service_account.ig-sa.id
  instance_template {
    name               = "web-srv-{instance.index}"
    platform_id        = "standard-v2"
    service_account_id = yandex_iam_service_account.ig-sa.id
    resources {
      core_fraction = 100
      memory        = 2
      cores         = 2
    }

    boot_disk {
      mode = "READ_WRITE"
      initialize_params {
        image_id = yandex_compute_image.lemp.id
        type     = "network-hdd"
        size     = 6
      }
    }

    network_interface {
      network_id         = yandex_vpc_network.network_terraform.id
      subnet_ids         = [yandex_vpc_subnet.subnet_a.id,yandex_vpc_subnet.subnet_b.id]
      nat                = true    
      security_group_ids = [yandex_vpc_security_group.alb-vm-sg.id,yandex_vpc_security_group.access-sg.id]

    }

    metadata = {
      user-data = "${file("./meta.txt")}"
    }
  }
  scale_policy {  
    auto_scale {
      initial_size = 2
      max_size = 3
      min_zone_size = 1
      measurement_duration = 60
      cpu_utilization_target = 60
      warmup_duration = 60
      stabilization_duration = 180
     }
  }
  allocation_policy {
    zones = ["ru-central1-a", "ru-central1-b"]
  }

  deploy_policy {
    max_creating    = 1
    max_unavailable = 1
    max_expansion   = 1
    max_deleting    = 0
  }

  application_load_balancer {
    target_group_name = "web-tg"
  }
}

resource "yandex_compute_instance_group" "monitoring-ig" {
  name               = "monitoring-ig"
  folder_id          = var.folder_id
  service_account_id = yandex_iam_service_account.ig-sa.id
  instance_template {
    name               = "monitoring-vm-{instance.index}"
    platform_id        = "standard-v2"
    service_account_id = yandex_iam_service_account.ig-sa.id
    resources {
      core_fraction = 100
      memory        = 2
      cores         = 2
    }

    boot_disk {
      mode = "READ_WRITE"
      initialize_params {
        image_id = yandex_compute_image.ubuntu-2004-lts.id
        type     = "network-hdd"
        size     = 10
      }
    }

    network_interface {
      network_id         = yandex_vpc_network.network_terraform.id
      subnet_ids         = [yandex_vpc_subnet.subnet_a.id,yandex_vpc_subnet.subnet_b.id]
      nat                = true
      security_group_ids = [yandex_vpc_security_group.alb-vm-sg.id,yandex_vpc_security_group.prometheus-sg.id,yandex_vpc_security_group.grafana-sg.id,yandex_vpc_security_group.access-sg.id]
    }

    metadata = {
      user-data = "${file("./meta.txt")}"
    }
  }

  scale_policy {  
    auto_scale {
      initial_size = 2
      max_size = 3
      min_zone_size = 1
      measurement_duration = 60
      cpu_utilization_target = 60
      warmup_duration = 60
      stabilization_duration = 180
     }
  }

  allocation_policy {
    zones = ["ru-central1-a", "ru-central1-b"]
  }

  deploy_policy {
    max_creating    = 1
    max_unavailable = 1
    max_expansion   = 1
    max_deleting    = 0
  }
}

resource "yandex_compute_instance_group" "el-ig" {
  name               = "el-ig"
  folder_id          = var.folder_id
  service_account_id = yandex_iam_service_account.ig-sa.id
  instance_template {
    name               = "log-vm-{instance.index}"
    platform_id        = "standard-v2"
    service_account_id = yandex_iam_service_account.ig-sa.id
    resources {
      core_fraction = 100
      memory        = 2
      cores         = 2
    }

    boot_disk {
      mode = "READ_WRITE"
      initialize_params {
        image_id = yandex_compute_image.ubuntu-2004-lts.id
        type     = "network-hdd"
        size     = 10
      }
    }

    network_interface {
      network_id         = yandex_vpc_network.network_terraform.id
      subnet_ids         = [yandex_vpc_subnet.subnet_a.id,yandex_vpc_subnet.subnet_b.id]
      nat                = true
      security_group_ids = [yandex_vpc_security_group.alb-vm-sg.id,yandex_vpc_security_group.el-sg.id,yandex_vpc_security_group.kb-sg.id,yandex_vpc_security_group.access-sg.id]
    }

    metadata = {
      user-data = "${file("./meta.txt")}"
    }
  }

  scale_policy {  
    auto_scale {
      initial_size = 2
      max_size = 3
      min_zone_size = 1
      measurement_duration = 60
      cpu_utilization_target = 60
      warmup_duration = 60
      stabilization_duration = 180
     }
  }

  allocation_policy {
    zones = ["ru-central1-a", "ru-central1-b"]
  }

  deploy_policy {
    max_creating    = 1
    max_unavailable = 1
    max_expansion   = 1
    max_deleting    = 0
  }
}