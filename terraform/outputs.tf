output "kali_public_ip" {
  value = azurerm_public_ip.kali_ip.ip_address
}

output "ubuntu_public_ip" {
  value = azurerm_public_ip.ubuntu_ip.ip_address
}
