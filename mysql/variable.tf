# =============== VARIABLES =============== #
variable "prefix" {
  type    = string
  default = "dbi"
}
 
variable "resourcegroup" {
  type = string
}
 
variable "location" {
  type    = string
  default = "westeurope"
}
 
variable "subscriptionId" {
  type = string
}
 
variable "virtualmachinename" {
  type = string
}
 
variable "virtualMachineSize" {
  type    = string
}
 
variable "adminUsername" {
  type = string
}
 
variable "adminUserPassword" {
  type = string
}
 
variable "image_ref_offer" {
  type = string
}
 
variable "image_ref_sku" {
  type = string
}
 
variable "image_ref_version" {
  type = string
}
 
variable "osDiskType" {
  type    = string
  default = "Premium_LRS"
}
 
variable "sqlVirtualMachineLocation" {
  type    = string
  default = "westeurope"
}
 
variable "sqlServerLicenseType" {
  type    = string
}
 
variable "sqlPortNumber" {
  type    = string
  default = "1433"
}
 
variable "sqlStorageDisksCount" {
  type    = string
  default = "1"
}
 
variable "diskSqlSizeGB" {
  type    = string
  default = "1024"
}
 
variable "sqlDisklType" {
  type    = string
  default = "Premium_LRS"
}
 
variable "sqlStorageWorkloadType" {
  type    = string
  default = "GENERAL"
}
 
variable "sqlAuthenticationLogin" {
  type = string
}
 
variable "sqlAuthenticationPassword" {
  type = string
}
 
variable "sqlConnectivityType" {
  type = string
}
 
variable "sqlAutopatchingDayOfWeek" {
  type    = string
  default = "Sunday"
}
 
variable "sqlAutopatchingStartHour" {
  type    = string
  default = "2"
}
 
variable "sqlAutopatchingWindowDuration" {
  type    = string
  default = "60"
}
 
variable "diagnosticsStorageAccountName" {
  type = string
}
 
variable "tag" {
  type = string
}
 
