# EconomyKit API Reference

## Currencies

### EconomyKit.create_currency(id: String, display_name: String, symbol: String = "") -> bool
Creates a new currency.
- `id`: Unique identifier for the currency (letters, numbers, underscores only)
- `display_name`: Human-readable name
- `symbol`: Optional symbol like "🪙" or "$"
- Returns `true` if created, `false` if already exists or invalid parameters

### EconomyKit.currency.exists(id: String) -> bool
Checks if a currency exists.
- Returns `true` if the currency exists

### EconomyKit.currency.get(id: String) -> int
Gets the current balance of a currency.
- Returns balance as `int`, or `-1` if currency doesn't exist

### EconomyKit.currency.add(id: String, amount: int) -> bool
Adds currency to the balance.
- `amount`: Must be positive
- Returns `true` if successful, `false` if currency doesn't exist or invalid amount

### EconomyKit.currency.remove(id: String, amount: int) -> bool
Removes currency from the balance.
- `amount`: Must be positive
- Returns `true` if successful, `false` if insufficient balance or invalid amount

### EconomyKit.currency.set_balance(id: String, amount: int) -> bool
Sets the balance to a specific value.
- `amount`: Must be non-negative
- Returns `true` if successful, `false` if currency doesn't exist or invalid amount

### EconomyKit.currency.can_afford(id: String, amount: int) -> bool
Checks if the player can afford an amount.
- Returns `true` if the player has enough balance

### EconomyKit.currency.get_info(id: String) -> Dictionary
Gets full info about a currency.
- Returns Dictionary with keys: `id`, `display_name`, `symbol`, `balance`

### EconomyKit.currency.get_all() -> Dictionary
Gets all currencies.
- Returns Dictionary with currency IDs as keys

## Shop

### EconomyKit.shop.register_item(id: String, price: int, currency_id: String, display_name: String = "") -> bool
Registers a new shop item.
- `id`: Unique identifier for the item
- `price`: Must be positive
- `currency_id`: Must reference an existing currency
- `display_name`: Optional, uses ID if not provided
- Returns `true` if successful, `false` if item already exists or invalid parameters

### EconomyKit.shop.remove_item(id: String) -> bool
Removes a shop item.
- Returns `true` if successful, `false` if item doesn't exist

### EconomyKit.shop.get_item(id: String) -> Dictionary
Gets info about a shop item.
- Returns Dictionary with keys: `id`, `display_name`, `price`, `currency_id`

### EconomyKit.shop.get_all_items() -> Dictionary
Gets all shop items.
- Returns Dictionary with item IDs as keys

### EconomyKit.shop.can_purchase(id: String) -> bool
Checks if player can purchase an item.
- Returns `true` if item exists and player has enough balance

### EconomyKit.shop.purchase(id: String) -> bool
Purchases an item.
- Returns `true` if successful, `false` if item doesn't exist or insufficient funds

## Transactions

### EconomyKit.get_transactions(limit: int = 50) -> Array
Gets recent transactions.
- `limit`: Maximum number of transactions to return (0 returns empty array)
- Returns Array of Dictionaries with keys: `type`, `currency`, `amount`, `reason`, `timestamp`

## Persistence

### EconomyKit.save() -> bool
Saves all economy data to local storage.
- Returns `true` if successful

### EconomyKit.load_data() -> bool
Loads economy data from local storage.
- Returns `true` if data was loaded successfully

### EconomyKit.reset_all() -> void
Resets all economy data.
- Deletes all currencies, shop items, and transactions

## Signals

### balance_changed(currency_id: String, old_value: int, new_value: int)
Emitted when a currency balance changes.

### currency_created(currency_id: String)
Emitted when a new currency is created.

### transaction_created(transaction: Dictionary)
Emitted when a new transaction is recorded.

### purchase_completed(item_id: String, currency_id: String, price: int)
Emitted when a purchase is completed successfully.

### data_saved()
Emitted when economy data is saved.

### data_loaded()
Emitted when economy data is loaded.

## Example Usage

```gdscript
EconomyKit.create_currency("Coins", "Coins", "🪙")
EconomyKit.create_currency("Gems", "Gems", "💎")

EconomyKit.currency.add("Coins", 1000)

var coins = EconomyKit.currency.get("Coins")

if EconomyKit.currency.can_afford("Coins", 250):
    EconomyKit.currency.remove("Coins", 250)

EconomyKit.shop.register_item("health_potion", 50, "Coins", "Health Potion")

if EconomyKit.shop.can_purchase("health_potion"):
    EconomyKit.shop.purchase("health_potion")

var transactions = EconomyKit.get_transactions(10)

EconomyKit.save()