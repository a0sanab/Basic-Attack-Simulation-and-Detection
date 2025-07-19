provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name

  # This defines the entire private IP range that Azure can assign to devices (VMs for example) within this virtual network.
  address_space       = ["10.0.0.0/16"] 
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "subnet" {
  name                 = var.subnet_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name  = azurerm_resource_group.rg.name

  # Here, we carve out a chunk of that whole address space, this subnet gives us 256 addresses (10.0.1.0 to 10.0.1.255)
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_public_ip" "kali_ip" {
  name                = "kali-pubip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

# The NIC (Network Interface Card) connects the VM to the virtual network and public IP.
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
resource "azurerm_public_ip" "ubuntu_ip" {
  name                = "ubuntu-pubip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_network_interface" "ubuntu_nic" {
  name                = "ubuntu-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.ubuntu_ip.id
  }
}

# Network Security Group that allows SSH, HTTP and HTTPS
resource "azurerm_network_security_group" "vm_nsg" {
  name                = "vm-nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "Allow-SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-HTTP"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-HTTPS"
    priority                   = 1003
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

}

# Associate the NSG with Kali NIC
resource "azurerm_network_interface_security_group_association" "kali_nsg_assoc" {
  network_interface_id      = azurerm_network_interface.kali_nic.id
  network_security_group_id = azurerm_network_security_group.vm_nsg.id
}

# Associate the NSG with Ubuntu NIC
resource "azurerm_network_interface_security_group_association" "ubuntu_nsg_assoc" {
  network_interface_id      = azurerm_network_interface.ubuntu_nic.id
  network_security_group_id = azurerm_network_security_group.vm_nsg.id
}


resource "azurerm_linux_virtual_machine" "kali_vm" {
  name                            = "kali-vm"
  location                        = azurerm_resource_group.rg.location
  resource_group_name             = azurerm_resource_group.rg.name
  size                            = var.vm_size
  admin_username                  = var.admin_username
  network_interface_ids           = [azurerm_network_interface.kali_nic.id]
  disable_password_authentication = true

  admin_ssh_key {
    username   = var.admin_username
    public_key = var.ssh_public_key
  }

  source_image_reference {
    publisher = "kali-linux"
    offer     = "kali"
    sku       = "kali-2025-2"
    version   = "2025.2.0"
  }

  plan {
    name = "kali-2025-2"
    publisher = "kali-linux"
    product = "kali"
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    name                 = "kali-osdisk"
  }
}


resource "azurerm_linux_virtual_machine" "ubuntu_vm" {
  name                            = "ubuntu-vm"
  location                        = azurerm_resource_group.rg.location
  resource_group_name             = azurerm_resource_group.rg.name
  size                            = var.vm_size
  admin_username                  = var.admin_username
  disable_password_authentication = false
  admin_password                  = var.admin_password
  network_interface_ids           = [azurerm_network_interface.ubuntu_nic.id]

  admin_ssh_key {
    username   = var.admin_username
    public_key = var.ssh_public_key
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  os_disk {
    name                 = "ubuntu-osdisk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
}


