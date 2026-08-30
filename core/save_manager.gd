class_name SaveManager
extends Node

const SAVE_DIR := "user://economykit"
const MAIN_SAVE_FILE := "user://economykit/economy.json"
const BACKUP_SAVE_FILE := "user://economykit/economy.backup.json"


func _ready() -> void:
	DirAccess.make_dir_recursive_absolute(SAVE_DIR)


func save_data(data: Dictionary) -> bool:
	if not DirAccess.dir_exists_absolute(SAVE_DIR):
		DirAccess.make_dir_recursive_absolute(SAVE_DIR)
	
	if FileAccess.file_exists(MAIN_SAVE_FILE):
		var backup_file = FileAccess.open(BACKUP_SAVE_FILE, FileAccess.WRITE)
		if backup_file:
			var main_file = FileAccess.open(MAIN_SAVE_FILE, FileAccess.READ)
			if main_file:
				backup_file.store_string(main_file.get_as_text())
				main_file.close()
			backup_file.close()
	
	var file = FileAccess.open(MAIN_SAVE_FILE, FileAccess.WRITE)
	if not file:
		push_error("EconomyKit: Failed to open save file for writing.")
		return false
	
	file.store_string(JSON.stringify(data, "\t"))
	file.close()
	return true


func load_data() -> Dictionary:
	if not FileAccess.file_exists(MAIN_SAVE_FILE):
		if FileAccess.file_exists(BACKUP_SAVE_FILE):
			return _load_from_file(BACKUP_SAVE_FILE)
		return {}
	
	var data = _load_from_file(MAIN_SAVE_FILE)
	
	if data.is_empty() and FileAccess.file_exists(BACKUP_SAVE_FILE):
		data = _load_from_file(BACKUP_SAVE_FILE)
	
	return data


func _load_from_file(path: String) -> Dictionary:
	var file = FileAccess.open(path, FileAccess.READ)
	if not file:
		push_error("EconomyKit: Failed to open save file for reading.")
		return {}
	
	var content = file.get_as_text()
	file.close()
	
	if content.is_empty():
		return {}
	
	var json = JSON.new()
	var error = json.parse(content)
	if error != OK:
		push_error("EconomyKit: Failed to parse save file JSON.")
		return {}
	
	var data = json.data
	if typeof(data) != TYPE_DICTIONARY:
		push_error("EconomyKit: Save file does not contain valid data.")
		return {}
	
	return data


func delete_save_files() -> void:
	if FileAccess.file_exists(MAIN_SAVE_FILE):
		DirAccess.remove_absolute(MAIN_SAVE_FILE)
	if FileAccess.file_exists(BACKUP_SAVE_FILE):
		DirAccess.remove_absolute(BACKUP_SAVE_FILE)
