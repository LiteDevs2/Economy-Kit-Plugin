<div align="center">EconomyKit

A simple economy framework for Godot 4.7

💰 Currencies · 🛒 Shops · 📜 Transactions · 💾 Local Saving

""Godot" (https://img.shields.io/badge/Godot-4.7-478CBF?logo=godot-engine&logoColor=white)" (https://godotengine.org/)
""License" (https://img.shields.io/badge/License-Free%20Use-green)" (LICENSE.md)

</div>---

✨ Features

Feature| Description
💰 Currencies| Create and manage multiple currencies
👛 Wallet| Easily manage player balances
🛒 Shops| Register items and handle purchases
📜 Transactions| Track economy changes and transaction history
💾 Local Saving| Automatically save data using "user://"
🔄 Backups| Keep a backup of previous save data
📡 Signals| React to balance and purchase events
📴 Offline| Works without an internet connection
📦 No Dependencies| No external services required

---

📥 Installation

1. Download EconomyKit

Download the repository using:

Code → Download ZIP

Extract it and copy:

addons/economykit

into your Godot project's "addons" folder.

Your project should look like:

YourProject/
├── addons/
│   └── economykit/
├── scenes/
├── scripts/
└── project.godot

2. Add the Autoload

Go to:

Project → Project Settings → Globals → Autoload

Add:

Path: res://addons/economykit/economy_kit.gd
Name: EconomyKit

Enable it.

---

🚀 Quick Start

Create a currency

EconomyKit.create_currency("Coins", "Coins", "🪙")

Add currency

EconomyKit.currency.add("Coins", 500)

Get the balance

var coins = EconomyKit.currency.get("Coins")
print("Coins:", coins)

Spend currency

if EconomyKit.currency.can_afford("Coins", 100):
    EconomyKit.currency.remove("Coins", 100)

---

🛒 Shop Example

EconomyKit.shop.register_item(
    "iron_sword",
    250,
    "Coins",
    "Iron Sword"
)

if EconomyKit.shop.purchase("iron_sword"):
    print("Purchase successful!")

---

💾 Saving

EconomyKit automatically saves economy data locally.

user://economykit/
├── economy.json
└── economy.backup.json

Manual save:

EconomyKit.save()

---

📡 Signals

EconomyKit provides signals for important economy events:

balance_changed
currency_created
transaction_created
purchase_completed
data_saved
data_loaded

Example:

func _ready():
    EconomyKit.balance_changed.connect(_on_balance_changed)

func _on_balance_changed(currency_id, old_value, new_value):
    print(currency_id, ": ", old_value, " -> ", new_value)

---

⚠️ Important

EconomyKit uses local storage, so saved economy data is not cheat-proof.

Players can potentially modify files stored on their device.

For competitive multiplayer games, use a trusted server/backend instead of relying on local economy data.

---

📋 Requirements

- Godot 4.7
- No external dependencies
- No internet connection required

---

📄 License

EconomyKit is free to use and distribute under the "EconomyKit Free Use License" (LICENSE.md).

---

🤝 Contributing

Found a bug or have an idea?

Open an issue or submit a pull request.

Contributions are welcome.

---

<div align="center">Made for the Godot community ❤️

</div>
