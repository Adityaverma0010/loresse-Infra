resource "azurerm_communication_service" "comm" {
  for_each            = var.services
  name                = each.value
  resource_group_name = var.resource_group_name
  data_location       = "Europe"
}
