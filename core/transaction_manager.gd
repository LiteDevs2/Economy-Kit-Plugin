extends Node

signal transaction_created(transaction: Dictionary)

const MAX_TRANSACTIONS := 100

var _transactions: Array = []


func add_transaction(transaction: Dictionary) -> bool:
	if not transaction.has("type"):
		push_error("EconomyKit: Transaction must have a 'type' field.")
		return false
	
	if not transaction.has("amount"):
		push_error("EconomyKit: Transaction must have an 'amount' field.")
		return false
	
	if not transaction.has("timestamp"):
		transaction["timestamp"] = Time.get_unix_time_from_system()
	
	_transactions.append(transaction)
	
	while _transactions.size() > MAX_TRANSACTIONS:
		_transactions.pop_front()
	
	transaction_created.emit(transaction)
	return true


func get_transactions(limit: int = 50) -> Array:
	if limit <= 0:
		return []
	
	var recent = _transactions.duplicate()
	recent.reverse()
	
	if recent.size() > limit:
		return recent.slice(0, limit)
	return recent


func serialize() -> Array:
	return _transactions.duplicate()


func deserialize(data: Array) -> void:
	_transactions.clear()
	for transaction in data:
		_transactions.append(transaction)


func reset() -> void:
	_transactions.clear()
