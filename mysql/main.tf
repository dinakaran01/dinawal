# =============== TEMPLATES =============== #
data "template_file" "sqlvm" {
  template = file("./Templates/sql_vm_azure_dbi.json")
}
 
# =============== RESOURCES =============== #
resource "azurerm_resource_group" "sqlvm" {
  name     = var.resourcegroup
  location = "West Europe"
}
 
resource "azurerm_virtual_network" "sqlvm" {
  name                = "${var.resourcegroup}-vnet"
  address_space       = ["172.20.0.0/24"]
  location            = azurerm_resource_group.sqlvm.location
  resource_group_name = azurerm_resource_group.sqlvm.name
}
 
resource "azurerm_subnet" "internal" {
  name                 = "default"
  resource_group_name  = var.resourcegroup
  virtual_network_name = azurerm_virtual_network.sqlvm.name
  address_prefix       = "172.20.0.0/24"
}
 
resource "azurerm_template_deployment" "sqlvm" {
  name                = "${var.prefix}-template"
  resource_group_name = azurerm_resource_group.sqlvm.name
 
  template_body = data.template_file.sqlvm.rendered
 
  #DEPLOY
 
  # =============== PARAMETERS =============== #
  parameters = {
    "location"                         = var.location                      # Location (westeurope by default)
    "networkInterfaceName"             = "${var.prefix}-${var.virtualmachinename}-interface" # Virtual machine interace name
    "enableAcceleratedNetworking"      = "true"                            # Enable Accelerating networking (always YES)
    "networkSecurityGroupName"         = "${var.prefix}-${var.virtualmachinename}-nsg" # NSG name (computed)
    "subnetName"                       = azurerm_subnet.internal.name      # Resource subnet
    "virtualNetworkId"                 = "/subscriptions/${var.subscriptionId}/resourceGroups/${var.resourcegroup}/providers/Microsoft.Network/virtualNetworks/${var.resourcegroup}-vnet"
    "publicIpAddressName"              = "${var.prefix}-${var.virtualmachinename}-ip" # Public IP Address name (computed)
    "publicIpAddressType"              = "Dynamic"                         # Public IP allocation (Dynamic, Static)
    "publicIpAddressSku"               = "Basic"                           # Public IP Address sku (None, Basic, Advanced)
    "virtualMachineName"               = "${var.prefix}-${var.virtualmachinename}" # Virtual machine name (computed)
    "virtualMachineRG"                 = var.resourcegroup                 # Resource group for resources
    "virtualMachineSize"               = var.virtualMachineSize            # Virtual machine size (Standard_DS13_v2)
    "image_ref_offer"                  = var.image_ref_offer               # SQL Server Image Offer (SQL2017-WS2016, ...)
    "image_ref_sku"                    = var.image_ref_sku                 # SQL Server Image SKU (SQLDEV, ...)
    "image_ref_version"                = var.image_ref_version             # SQL Server Image version (latest, <version number>)
    "adminUsername"                    = var.adminUsername                 # Virtual machine user name
    "adminUserPassword"                = var.adminUserPassword             # Virtual machine user password
    "osDiskType"                       = var.osDiskType                    # OS Disk type (Premium_LRS by default)
    "sqlDisklType"                     = var.sqlDisklType                  # SQL Disk type Premium_LRS by default)
    "diskSqlSizeGB"                    = var.diskSqlSizeGB                 # SQL Disk size (GB)
    "diagnosticsStorageAccountName"    = var.diagnosticsStorageAccountName # Diagnostics info - storage account name
    "diagnosticsStorageAccountId"      = "/subscriptions/${var.subscriptionId}/resourceGroups/${var.resourcegroup}/providers/Microsoft.Storage/storageAccounts/${var.diagnosticsStorageAccountName}" # Storage account must exist
    "diagnosticsStorageAccountType"    = "Standard_LRS"                    # Diagnostics info - storage account type
    "diagnosticsStorageAccountKind"    = "Storage"                         # Diagnostics info - storage type
    "sqlVirtualMachineLocation"        = var.sqlVirtualMachineLocation     # Virtual machine location
    "sqlVirtualMachineName"            = "${var.prefix}-${var.virtualmachinename}" # Virtual machine name
    "sqlServerLicenseType"             = var.sqlServerLicenseType          # SQL Server license type. - PAYG or AHUB
    "sqlConnectivityType"              = var.sqlConnectivityType           # LOCAL, PRIVATE, PUBLIC
    "sqlPortNumber"                    = var.sqlPortNumber                 # SQL listen port
    "sqlStorageDisksCount"             = var.sqlStorageDisksCount          # Nb of SQL disks to provision
    "sqlStorageWorkloadType"           = var.sqlStorageWorkloadType        # Workload type GENERAL, OLTP, DW
    "sqlStorageDisksConfigurationType" = "NEW"                             # Configuration type NEW 
    "sqlStorageStartingDeviceId"       = "2"                               # Storage starting device id => Always 2
    "sqlStorageDeploymentToken"        = "8528"                            # Deployment Token
    "sqlAutopatchingDayOfWeek"         = var.sqlAutopatchingDayOfWeek      # Day of week to apply the patch on. - Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday
    "sqlAutopatchingStartHour"         = var.sqlAutopatchingStartHour      # Hour of the day when patching is initiated. Local VM time
    "sqlAutopatchingWindowDuration"    = var.sqlAutopatchingWindowDuration # Duration of patching
    "sqlAuthenticationLogin"           = var.sqlAuthenticationLogin        # Login SQL
    "sqlAuthUpdatePassword"            = var.sqlAuthenticationPassword     # Login SQL Password
    "rServicesEnabled"                 = "false"                           # No need to enable R services
    "tag"                              = var.tag                           # Resource tags
  }
 
  deployment_mode = "Incremental"                                          # Deployment => incremental (complete is too destructive in our case) 
}
{
    "$schema": "http://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "location": {
            "type": "string"
        },
        "networkInterfaceName": {
            "type": "string"
        },
        "enableAcceleratedNetworking": {
            "type": "string"
        },
        "networkSecurityGroupName": {
            "type": "string"
        },
        "subnetName": {
            "type": "string"
        },
        "virtualNetworkId": {
            "type": "string"
        },
        "publicIpAddressName": {
            "type": "string"
        },
        "publicIpAddressType": {
            "type": "string"
        },
        "publicIpAddressSku": {
            "type": "string"
        },
        "virtualMachineName": {
            "type": "string"
        },
        "virtualMachineRG": {
            "type": "string"
        },
        "osDiskType": {
            "type": "string"
        },
        "virtualMachineSize": {
            "type": "string"
        },
        "image_ref_offer": {
            "type": "string"
        },
        "image_ref_sku": {
            "type": "string"
        },
        "image_ref_version": {
            "type": "string"
        },
        "adminUsername": {
            "type": "string"
        },
        "adminUserPassword": {
            "type": "string"
        },
        "diagnosticsStorageAccountName": {
            "type": "string"
        },
        "diagnosticsStorageAccountId": {
            "type": "string"
        },
        "diagnosticsStorageAccountType": {
            "type": "string"
        },
        "diagnosticsStorageAccountKind": {
            "type": "string"
        },
        "sqlVirtualMachineLocation": {
            "type": "string"
        },
        "sqlVirtualMachineName": {
            "type": "string"
        },
        "sqlServerLicenseType": {
            "type": "string"  
        },
        "sqlConnectivityType": {
            "type": "string"
        },
        "sqlPortNumber": {
            "type": "string"
        },
        "sqlStorageDisksCount": {
            "type": "string"
        },
        "sqlDisklType": {
            "type": "string"
        },
        "diskSqlSizeGB": {
            "type": "string"
        },
        "sqlStorageWorkloadType": {
            "type": "string"
        },
        "sqlStorageDisksConfigurationType": {
            "type": "string"
        },
        "sqlStorageStartingDeviceId": {
            "type": "string"
        },
        "sqlStorageDeploymentToken": {
            "type": "string"
        },
        "sqlAutopatchingDayOfWeek": {
            "type": "string"
        },
        "sqlAutopatchingStartHour": {
            "type": "string"
        },
        "sqlAutopatchingWindowDuration": {
            "type": "string"
        },
        "sqlAuthenticationLogin": {
            "type": "string"
        },
        "sqlAuthUpdatePassword": {
            "type": "string"
        },
        "rServicesEnabled": {
            "type": "string"
        },
        "tag": {
            "type": "string"
        }
    },
    "variables": {
        "nsgId": "[resourceId(resourceGroup().name, 'Microsoft.Network/networkSecurityGroups', parameters('networkSecurityGroupName'))]",
        "vnetId": "[parameters('virtualNetworkId')]",
        "subnetRef": "[concat(variables('vnetId'), '/subnets/', parameters('subnetName'))]",
        "dataDisks": [
            {
                    "lun": "0",
                    "createOption": "empty",
                    "caching": "ReadOnly",
                    "writeAcceleratorEnabled": false,
                    "id": null,
                    "name": null,
                    "storageAccountType": "[parameters('sqlDisklType')]",
                    "diskSizeGB": "[int(parameters('diskSqlSizeGB'))]"
            }
        ]
    },
    "resources": [
        {
            "name": "[parameters('networkInterfaceName')]",
            "type": "Microsoft.Network/networkInterfaces",
            "apiVersion": "2018-10-01",
            "location": "[parameters('location')]",
            "dependsOn": [
                "[concat('Microsoft.Network/networkSecurityGroups/', parameters('networkSecurityGroupName'))]",
                "[concat('Microsoft.Network/publicIpAddresses/', parameters('publicIpAddressName'))]"
            ],
            "properties": {
                "ipConfigurations": [
                    {
                        "name": "ipconfig1",
                        "properties": {
                            "subnet": {
                                "id": "[variables('subnetRef')]"
                            },
                            "privateIPAllocationMethod": "Dynamic",
                            "publicIpAddress": {
                                "id": "[resourceId(resourceGroup().name, 'Microsoft.Network/publicIpAddresses', parameters('publicIpAddressName'))]"
                            }
                        }
                    }
                ],
                "enableAcceleratedNetworking": "[parameters('enableAcceleratedNetworking')]",
                "networkSecurityGroup": {
                    "id": "[variables('nsgId')]"
                }
            },
            "tags": {
                "Environment": "[parameters('tag')]"
            }
        },
        {
            "name": "[parameters('networkSecurityGroupName')]",
            "type": "Microsoft.Network/networkSecurityGroups",
            "apiVersion": "2019-02-01",
            "location": "[parameters('location')]",
            "properties": {
                "securityRules": [
                    {
                        "name": "RDP",
                        "properties": {
                            "priority": 300,
                            "protocol": "TCP",
                            "access": "Allow",
                            "direction": "Inbound",
                            "sourceAddressPrefix": "*",
                            "sourcePortRange": "*",
                            "destinationAddressPrefix": "*",
                            "destinationPortRange": "3389"
                        }
                    }
                ]
            },
            "tags": {
                "Environment": "[parameters('tag')]"
            }
        },
        {
            "name": "[parameters('publicIpAddressName')]",
            "type": "Microsoft.Network/publicIpAddresses",
            "apiVersion": "2019-02-01",
            "location": "[parameters('location')]",
            "properties": {
                "publicIpAllocationMethod": "[parameters('publicIpAddressType')]"
            },
            "sku": {
                "name": "[parameters('publicIpAddressSku')]"
            },
            "tags": {
                "Environment": "[parameters('tag')]"
            }
        },
        {
            "name": "[parameters('virtualMachineName')]",
            "type": "Microsoft.Compute/virtualMachines",
            "apiVersion": "2018-10-01",
            "location": "[parameters('location')]",
            "dependsOn": [
                "[concat('Microsoft.Network/networkInterfaces/', parameters('networkInterfaceName'))]",
                "[concat('Microsoft.Storage/storageAccounts/', parameters('diagnosticsStorageAccountName'))]"
            ],
            "properties": {
                "hardwareProfile": {
                    "vmSize": "[parameters('virtualMachineSize')]"
                },
                "storageProfile": {
                    "osDisk": {
                        "createOption": "fromImage",
                        "managedDisk": {
                            "storageAccountType": "[parameters('osDiskType')]"
                        }
                    },
                    "imageReference": {
                        "publisher": "MicrosoftSQLServer",
                        "offer": "[parameters('image_ref_offer')]",
                        "sku": "[parameters('image_ref_sku')]",
                        "version": "[parameters('image_ref_version')]"
                    },
                    "copy": [
                        {
                            "name": "dataDisks",
                            "count": "[length(variables('dataDisks'))]",
                            "input": {
                                "lun": "[variables('dataDisks')[copyIndex('dataDisks')].lun]",
                                "createOption": "[variables('dataDisks')[copyIndex('dataDisks')].createOption]",
                                "caching": "[variables('dataDisks')[copyIndex('dataDisks')].caching]",
                                "writeAcceleratorEnabled": "[variables('dataDisks')[copyIndex('dataDisks')].writeAcceleratorEnabled]",
                                "diskSizeGB": "[variables('dataDisks')[copyIndex('dataDisks')].diskSizeGB]",
                                "managedDisk": {
                                    "id": "[coalesce(variables('dataDisks')[copyIndex('dataDisks')].id, if(equals(variables('dataDisks')[copyIndex('dataDisks')].name, json('null')), json('null'), resourceId('Microsoft.Compute/disks', variables('dataDisks')[copyIndex('dataDisks')].name)))]",
                                    "storageAccountType": "[variables('dataDisks')[copyIndex('dataDisks')].storageAccountType]"
                                }
                            }
                        }
                    ]
                },
                "networkProfile": {
                    "networkInterfaces": [
                        {
                            "id": "[resourceId('Microsoft.Network/networkInterfaces', parameters('networkInterfaceName'))]"
                        }
                    ]
                },
                "osProfile": {
                    "computerName": "[parameters('virtualMachineName')]",
                    "adminUsername": "[parameters('adminUsername')]",
                    "adminPassword": "[parameters('adminUserPassword')]",
                    "windowsConfiguration": {
                        "enableAutomaticUpdates": true,
                        "provisionVmAgent": true
                    }
                },
                "licenseType": "Windows_Server",
                "diagnosticsProfile": {
                    "bootDiagnostics": {
                        "enabled": true,
                        "storageUri": "[concat('https://', parameters('diagnosticsStorageAccountName'), '.blob.core.windows.net/')]"
                    }
                }
            },
            "tags": {
                "Environment": "[parameters('tag')]"
            }
        },
        {
            "name": "[parameters('diagnosticsStorageAccountName')]",
            "type": "Microsoft.Storage/storageAccounts",
            "apiVersion": "2018-07-01",
            "location": "[parameters('location')]",
            "properties": {},
            "sku": {
                "name": "[parameters('diagnosticsStorageAccountType')]"
            },
            "tags": {
                "Environment": "[parameters('tag')]"
            }
        },
        {
            "name": "[parameters('sqlVirtualMachineName')]",
            "type": "Microsoft.SqlVirtualMachine/SqlVirtualMachines",
            "apiVersion": "2017-03-01-preview",
            "location": "[parameters('sqlVirtualMachineLocation')]",
            "properties": {
                "virtualMachineResourceId": "[resourceId('Microsoft.Compute/virtualMachines', parameters('sqlVirtualMachineName'))]",
                "sqlServerLicenseType": "[parameters('sqlServerLicenseType')]",
                "AutoPatchingSettings": {
                    "Enable": true,
                    "DayOfWeek": "[parameters('sqlAutopatchingDayOfWeek')]",
                    "MaintenanceWindowStartingHour": "[parameters('sqlAutopatchingStartHour')]",
                    "MaintenanceWindowDuration": "[parameters('sqlAutopatchingWindowDuration')]"
                },
                "KeyVaultCredentialSettings": {
                    "Enable": false,
                    "CredentialName": ""
                },
                "ServerConfigurationsManagementSettings": {
                    "SQLConnectivityUpdateSettings": {
                        "ConnectivityType": "[parameters('sqlConnectivityType')]",
                        "Port": "[parameters('sqlPortNumber')]",
                        "SQLAuthUpdateUserName": "[parameters('sqlAuthenticationLogin')]",
                        "SQLAuthUpdatePassword": "[parameters('sqlAuthUpdatePassword')]"
                    },
                    "SQLWorkloadTypeUpdateSettings": {
                        "SQLWorkloadType": "[parameters('sqlStorageWorkloadType')]"
                    },
                    "SQLStorageUpdateSettings": {
                        "DiskCount": "[parameters('sqlStorageDisksCount')]",
                        "DiskConfigurationType": "[parameters('sqlStorageDisksConfigurationType')]",
                        "StartingDeviceID": "[parameters('sqlStorageStartingDeviceId')]"
                    },
                    "AdditionalFeaturesServerConfigurations": {
                        "IsRServicesEnabled": "[parameters('rServicesEnabled')]"
                    }
                }
            },
            "dependsOn": [
                "[resourceId('Microsoft.Compute/virtualMachines', parameters('sqlVirtualMachineName'))]"
            ],
            "tags": {
                "Environment": "[parameters('tag')]"
            }
        }
    ],
    "outputs": {
        "adminUsername": {
            "type": "string",
            "value": "[parameters('adminUsername')]"
        }
    }
}
