extends SceneTree

func _init() -> void:
	var zip_path = "C:/Users/Dejunai/AppData/Roaming/Godot/export_templates/4.7.2.stable/web_nothreads_release.zip"
	var out_dir = "res://builds/web"
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(out_dir))

	var reader = ZIPReader.new()
	var err = reader.open(zip_path)
	if err != OK:
		print("Failed to open template zip: ", err)
		quit(1)
		return

	var files = reader.get_files()
	var html_data: PackedByteArray
	for f in files:
		var data = reader.read_file(f)
		var target_name = f.replace("godot", "index")
		var out_path = out_dir + "/" + target_name
		
		if f == "godot.html":
			html_data = data
		else:
			var file = FileAccess.open(out_path, FileAccess.WRITE)
			file.store_buffer(data)
			file.close()
			print("Extracted Asset: ", out_path)

	reader.close()

	# Process HTML after extracting assets so we know file sizes
	var pck_size = 0
	var wasm_size = 0
	var pck_file = FileAccess.open(out_dir + "/index.pck", FileAccess.READ)
	if pck_file:
		pck_size = pck_file.get_length()
		pck_file.close()
	var wasm_file = FileAccess.open(out_dir + "/index.wasm", FileAccess.READ)
	if wasm_file:
		wasm_size = wasm_file.get_length()
		wasm_file.close()

	var godot_config = JSON.stringify({
		"args": [],
		"canvasResizePolicy": 2,
		"ensureCrossOriginIsolationHeaders": true,
		"executable": "index",
		"experimentalVK": false,
		"fileSizes": {
			"index.pck": pck_size,
			"index.wasm": wasm_size
		},
		"focusCanvas": true,
		"gdextensionLibs": []
	}, "\t")

	var html_text = html_data.get_string_from_utf8()
	html_text = html_text.replace("$GODOT_BASENAME", "index")
	html_text = html_text.replace("$GODOT_PROJECT_NAME", "Three Colors of Madness — No Exit Wound")
	html_text = html_text.replace("$GODOT_HEAD_INCLUDE", "")
	html_text = html_text.replace("$GODOT_SPLASH", "")
	html_text = html_text.replace("_COLOR", "#141419")
	html_text = html_text.replace("_CLASSES", "show-image--false")
	html_text = html_text.replace("$GODOT_URL", "index.js")
	html_text = html_text.replace("$GODOT_CONFIG", godot_config)
	html_text = html_text.replace("$GODOT_THREADS_ENABLED", "false")

	var html_file = FileAccess.open(out_dir + "/index.html", FileAccess.WRITE)
	html_file.store_string(html_text)
	html_file.close()
	print("Extracted & Patched HTML: ", out_dir + "/index.html")

	print("HTML5 Export Assembly Complete!")
	quit(0)
