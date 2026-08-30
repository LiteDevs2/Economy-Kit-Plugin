extends Control

@onready var coins_label: Label = $VBox/CoinsLabel
@onready var gems_label: Label = $VBox/GemsLabel
@onready var transactions_list: ItemList = $VBox/TransactionsList
@onready var add_coins_button: Button = $VBox/AddCoinsButton
@onready var remove_coins_button: Button = $VBox/RemoveCoinsButton
@onready var purchase_button: Button = $VBox/PurchaseButton
@onready var save_button: Button = $VBox/SaveButton
@onready var load_button: Button = $VBox/LoadButton

var economy_kit: Node


func _ready() -> void:
	economy_kit = get_node("/root/EconomyKit")
	
	if not economy_kit.currency.exists("Coins"):
		economy_kit.create_currency("Coins", "Coins", "🪙")
	if not economy_kit.currency.exists("Gems"):
		economy_kit.create_currency("Gems", "Gems", "💎")
	
	if economy_kit.shop.get_item("iron_sword").is_empty():
		economy_kit.shop.register_item("iron_sword", 250, "Coins", "Iron Sword")
	
	add_coins_button.pressed.connect(_on_add_coins_pressed)
	remove_coins_button.pressed.connect(_on_remove_coins_pressed)
	purchase_button.pressed.connect(_on_purchase_pressed)
	save_button.pressed.connect(_on_save_pressed)
	load_button.pressed.connect(_on_load_pressed)
	
	economy_kit.balance_changed.connect(_on_balance_changed)
	economy_kit.purchase_completed.connect(_on_purchase_completed)
	
	_update_ui()


func _on_add_coins_pressed() -> void:
	economy_kit.currency.add("Coins", 100)
	economy_kit.transactions.add_transaction({
		"type": "reward",
		"currency": "Coins",
		"amount": 100,
		"reason": "Demo: Add coins button",
		"timestamp": Time.get_unix_time_from_system()
	})
	_update_ui()


func _on_remove_coins_pressed() -> void:
	if economy_kit.currency.remove("Coins", 50):
		economy_kit.transactions.add_transaction({
			"type": "spend",
			"currency": "Coins",
			"amount": 50,
			"reason": "Demo: Remove coins button",
			"timestamp": Time.get_unix_time_from_system()
		})
	else:
		print("Failed to remove coins - insufficient balance")
	_update_ui()


func _on_purchase_pressed() -> void:
	if economy_kit.shop.purchase("iron_sword"):
		print("Successfully purchased Iron Sword!")
	else:
		print("Failed to purchase Iron Sword - insufficient funds")
	_update_ui()


func _on_save_pressed() -> void:
	if economy_kit.save():
		print("Data saved successfully!")
	else:
		print("Failed to save data")
	_update_ui()


func _on_load_pressed() -> void:
	if economy_kit.load_data():
		print("Data loaded successfully!")
	else:
		print("No save data found")
	_update_ui()


func _on_balance_changed(currency_id: String, old_value: int, new_value: int) -> void:
	print("Balance changed: %s: %d -> %d" % [currency_id, old_value, new_value])
	_update_ui()


func _on_purchase_completed(item_id: String, currency_id: String, price: int) -> void:
	print("Purchase completed: %s for %d %s" % [item_id, price, currency_id])
	_update_ui()


func _update_ui() -> void:
	coins_label.text = "Coins: %d" % economy_kit.currency.get_balance("Coins")
	gems_label.text = "Gems: %d" % economy_kit.currency.get_balance("Gems")
	
	transactions_list.clear()
	var transactions = economy_kit.get_transactions(10)
	for transaction in transactions:
		var time_string = Time.get_datetime_string_from_unix_time(transaction["timestamp"])
		transactions_list.add_item(
			"%s — %s: %d %s" % [
				time_string,
				transaction["type"],
				transaction["amount"],
				transaction.get("currency", "")
			]
		)
