EconomyKit API Reference

Currencies

"economy_kit.create_currency(id: String, display_name: String, symbol: String = "") -> bool"

Creates a new currency.

- "id": Unique identifier for the currency (letters, numbers, and underscores only)
- "display_name": Human-readable name
- "symbol": Optional symbol such as ""🪙"" or ""$""
- Returns "true" if created, "false" if it already exists or parameters are invalid

"economy_kit.currency.exists(id: String) -> bool"

Checks if a currency exists.

- Returns "true" if the currency exists

"economy_kit.currency.get(id: String) -> int"

Gets the current balance of a currency.

- Returns the balance as an "int"
- Returns "-1" if the currency doesn't exist

"economy_kit.currency.add(id: String, amount: int) -> bool"

Adds currency to the balance.

- "amount": Must be positive
- Returns "true" if successful, "false" if the currency doesn't exist or the amount is invalid

"economy_kit.currency.remove(id: String, amount: int) -> bool"

Removes currency from the balance.

- "amount": Must be positive
- Returns "true" if successful, "false" if the balance is insufficient or the amount is invalid

"economy_kit.currency.set_balance(id: String, amount: int) -> bool"

Sets the balance to a specific value.

- "amount": Must be non-negative
- Returns "true" if successful, "false" if the currency doesn't exist or the amount is invalid

"economy_kit.currency.can_afford(id: String, amount: int) -> bool"

Checks if the player can afford an amount.

- Returns "true" if the player has enough balance

"economy_kit.currency.get_info(id: String) -> Dictionary"

Gets full information about a currency.

Returns a "Dictionary" containing:

- "id"
- "display_name"
- "symbol"
- "balance"

"economy_kit.currency.get_all() -> Dictionary"

Gets all currencies.

- Returns a "Dictionary" with currency IDs as keys

---

Shop

"economy_kit.shop.register_item(id: String, price: int, currency_id: String, display_name: String = "") -> bool"

Registers a new shop item.

- "id": Unique identifier for the item
- "price": Must be positive
- "currency_id": Must reference an existing currency
- "display_name": Optional. Uses the ID if not provided
- Returns "true" if successful, "false" if the item already exists or parameters are invalid

"economy_kit.shop.remove_item(id: String) -> bool"

Removes a shop item.

- Returns "true" if successful
- Returns "false" if the item doesn't exist

"economy_kit.shop.get_item(id: String) -> Dictionary"

Gets information about a shop item.

Returns a "Dictionary" containing:

- "id"
- "display_name"
- "price"
- "currency_id"

"economy_kit.shop.get_all_items() -> Dictionary"

Gets all shop items.

- Returns a "Dictionary" with item IDs as keys

"economy_kit.shop.can_purchase(id: String) -> bool"

Checks if the player can purchase an item.

- Returns "true" if the item exists and the player has enough balance

"economy_kit.shop.purchase(id: String) -> bool"

Purchases an item.

- Returns "true" if successful
- Returns "false" if the item doesn't exist or the player has insufficient funds

---

Transactions

"economy_kit.get_transactions(limit: int = 50) -> Array"

Gets recent transactions.

- "limit": Maximum number of transactions to return
- "0" returns an empty array
- Returns an "Array" of "Dictionary" objects containing:
  - "type"
  - "currency"
  - "amount"
  - "reason"
  - "timestamp"

---

Persistence

"economy_kit.save() -> bool"

Saves all economy data to local storage.

- Returns "true" if successful

"economy_kit.load_data() -> bool"

Loads economy data from local storage.

- Returns "true" if data was loaded successfully

"economy_kit.reset_all() -> void"

Resets all economy data.

This deletes:

- All currencies
- All shop items
- All transactions

---

Signals

"balance_changed(currency_id: String, old_value: int, new_value: int)"

Emitted when a currency balance changes.

"currency_created(currency_id: String)"

Emitted when a new currency is created.

"transaction_created(transaction: Dictionary)"

Emitted when a new transaction is recorded.

"purchase_completed(item_id: String, currency_id: String, price: int)"

Emitted when a purchase is completed successfully.

"data_saved()"

Emitted when economy data is saved.

"data_loaded()"

Emitted when economy data is loaded.

---

Example Usage

economy_kit.create_currency("Coins", "Coins", "🪙")
economy_kit.create_currency("Gems", "Gems", "💎")

economy_kit.currency.add("Coins", 1000)

var coins = economy_kit.currency.get("Coins")

if economy_kit.currency.can_afford("Coins", 250):
    economy_kit.currency.remove("Coins", 250)

economy_kit.shop.register_item(
    "health_potion",
    50,
    "Coins",
    "Health Potion"
)

if economy_kit.shop.can_purchase("health_potion"):
    economy_kit.shop.purchase("health_potion")

var transactions = economy_kit.get_transactions(10)

economy_kit.save()