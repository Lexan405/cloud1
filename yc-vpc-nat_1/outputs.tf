output "public_vm_external_ip" {
  description = "Публичный IP-адрес vm-public"
  value       = yandex_compute_instance.public_vm.network_interface[0].nat_ip_address
}

output "private_vm_internal_ip" {
  description = "Внутренний IP-адрес vm-private"
  value       = yandex_compute_instance.private_vm.network_interface[0].ip_address
}

output "nat_internal_ip" {
  description = "Внутренний IP-адрес NAT-инстанса"
  value       = yandex_compute_instance.nat.network_interface[0].ip_address
}