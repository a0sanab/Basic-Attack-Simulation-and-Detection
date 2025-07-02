variable "location" {
  description = "Azure region to deploy resources in"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "vnet_name" {
  description = "Name of the virtual network"
  type        = string
}

variable "subnet_name" {
  description = "Name of the subnet"
  type        = string
}

variable "admin_username" {
  description = "Admin username for the virtual machines"
  type        = string
}

variable "vm_size" {
  description = "Size of the virtual machines"
  type        = string
}

variable "ssh_public_key" {
  description = "SSH public key to access the virtual machines"
  type        = string
}


