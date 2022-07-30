provider "azurerm" {
    features {
      
    }
  
}
 #resource group
resource "azurerm_resource_group" "website-on-azure" {
    name = "myresourcegroup"
    location = "Central India"

  
}

#vnet

resource "azurerm_virtual_network" "vnet" {

    address_space = ["10.0.0.0/16"]
    
    location = "Central US"
    name = "vnet"
    resource_group_name = azurerm_resource_group.website-on-azure.name

  
}
 #vnet security group 
resource "azurerm_network_security_group" "Vnet_NSG" {
    name = "Virtual_network_security_group"
    location = azurerm_resource_group.website-on-azure.location
    resource_group_name = azurerm_resource_group.website-on-azure.name
  
}

#public and private subnet

resource "azurerm_subnet" "public_subnet_1" {
    name = "public_subnet_1"
    resource_group_name = azurerm_resource_group.website-on-azure.name
    virtual_network_name = azurerm_virtual_network.vnet.name
    address_prefixes = ["10.0.1.0/24"]
    
  
}

resource "azurerm_subnet" "public_subnet_2" {
    name = "public_subnet_2"
    resource_group_name = azurerm_resource_group.website-on-azure.name
    virtual_network_name = azurerm_virtual_network.vnet.name
    address_prefixes= ["10.0.2.0/24"]
  
}

resource "azurerm_subnet" "private_subnet_1" {
    name = "private_subnet_1"
    resource_group_name = azurerm_resource_group.website-on-azure.name
    virtual_network_name = azurerm_virtual_network.vnet.name
    address_prefixes = ["10.0.3.0/24"]
  
}

resource "azurerm_subnet" "private_subnet_2" {
    name = "rivate_subnet_2"
    resource_group_name = azurerm_resource_group.website-on-azure.name
    virtual_network_name = azurerm_virtual_network.vnet.name
    address_prefixes = ["10.0.4.0/24"]
    
    
  
}




# public route table

resource "azurerm_route_table" "public_route_table" {
    name = "public_route_table"
    location = azurerm_resource_group.website-on-azure.location
    resource_group_name = azurerm_resource_group.website-on-azure.name
    tags = {
      "Name" = "public_route_table"
    }
  
}


#private route table

resource "azurerm_route_table" "private_route_table" {
    name = "private_route_table"
    location = azurerm_resource_group.website-on-azure.location
    resource_group_name = azurerm_resource_group.website-on-azure.name
    tags = {
      "Name" = "private_route_table"
    }
  
}

# route table association

resource "azurerm_subnet_route_table_association" "public_subnet_1_association" {
    subnet_id = azurerm_subnet.public_subnet_1.id
    route_table_id = azurerm_route_table.public_route_table.id
  
}

resource "azurerm_subnet_route_table_association" "public_subnet_2_association" {
    subnet_id = azurerm_subnet.public_subnet_2.id
    route_table_id = azurerm_route_table.public_route_table.id
  
}

resource "azurerm_subnet_route_table_association" "private_subnet_1_association" {
    subnet_id = azurerm_subnet.private_subnet_1.id
    route_table_id = azurerm_route_table.private_route_table.id
  
}

resource "azurerm_subnet_route_table_association" "private_subnet_2_association" {
    subnet_id = azurerm_subnet.private_subnet_2.id
    route_table_id = azurerm_route_table.private_route_table.id
  
}

#Virtual machine

resource "azurerm_network_interface" "instance1" {
    name = "instance1_NID"
    location = azurerm_resource_group.website-on-azure.location
    resource_group_name = azurerm_resource_group.website-on-azure.name
    ip_configuration {
      name = "instance1ID"
      subnet_id = azurerm_subnet.private_subnet_1.id
      private_ip_address_allocation = "Static"
    }
  
}

resource "azurerm_network_interface" "instance2" {
    name = "instance2_NID"
    location = azurerm_resource_group.website-on-azure.location
    resource_group_name = azurerm_resource_group.website-on-azure.name
    ip_configuration {
      name = "instance2ID"
      subnet_id = azurerm_subnet.private_subnet_2.id
      private_ip_address_allocation = "Static"
    }
  
}

resource "azurerm_virtual_machine" "instance1" {
    name = "instance1"
    location = azurerm_resource_group.website-on-azure.location
    resource_group_name = azurerm_resource_group.website-on-azure.name
    vm_size = "Standard_DS1_v2"
    network_interface_ids = [azurerm_network_interface.instance1.id]

    storage_image_reference {
      publisher = "canonical"
      offer = "0001-com-ubuntu-server-focal"
      sku = "20_04-lts-gen2"
      version = "1.0.1"
      
    }

    storage_os_disk {
      name = "MyDisk"
      caching = "ReadWrite"
      create_option = "FromImage"
      managed_disk_type = "Standard_LRS"
    }

    os_profile {
      computer_name = "host1"
      admin_username = "testadmin"
      admin_password = "Password12345!"
    }
    
  
}

resource "azurerm_virtual_machine" "instance2" {
    name = "instance1"
    location = azurerm_resource_group.website-on-azure.location
    resource_group_name = azurerm_resource_group.website-on-azure.name
    vm_size = "Standard_DS1_v2"
    network_interface_ids = [azurerm_network_interface.instance2.id]

    storage_image_reference {
      publisher = "canonical"
      offer = "0001-com-ubuntu-server-focal"
      sku = "20_04-lts-gen2"
      version = "1.0.1"
      
    }

    storage_os_disk {
      name = "MyDisk"
      caching = "ReadWrite"
      create_option = "FromImage"
      managed_disk_type = "Standard_LRS"
    }

    os_profile {
      computer_name = "host1"
      admin_username = "testadmin"
      admin_password = "Password12345!"
    }
    
}


#Public IP
resource "azurerm_public_ip" "public_ip" {

    name = "public-IP"
    location = azurerm_resource_group.website-on-azure.location
    resource_group_name = azurerm_resource_group.website-on-azure.name
    allocation_method = "Static"
    sku = "Standard"
    zones = ["1"]

  
}

resource "azurerm_public_ip_prefix" "publicIPprefix" {
    name = "Nat_GW_Public_I_-Prefix"
    location = azurerm_resource_group.website-on-azure.location
    resource_group_name = azurerm_resource_group.website-on-azure.name
    prefix_length = 30
    zones = ["1"]
  
}

#NAT gatewway

resource "azurerm_nat_gateway" "NatGW" {
    name = "NAT-GW"
    location = azurerm_resource_group.website-on-azure.location
    resource_group_name = azurerm_resource_group.website-on-azure.name
    sku_name = "Standard"
    idle_timeout_in_minutes = 10
    zones = ["1"]
  
}

#load balancer

resource "azurerm_lb" "load_balancer" {
    name = "Load_balancer"
    location = azurerm_resource_group.website-on-azure.location
    resource_group_name = azurerm_resource_group.website-on-azure.name
    frontend_ip_configuration {
      name = "Public_IP_Adress"
      public_ip_address_id = azurerm_public_ip.public_ip.id
    }
  
}

resource "azurerm_subnet_nat_gateway_association" "subnetNGWassoctn1" {
    subnet_id = azurerm_subnet.private_subnet_1.id
    nat_gateway_id = azurerm_nat_gateway.NatGW.id
  
}

resource "azurerm_subnet_nat_gateway_association" "subnetNGWassoctn2" {
    subnet_id = azurerm_subnet.private_subnet_2.id
    nat_gateway_id = azurerm_nat_gateway.NatGW.id
  
}








