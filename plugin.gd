@tool
extends EditorPlugin

const EconomyKitAutoload = preload("res://addons/economykit/economy_kit.gd")
const EconomyDockScene = preload("res://addons/economykit/editor/economy_dock.tscn")

var dock: Control

func _enter_tree() -> void:
	add_autoload_singleton("EconomyKit", "res://addons/economykit/economy_kit.gd")
	
	dock = EconomyDockScene.instantiate()
	add_control_to_dock(DOCK_SLOT_RIGHT_BL, dock)
	
	print("EconomyKit plugin enabled")


func _exit_tree() -> void:
	if dock:
		remove_control_from_docks(dock)
		dock.queue_free()
		dock = null
	
	remove_autoload_singleton("EconomyKit")
	
	print("EconomyKit plugin disabled")
