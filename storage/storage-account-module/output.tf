output "sto_location" {
    value = "${azurerm_storage_account.storageaccount.sto_location}"
}

output "sto_name" {
    value = "${azurerm_storage_account.storageaccount.sto_name}"
}

output "tier" {
    value = "${azurerm_storage_account.storageaccount.tier}"
}

output "replication_type" {
    value = "${azurerm_storage_account.storageaccount.replication_type}"
}