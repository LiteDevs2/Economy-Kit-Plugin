class_name ShopManager
extends Node

signal purchase_completed(item_id: String, currency_id: String, price: int)
signal purchase_failed(item_id: String, reason: String)

var _items: Dictionary = {}
var _currency_manager: Node
var _transaction_manager: Node


func _ready() -> void:
	call_deferred("_setup_managers")


func _setup_managers() -> void:
	_currency_manager = get_node("/root/EconomyKit/CurrencyManager")
	_transaction_manager = get_node("/root/EconomyKit/TransactionManager")


func register_item(id: String, price: int, currency_id: String, display_name: String = "") -> bool:
	if id.is_empty():
		push_error("EconomyKit: Item ID cannot be empty.")
		return false
	
	if _items.has(id):
		push_error("EconomyKit: Item '%s' already exists." % id)
		return false
	
	if price <= 0:
		push_error("EconomyKit: Price must be positive.")
		return false
	
	if _currency_manager and not _currency_manager.exists(currency_id):
		push_error("EconomyKit: Currency '%s' does not exist." % currency_id)
		return false
	
	if display_name.is_empty():
		display_name = id
	
	_items[id] = {
		"id": id,
		"display_name": display_name,
		"price": price,
		"currency_id": currency_id
	}
	
	return true


func remove_item(id: String) -> bool:
	if not _items.has(id):
		push_error("EconomyKit: Item '%s' does not exist." % id)
		return false
	
	_items.erase(id)
	return true


func get_item(id: String) -> Dictionary:
	if not _items.has(id):
		push_error("EconomyKit: Item '%s' does not exist." % id)
		return {}
	return _items[id].duplicate()


func get_all_items() -> Dictionary:
	return _items.duplicate()


func can_purchase(id: String) -> bool:
	if not _items.has(id):
		return false
	
	if not _currency_manager:
		return false
	
	var item = _items[id]
	return _currency_manager.can_afford(item["currency_id"], item["price"])


func purchase(id: String) -> bool:
	if not _items.has(id):
		push_error("EconomyKit: Item '%s' does not exist." % id)
		purchase_failed.emit(id, "Item does not exist")
		return false
	
	var item = _items[id]
	var currency_id = item["currency_id"]
	var price = item["price"]
	
	if not _currency_manager:
		push_error("EconomyKit: Currency manager not available.")
		purchase_failed.emit(id, "Currency manager not available")
		return false
	
	if not _currency_manager.exists(currency_id):
		push_error("EconomyKit: Currency '%s' does not exist." % currency_id)
		purchase_failed.emit(id, "Currency does not exist")
		return false
	
	if not _currency_manager.can_afford(currency_id, price):
		push_error("EconomyKit: Insufficient funds for item '%s'." % id)
		purchase_failed.emit(id, "Insufficient funds")
		return false
	
	if not _currency_manager.remove(currency_id, price):
		push_error("EconomyKit: Failed to remove currency for purchase.")
		purchase_failed.emit(id, "Transaction failed")
		return false
	
	if _transaction_manager:
		_transaction_manager.add_transaction({
			"type": "purchase",
			"currency": currency_id,
			"amount": price,
			"reason": "Purchased item: %s" % item["display_name"],
			"timestamp": Time.get_unix_time_from_system()
		})
	
	purchase_completed.emit(id, currency_id, price)
	return true


func serialize() -> Dictionary:
	return _items.duplicate()


func deserialize(data: Dictionary) -> void:
	_items.clear()
	for id in data:
		var item_data = data[id]
		_items[id] = {
			"id": id,
			"display_name": item_data.get("display_name", id),
			"price": int(item_data.get("price", 0)),
			"currency_id": item_data.get("currency_id", "")
		}


func reset() -> void:
	_items.clear()
