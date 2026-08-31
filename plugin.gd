@tool
extends EditorPlugin

func _enter_tree() -> void:
	add_autoload_singleton("EconomyKit", "res://addons/economykit/economy_kit.gd")
	
	print("EconomyKit plugin enabled")


func _exit_tree() -> void:
	remove_autoload_singleton("EconomyKit")
	
	print("EconomyKit plugin disabled")
