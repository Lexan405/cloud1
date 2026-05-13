resource "yandex_vpc_network" "main" {
  name = "network-hw"
}

resource "yandex_vpc_subnet" "public" {
  name           = "subnet-public"
  network_id     = yandex_vpc_network.main.id
  zone           = var.yc_zone
  v4_cidr_blocks = [var.public_subnet_cidr]
}

resource "yandex_vpc_subnet" "private" {
  name           = "subnet-private"
  network_id     = yandex_vpc_network.main.id
  zone           = var.yc_zone
  v4_cidr_blocks = [var.private_subnet_cidr]
  route_table_id = yandex_vpc_route_table.private.id
}

resource "yandex_vpc_route_table" "private" {
  name       = "rt-private"
  network_id = yandex_vpc_network.main.id

  static_route {
    destination_prefix = "0.0.0.0/0"
    next_hop_address   = var.nat_internal_ip
  }
}

resource "yandex_compute_instance" "nat" {
  name        = "nat-instance"
  platform_id = "standard-v3"
  zone        = var.yc_zone

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = var.nat_image_id
    }
  }

  network_interface {
    subnet_id  = yandex_vpc_subnet.public.id
    ip_address = var.nat_internal_ip
    nat        = true
  }

  metadata = {
    user-data = <<-EOF
    #cloud-config
    runcmd:
      - sysctl -w net.ipv4.ip_forward=1
      - iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
    EOF
  }
}

# ПАУЗА 3 МИНУТЫ между созданием публичных IP
resource "time_sleep" "wait_for_nat" {
  create_duration = "180s"
  depends_on      = [yandex_compute_instance.nat]
}

resource "yandex_compute_instance" "public_vm" {
  name        = "vm-public"
  platform_id = "standard-v3"
  zone        = var.yc_zone

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = var.vm_image_id
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.public.id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${var.ssh_public_key}"
  }

  depends_on = [time_sleep.wait_for_nat]
}

resource "yandex_compute_instance" "private_vm" {
  name        = "vm-private"
  platform_id = "standard-v3"
  zone        = var.yc_zone

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = var.vm_image_id
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.private.id
    nat       = false
  }

  metadata = {
    ssh-keys = "ubuntu:${var.ssh_public_key}"
  }
}