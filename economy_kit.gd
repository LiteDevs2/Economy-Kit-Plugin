extends Node

const CurrencyManagerScript = preload("res://addons/economykit/core/currency_manager.gd")
const ShopManagerScript = preload("res://addons/economykit/core/shop_manager.gd")
const TransactionManagerScript = preload("res://addons/economykit/core/transaction_manager.gd")
const SaveManagerScript = preload("res://addons/economykit/core/save_manager.gd")

signal balance_changed(currency_id: String, old_value: int, new_value: int)
signal currency_created(currency_id: String)
signal transaction_created(transaction: Dictionary)
signal purchase_completed(item_id: String, currency_id: String, price: int)
signal data_saved()
signal data_loaded()

const SAVE_VERSION := 1

var currency: Node
var shop: Node
var transactions: Node
var save_manager: Node

func _ready() -> void:
	currency = CurrencyManagerScript.new()
	currency.name = "CurrencyManager"
	add_child(currency)
	
	shop = ShopManagerScript.new()
	shop.name = "ShopManager"
	add_child(shop)
	
	transactions = TransactionManagerScript.new()
	transactions.name = "TransactionManager"
	add_child(transactions)
	
	save_manager = SaveManagerScript.new()
	save_manager.name = "SaveManager"
	add_child(save_manager)
	
	currency.balance_changed.connect(_on_balance_changed)
	currency.currency_created.connect(_on_currency_created)
	transactions.transaction_created.connect(_on_transaction_created)
	shop.purchase_completed.connect(_on_purchase_completed)
	
	print("EconomyKit initialized")


func _on_balance_changed(currency_id: String, old_value: int, new_value: int) -> void:
	balance_changed.emit(currency_id, old_value, new_value)


func _on_currency_created(currency_id: String) -> void:
	currency_created.emit(currency_id)


func _on_transaction_created(transaction: Dictionary) -> void:
	transaction_created.emit(transaction)


func _on_purchase_completed(item_id: String, currency_id: String, price: int) -> void:
	purchase_completed.emit(item_id, currency_id, price)


func create_currency(id: String, display_name: String, symbol: String = "") -> bool:
	return currency.create_currency(id, display_name, symbol)


func get_transactions(limit: int = 50) -> Array:
	return transactions.get_transactions(limit)


func save() -> bool:
	var data := {
		"version": SAVE_VERSION,
		"currencies": currency.serialize(),
		"shop_items": shop.serialize(),
		"transactions": transactions.serialize()
	}
	
	var success = save_manager.save_data(data)
	if success:
		data_saved.emit()
	return success


func load_data() -> bool:
	var data = save_manager.load_data()
	if data.is_empty():
		return false
	
	if data.has("currencies"):
		currency.deserialize(data["currencies"])
	
	if data.has("shop_items"):
		shop.deserialize(data["shop_items"])
	
	if data.has("transactions"):
		transactions.deserialize(data["transactions"])
	
	data_loaded.emit()
	return true


func reset_all() -> void:
	currency.reset()
	shop.reset()
	transactions.reset()
	save_manager.delete_save_files()
	print("EconomyKit: All data reset")
