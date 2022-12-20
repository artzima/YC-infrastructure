resource "yandex_alb_backend_group" "web-bg" {
  name                     = "web-bg"
  
  http_backend {
    name                   = "web-http-backend"
    port                   = 80
    target_group_ids       = [yandex_compute_instance_group.web-ig.application_load_balancer.0.target_group_id]

    healthcheck {
      timeout              = "10s"
      interval             = "60s"
      healthcheck_port   = 80
      http_healthcheck {
        path               = "/"
      }
    }
  }
}


resource "yandex_alb_http_router" "alb-router" {
  name   = "alb-router"
}


resource "yandex_alb_virtual_host" "alb-host" {
  name           = "alb-host"
  http_router_id = yandex_alb_http_router.alb-router.id
  route {
    name = "route-1"
    http_route {
      http_route_action {
        backend_group_id = yandex_alb_backend_group.web-bg.id
        timeout = "3s"
      }
    }
  }
}

resource "yandex_alb_load_balancer" "alb-main" {
  name               = "alb-main"
  network_id         = yandex_vpc_network.network_terraform.id
  security_group_ids = [yandex_vpc_security_group.alb-web-sg.id]

  allocation_policy {
    location {
      zone_id   = "ru-central1-a"
      subnet_id = yandex_vpc_subnet.subnet_a.id
    }

    location {
      zone_id   = "ru-central1-b"
      subnet_id = yandex_vpc_subnet.subnet_b.id
    }
  }

  listener {
    name = "alb-listener"
    endpoint {
      address {
        external_ipv4_address {
        }
      }
      ports = [ 80 ]
    }
    http {
      handler {
        http_router_id = yandex_alb_http_router.alb-router.id
      }
    }
  }
}