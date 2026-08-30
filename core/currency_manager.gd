class_name CurrencyManager
extends Node

signal balance_changed(currency_id: String, old_value: int, new_value: int)
signal currency_created(currency_id: String)

const VALID_ID_REGEX := "^[a-zA-Z0-9_]+$"

var _currencies: Dictionary = {}


func create_currency(id: String, display_name: String, symbol: String = "") -> bool:
	if id.is_empty() or not _is_valid_id(id):
		push_error("EconomyKit: Invalid currency ID '%s'. Must contain only letters, numbers, and underscores." % id)
		return false
	
	if _currencies.has(id):
		push_error("EconomyKit: Currency '%s' already exists." % id)
		return false
	
	if display_name.is_empty():
		push_error("EconomyKit: Display name cannot be empty.")
		return false
	
	_currencies[id] = {
		"id": id,
		"display_name": display_name,
		"symbol": symbol,
		"balance": 0
	}
	
	currency_created.emit(id)
	return true


func exists(id: String) -> bool:
	return _currencies.has(id)


func get_balance(id: String) -> int:
	if not _currencies.has(id):
		push_error("EconomyKit: Currency '%s' does not exist." % id)
		return -1
	return _currencies[id]["balance"]


func add(id: String, amount: int) -> bool:
	if amount <= 0:
		push_error("EconomyKit: Amount must be positive.")
		return false
	
	if not _currencies.has(id):
		push_error("EconomyKit: Currency '%s' does not exist." % id)
		return false
	
	var old_value = _currencies[id]["balance"]
	var new_value = old_value + amount
	_currencies[id]["balance"] = new_value
	
	balance_changed.emit(id, old_value, new_value)
	return true


func remove(id: String, amount: int) -> bool:
	if amount <= 0:
		push_error("EconomyKit: Amount must be positive.")
		return false
	
	if not _currencies.has(id):
		push_error("EconomyKit: Currency '%s' does not exist." % id)
		return false
	
	if not can_afford(id, amount):
		push_error("EconomyKit: Insufficient balance for '%s'." % id)
		return false
	
	var old_value = _currencies[id]["balance"]
	var new_value = old_value - amount
	_currencies[id]["balance"] = new_value
	
	balance_changed.emit(id, old_value, new_value)
	return true


func set_balance(id: String, amount: int) -> bool:
	if amount < 0:
		push_error("EconomyKit: Balance cannot be negative.")
		return false
	
	if not _currencies.has(id):
		push_error("EconomyKit: Currency '%s' does not exist." % id)
		return false
	
	var old_value = _currencies[id]["balance"]
	_currencies[id]["balance"] = amount
	
	balance_changed.emit(id, old_value, amount)
	return true


func can_afford(id: String, amount: int) -> bool:
	if not _currencies.has(id):
		return false
	return _currencies[id]["balance"] >= amount


func get_info(id: String) -> Dictionary:
	if not _currencies.has(id):
		push_error("EconomyKit: Currency '%s' does not exist." % id)
		return {}
	return _currencies[id].duplicate()


func get_all() -> Dictionary:
	return _currencies.duplicate()


func serialize() -> Dictionary:
	return _currencies.duplicate()


func deserialize(data: Dictionary) -> void:
	_currencies.clear()
	for id in data:
		var currency_data = data[id]
		_currencies[id] = {
			"id": id,
			"display_name": currency_data.get("display_name", id),
			"symbol": currency_data.get("symbol", ""),
			"balance": int(currency_data.get("balance", 0))
		}


func reset() -> void:
	_currencies.clear()


func _is_valid_id(id: String) -> bool:
	var regex = RegEx.new()
	regex.compile(VALID_ID_REGEX)
	return regex.search(id) != null
