provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "cyber-rg"
  location = "East US"
}

resource "azurerm_virtual_network" "vnet" {
  name                = "cyber-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "subnet" {
  name                = "cyber-subnet"
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name = azurerm_resource_group.rg.name
  address_prefixes    = ["10.0.1.0/24"]
}

resource "azurerm_public_ip" "kali_ip" {
  name                = "kali-pubip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "kali_nic" {
  name                = "kali-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.kali_ip.id
  }
}

resource "azurerm_linux_virtual_machine" "kali_vm" {
  name                            = "kali-vm"
  location                        = azurerm_resource_group.rg.location
  resource_group_name             = azurerm_resource_group.rg.name
  size                            = "Standard_B2s"
  admin_username                  = "azureuser"
  network_interface_ids           = [azurerm_network_interface.kali_nic.id]
  disable_password_authentication = true

  admin_ssh_key {
    username   = "azureuser"
    public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC8ubfdN4SedrbPSQQwT59pln8oP5z8K0q7HfAHMh8/ReTT1ff65Ay6rO4wDaOVVB9Y1FOeSg9QlLv3Pyya/e0bymZfdyOffeWnuNyaFFOIT7VN7A8nXBleKH9Te/v7JwtIN9WATzNowKYg6xYE1q8BDGFsws57sd97Mo9/xB2QLokO3N970fIKuSpuvciPuUqgBkkUGVYMibz1+Mo2C/OgyjlvXUerJu+Oou/IPhX6yiNYBzDZCXdo0SoINfQRtpU+J/l2vdsGctzUWgJanomIxViGUIV2lZfAt06mfLgahxlgmBqy0zuexricP0KNtDm12CFJo36m7/vuJVV01aQ7/pwGK/+WC7Br/Z99J6zq8d7CEW0ZfIHDjxwICfWgg5xObHvlfvLXlIxGhzttS2IEb8o28HQy5FOf7WQusPQ2YoHMOAnNDi1WpXV9MNSAHRU6IOpDXyfD5tdJ6/2lmV6VDgnDme0gb+ggX52ocH1/HvCmetJDib2u8gn8UJPEXJbT8o4suVeZztZqY4uctd9y8K5XxwqakfJ7DDc2Oqp/PWzeN/O3LyRhRCwxhOPYkxniC+CXallHrf46CoIe2Qs5nxSY0jgn7TeMb5DkNU57F6zdBnL+NRdQlOBlGd/8oNbOybOd9HP18VYn+Bbrt7TWvCLQUpW141yvquqvA+ueCQ== a0san@DESKTOP-67NGRMV"
  }

  source_image_reference {
    publisher = "kali-linux"
    offer     = "kali"
    sku       = "kali"
    version   = "latest"
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    name                 = "kali-osdisk"
  }
}

resource "azurerm_linux_virtual_machine" "ubuntu_vm" {
  name = "ubuntu-vm"
  location = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  size = "Standard_B2s"
  admin_username = "azureuser"
  disable_password_authentication = true
  network_interface_ids = [azurerm_network_interface.ubuntu_nic.id]

  admin_ssh_key {
  username = "azureuser"
   public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC8ubfdN4SedrbPSQQwT59pln8oP5z8K0q7HfAHMh8/ReTT1ff65Ay6rO4wDaOVVB9Y1FOeSg9QlLv3Pyya/e0bymZfdyOffeWnuNyaFFOIT7VN7A8nXBleKH9Te/v7JwtIN9WATzNowKYg6xYE1q8BDGFsws57sd97Mo9/xB2QLokO3N970fIKuSpuvciPuUqgBkkUGVYMibz1+Mo2C/OgyjlvXUerJu+Oou/IPhX6yiNYBzDZCXdo0SoINfQRtpU+J/l2vdsGctzUWgJanomIxViGUIV2lZfAt06mfLgahxlgmBqy0zuexricP0KNtDm12CFJo36m7/vuJVV01aQ7/pwGK/+WC7Br/Z99J6zq8d7CEW0ZfIHDjxwICfWgg5xObHvlfvLXlIxGhzttS2IEb8o28HQy5FOf7WQusPQ2YoHMOAnNDi1WpXV9MNSAHRU6IOpDXyfD5tdJ6/2lmV6VDgnDme0gb+ggX52ocH1/HvCmetJDib2u8gn8UJPEXJbT8o4suVeZztZqY4uctd9y8K5XxwqakfJ7DDc2Oqp/PWzeN/O3LyRhRCwxhOPYkxniC+CXallHrf46CoIe2Qs5nxSY0jgn7TeMb5DkNU57F6zdBnL+NRdQlOBlGd/8oNbOybOd9HP18VYn+Bbrt7TWvCLQUpW141yvquqvA+ueCQ== a0san@DESKTOP-67NGRMV"
  }

  source_image_reference {
  publisher = "Canonical"
  offer = "0001-com-ubuntu-server-jammy"
  sku = "22_04-lts-gen2"
  version = "latest"
  }

  os_disk {
  name = "ubuntu-osdisk"
  caching = "ReadWrite"
  storage_account_type = "Standard_LRS"
  }
}
