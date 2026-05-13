variable "sa_key_file" {
  description = "Путь к JSON-ключу сервисного аккаунта"
  type        = string
  sensitive   = true
}

variable "yc_cloud_id" {
  description = "ID облака Yandex Cloud"
  type        = string
}

variable "yc_folder_id" {
  description = "ID каталога"
  type        = string
}

variable "yc_zone" {
  description = "Зона доступности"
  type        = string
  default     = "ru-central1-a"
}

variable "public_subnet_cidr" {
  description = "CIDR публичной подсети"
  type        = string
  default     = "192.168.10.0/24"
}

variable "private_subnet_cidr" {
  description = "CIDR приватной подсети"
  type        = string
  default     = "192.168.20.0/24"
}

variable "nat_internal_ip" {
  description = "Внутренний IP NAT-инстанса"
  type        = string
  default     = "192.168.10.254"
}

variable "nat_image_id" {
  description = "ID образа для NAT-инстанса"
  type        = string
  default     = "fd80mrhj8fl2oe87o4e1"
}

variable "vm_image_id" {
  description = "ID образа для ВМ"
  type        = string
  default     = "fd80mrhj8fl2oe87o4e1"
}

variable "ssh_public_key" {
  description = "Публичный SSH-ключ"
  type        = string
}