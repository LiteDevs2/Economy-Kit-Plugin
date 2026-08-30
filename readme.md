# EconomyKit for Godot 4.7

EconomyKit is a complete local economy system for Godot 4.7 that provides currencies, wallets, shops, transactions, and persistence out of the box. It's designed to be simple for beginners while maintaining clean architecture for larger projects.

## Features

- Multiple Currencies: Create unlimited currencies with custom symbols and names
- Wallet System: Easy-to-use API for managing player balances
- Transaction History: Every economy change is recorded with timestamps
- Shop System: Register items and handle purchases with automatic validation
- Local Persistence: Automatic saving to user:// with backup files
- Signals: Connect to economy events like balance changes and purchases
- Editor Dock: View and debug economy data directly in the Godot editor
- Zero Dependencies: Works completely offline with no external services required

## Installation

1. Copy the addons/economykit folder into your Godot project
2. Enable the plugin: Project → Project Settings → Plugins → EconomyKit → Enable
3. The EconomyKit autoload is automatically registered
4. Optionally, copy the demo folder to test the system

## Quick Start

```gdscript
EconomyKit.create_currency("Coins", "Coins", "🪙")
EconomyKit.create_currency("Gems", "Gems", "💎")

EconomyKit.currency.add("Coins", 500)

var coins = EconomyKit.currency.get("Coins")
print("Coins: ", coins)

if EconomyKit.currency.can_afford("Coins", 250):
    EconomyKit.currency.remove("Coins", 250)