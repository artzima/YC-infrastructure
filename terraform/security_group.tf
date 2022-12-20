resource "yandex_vpc_security_group" "alb-web-sg" {
  name        = "alb-sg"
  network_id  = yandex_vpc_network.network_terraform.id

  egress {
    protocol       = "ANY"
    description    = "any"
    v4_cidr_blocks = ["0.0.0.0/0"]
    from_port      = 0
    to_port        = 65535
  }

  ingress {
    protocol       = "TCP"
    description    = "ext-http"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 80
  }

  ingress {
    protocol       = "TCP"
    description    = "healthchecks"
    v4_cidr_blocks = ["198.18.235.0/24", "198.18.248.0/24"]
    port           = 30080
  }
}

resource "yandex_vpc_security_group" "alb-vm-sg" {
  name        = "alb-vm-sg"
  network_id  = yandex_vpc_network.network_terraform.id
 
  ingress {
    protocol          = "TCP"
    description       = "balancer"
    security_group_id = yandex_vpc_security_group.alb-web-sg.id
    port              = 80
  }
  egress {
    protocol       = "TCP"
    description    = "any"
    v4_cidr_blocks = ["192.168.10.0/24", "192.168.11.0/24"]
    from_port      = 0
    to_port        = 65535
  }
  ingress {
    protocol          = "TCP"
    description       = "node exporter"
    v4_cidr_blocks = ["192.168.10.0/24", "192.168.11.0/24"]
    port              = 9100
  }
  ingress {
    protocol          = "TCP"
    description       = "nginx log exporter"
    v4_cidr_blocks = ["192.168.10.0/24", "192.168.11.0/24"]
    port              = 4040
  }
  ingress {
    protocol       = "TCP"
    description    = "ssh"
    security_group_id = yandex_vpc_security_group.access-sg.id
    # v4_cidr_blocks = ["192.168.10.12/32"]
    port           = 22
  }
}

resource "yandex_vpc_security_group" "prometheus-sg" {
  name        = "prometheus-sg"
  network_id  = yandex_vpc_network.network_terraform.id
  # egress {
  #   protocol       = "TCP"
  #   description    = "any"
  #   v4_cidr_blocks = ["192.168.10.0/24", "192.168.11.0/24"]
  #   from_port      = 0
  #   to_port        = 65535
  # }
  ingress {
    protocol          = "TCP"
    description       = "prometheus"
    v4_cidr_blocks    = ["192.168.10.0/24", "192.168.11.0/24"]
    port              = 9090
  }
  ingress {
    protocol       = "TCP"
    description    = "ssh"
    security_group_id = yandex_vpc_security_group.access-sg.id
    # v4_cidr_blocks = ["192.168.10.12/32"]
    port           = 22
  }
}
resource "yandex_vpc_security_group" "grafana-sg" {
  name        = "grafana-sg"
  network_id  = yandex_vpc_network.network_terraform.id
  ingress {
    protocol          = "TCP"
    description       = "grafana"
    v4_cidr_blocks    = ["0.0.0.0/0"]
    port              = 3000
  }
  ingress {
    protocol       = "TCP"
    description    = "ssh"
    # security_group_id = yandex_vpc_security_group.alb-web-sg.id
    v4_cidr_blocks = ["192.168.10.12/32"]
    port           = 22
  }
}

resource "yandex_vpc_security_group" "el-sg" {
  name        = "el-sg"
  network_id  = yandex_vpc_network.network_terraform.id
  ingress {
    protocol          = "TCP"
    description       = "elasticsearh"
    v4_cidr_blocks    = ["192.168.10.0/24", "192.168.11.0/24"]
    port              = 9200
  }  
  ingress {
    protocol       = "TCP"
    description    = "ssh"
    security_group_id = yandex_vpc_security_group.access-sg.id
    # v4_cidr_blocks = ["192.168.10.12/32"]
    port           = 22
  }
}
resource "yandex_vpc_security_group" "kb-sg" {
  name        = "kb-sg"
  network_id  = yandex_vpc_network.network_terraform.id
   ingress {
    protocol          = "TCP"
    description       = "kibana"
    v4_cidr_blocks    = ["0.0.0.0/0"]
    port              = 5601
  }
  ingress {
    protocol       = "TCP"
    description    = "ssh"
    security_group_id = yandex_vpc_security_group.access-sg.id
    # v4_cidr_blocks = ["192.168.10.12/32"]
    port           = 22
  }
}
resource "yandex_vpc_security_group" "access-sg" {
  name        = "access-sg"
  network_id  = yandex_vpc_network.network_terraform.id
  ingress {
    protocol       = "TCP"
    description    = "ssh"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 22
  }
}