terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
}

provider "yandex" {
  service_account_key_file = "key.json"
  cloud_id  = "b1g2n8g0k698p8h8pfg2"
  folder_id = "b1gqbh9n63qaria5u2tj"
  zone      = "ru-central1-a"
}

# Используем подсеть с CIDR 192.168.10.0/24
data "yandex_vpc_subnet" "k8s_subnet" {
  name = "shahat112-k8s-subnet"
}

# Кластер Kubernetes с АЛЬТЕРНАТИВНЫМИ CIDR диапазонами
resource "yandex_kubernetes_cluster" "cluster" {
  name               = "shahat112-k8s-cluster"
  network_id         = "enpbcbp5ccl8ah8gmrfc"
  
  # ВАЖНО: Используем НЕ 10.x.x.x диапазоны чтобы избежать конфликтов
  cluster_ipv4_range = "172.20.0.0/16"    # Альтернатива для pod сетей
  service_ipv4_range = "172.21.0.0/16"    # Альтернатива для service сетей
  
  master {
    zonal {
      zone      = "ru-central1-a"
      subnet_id = data.yandex_vpc_subnet.k8s_subnet.id
    }
    
    public_ip = true
    version   = "1.30"
  }
  
  service_account_id      = "ajedij4cmvi0pfi8fu8u"
  node_service_account_id = "ajedij4cmvi0pfi8fu8u"
  
  # Увеличиваем timeout для надежности
  timeouts {
    create = "45m"
    update = "45m"
    delete = "45m"
  }
}

# Группа нод
resource "yandex_kubernetes_node_group" "nodes" {
  cluster_id = yandex_kubernetes_cluster.cluster.id
  name       = "shahat112-nodes"
  
  instance_template {
    platform_id = "standard-v2"
    
    resources {
      memory = 4
      cores  = 2
    }
    
    boot_disk {
      type = "network-hdd"
      size = 30
    }
    
    network_interface {
      subnet_ids = [data.yandex_vpc_subnet.k8s_subnet.id]
      nat        = true
    }
    
    scheduling_policy {
      preemptible = true
    }
  }
  
  scale_policy {
    fixed_scale {
      size = 2
    }
  }
  
  # Увеличиваем timeout
  timeouts {
    create = "30m"
    update = "30m"
    delete = "30m"
  }
  
  depends_on = [yandex_kubernetes_cluster.cluster]
}

output "cluster_id" {
  value = yandex_kubernetes_cluster.cluster.id
}

output "cluster_endpoint" {
  value = yandex_kubernetes_cluster.cluster.master[0].external_v4_endpoint
}

output "subnet_id" {
  value = data.yandex_vpc_subnet.k8s_subnet.id
}

output "subnet_cidr" {
  value = data.yandex_vpc_subnet.k8s_subnet.v4_cidr_blocks[0]
}

output "pod_cidr" {
  value = "172.20.0.0/16"
}

output "service_cidr" {
  value = "172.21.0.0/16"
}
