extends RefCounted

# Dedicated SaveManager handling atomic JSON persistence and cross-platform discovery.

var test_mode: bool = false
var capture_mode: String = ""

func _init(p_test_mode: bool = false, p_capture_mode: String = "") -> void:
	test_mode = p_test_mode
	capture_mode = p_capture_mode

func save_path() -> String:
	return "user://opening_qa.json" if test_mode else "user://opening_save.json"

func available_save_path() -> String:
	var candidates = [ProjectSettings.globalize_path(save_path())]
	if not test_mode and capture_mode.is_empty():
		var folder = "Godot/app_userdata/" + str(ProjectSettings.get_setting("application/config/name")) + "/opening_save.json"
		var user_profile = OS.get_environment("USERPROFILE")
		if not user_profile.is_empty():
			candidates.append(user_profile.path_join("AppData/Roaming").path_join(folder))
		candidates.append(ProjectSettings.globalize_path("res://.runtime-data").path_join(folder))
	var best = ""
	var timestamp = 0
	for candidate in candidates:
		if FileAccess.file_exists(candidate) and FileAccess.get_modified_time(candidate) >= timestamp:
			best = candidate
			timestamp = FileAccess.get_modified_time(candidate)
	return best

func save_game(state, player_pos: Vector3, yaw: float, pitch: float, distance: float, comfort_time: float) -> bool:
	if not state.started or not capture_mode.is_empty(): return false
	state.position = player_pos
	state.yaw = yaw
	var d = state.pack()
	d["comfort_time"] = comfort_time
	d["pitch"] = pitch
	d["distance"] = distance
	var target = save_path()
	var temporary = target + ".tmp"
	var file = FileAccess.open(temporary, FileAccess.WRITE)
	if file == null:
		return false
	file.store_string(JSON.stringify(d, "\t"))
	file.close()
	if DirAccess.rename_absolute(temporary, target) != OK:
		return false
	return true

func load_game_dict() -> Dictionary:
	var path = available_save_path()
	if path.is_empty() or not FileAccess.file_exists(path):
		return {}
	var file = FileAccess.open(path, FileAccess.READ)
	if file == null:
		return {}
	var d = JSON.parse_string(file.get_as_text())
	if d is Dictionary:
		return d
	return {}

func save_settings(settings: Dictionary) -> void:
	if test_mode or not capture_mode.is_empty(): return
	var file = FileAccess.open("user://opening_settings.json", FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(settings))

func load_settings(target_settings: Dictionary) -> void:
	if not FileAccess.file_exists("user://opening_settings.json"): return
	var d = JSON.parse_string(FileAccess.get_file_as_string("user://opening_settings.json"))
	if d is Dictionary:
		for key in target_settings:
			if d.has(key):
				target_settings[key] = d[key]
