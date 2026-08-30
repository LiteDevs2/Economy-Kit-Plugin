EconomyKit for Godot 4.7

A simple, local economy framework for Godot 4.7.

✨ Features

- 💰 Multiple currencies
- 👛 Wallet and balance management
- 🛒 Shop system
- 📜 Transaction history
- 💾 Automatic local saving
- 🔄 Save backups
- 📡 Economy signals
- 📴 Works completely offline
- 📦 No external dependencies

📥 Installation

Copy:

addons/economykit

into your Godot project's "addons" folder.

Then add EconomyKit as an Autoload:

Project → Project Settings → Globals → Autoload

Add:

Path: res://addons/economykit/economy_kit.gd
Name: EconomyKit

Enable it and you're ready to go.

🚀 Quick Start

Create a currency:

EconomyKit.create_currency("Coins", "Coins", "🪙")

Add currency:

EconomyKit.currency.add("Coins", 500)

Get the balance:

var coins = EconomyKit.currency.get("Coins")
print(coins)

Spend currency:

if EconomyKit.currency.can_afford("Coins", 100):
    EconomyKit.currency.remove("Coins", 100)

💾 Saving

EconomyKit automatically saves economy data locally.

user://economykit/

You can also save manually:

EconomyKit.save()

📋 Requirements

- Godot 4.7
- No external dependencies

📄 License

See "LICENSE.md" (LICENSE.md).

EconomyKit is free to use and distribute under its license.

🤝 Contributing

Found a bug or have an idea?

Feel free to open an issue or submit a pull request.

---

Made for the Godot community ❤️
