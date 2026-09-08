extends RefCounted

# Integration test suite for the opening movement at the Ophion estate.

func cards(g: Node) -> void:
	while g.page == "dialogue": g._next_card()

func walk_to(g: Node, destination: Vector3) -> void:
	for i in 1500:
		var offset = Vector2(destination.x - g.player.position.x, destination.z - g.player.position.z)
		if offset.length() < 0.25: break
		var dir = offset.normalized()
		for action in ["walk_left", "walk_right", "walk_forward", "walk_back"]: Input.action_release(action)
		if dir.x > 0: Input.action_press("walk_right", dir.x)
		else: Input.action_press("walk_left", -dir.x)
		if dir.y > 0: Input.action_press("walk_back", dir.y)
		else: Input.action_press("walk_forward", -dir.y)
		await g.get_tree().physics_frame
	for action in ["walk_left", "walk_right", "walk_forward", "walk_back"]: Input.action_release(action)
	assert(Vector2(destination.x - g.player.position.x, destination.z - g.player.position.z).length() < 0.6,
		"Unreachable walking destination: " + str(destination) + " from " + str(g.player.position))

func run(g: Node) -> void:
	await g.get_tree().physics_frame
	g._difficulty_menu()
	assert(g.page == "difficulty", "Difficulty screen must open from title")
	g._difficulty_glitch()
	assert(g.glitch_time > 0, "Difficulty reject must produce visual glitch")
	assert(g.audio_manager != null, "Audio manager must be initialized")
	g.state.started = true
	g._close()
	g._interact("odell")
	cards(g)
	assert(g.state.evidence.has("eight"), "Required consultation supplies the count without optional collection")
	assert(g.state.visited.has("odell"))
	g._write_report("Observations filed", "report_routine")
	cards(g)
	assert(g.state.copies.size() == 2)
	assert(not g.state.visited.has("wounds"), "Minimal path must not claim examinations not performed")

	for id in ["wounds", "eight", "knife", "watch", "gas", "register", "shoes", "assistant"]:
		g._interact(id)
		if g.page == "birches":
			g._record_birch_choice("resistant")
		cards(g)

	assert(g.state.evidence.size() == 8)
	assert(g.state.orientation == "resistant", "Birch grove notation must set orientation")
	assert(g.state.report_evidence.size() == 1, "Additional notebook observations must not rewrite already prepared copies")

	g.state.coat = "Plain wool coat"
	g._interact("gardener")
	cards(g)
	assert(g.state.statements.has("The gardener saw the woman at the service door. Ask the steward."))
	g._write_report("Full inquest requested", "report_inquest")
	cards(g)
	assert(g.state.copies.size() == 3)

	g.state.flask = 1
	g.comfort_time = 45
	g.player.position = Vector3(10, 0.1, -3)
	assert(g._save_game())
	g.state = g.CaseState.new()
	g._load_game()
	assert(g.state.evidence.size() == 8 and g.state.flask == 1 and g.state.copies.size() == 3)
	assert(g.state.coat == "Plain wool coat" and g.comfort_time == 45 and g.state.orientation == "resistant")
	assert(g.player.position.distance_to(Vector3(10, 0.1, -3)) < 0.01)

	var compliant_case = g.CaseState.new()
	compliant_case.orientation = "compliant"
	compliant_case.started = true
	var comp_pack = compliant_case.pack()
	var restored_comp = g.CaseState.new()
	assert(restored_comp.restore(comp_pack))
	assert(restored_comp.orientation == "compliant")

	g._journal()
	assert(g.page == "journal")
	g._case_file()
	assert(g.page == "case")
	g._settings()
	assert(g.page == "settings")
	g._finish()
	assert(g.state.estate_complete)
	assert(g._save_game())

	var file = FileAccess.open(g.save_manager.save_path(), FileAccess.READ)
	var saved = JSON.parse_string(file.get_as_text())
	assert(saved.estate_complete and saved.copies.size() == 3 and saved.orientation == "resistant")
	print("QA PASS: difficulty menu glitch; minimal route; eight observations; compliance/resistance orientation; clothing testimony; two/three copies; full save/load; protected menus; completion")

	# Physical movement and hedge collision check
	g.state.finished = false
	g._close()
	g.player.position = Vector3(0, 0.1, 36)
	g.yaw = 0
	for stop in [Vector3(-1,0,31),Vector3(0,0,7),Vector3(0,0,1),Vector3(-4,0,-2),Vector3(-6,0,-0.4),Vector3(-12,0,1),Vector3(-5,0,1),Vector3(6,0,0),Vector3(12,0,-4),Vector3(23,0,-3.3),Vector3(25.6,0,-4),Vector3(12,0,-4),Vector3(10,0,-12),Vector3(4,0,-11.5),Vector3(7.4,0,-12.7),Vector3(6,0,-12.7),Vector3(-8,0,-18),Vector3(-5,0,-11),Vector3(-5,0,1),Vector3(0,0,7),Vector3(0,0,39)]:
		await walk_to(g, stop)
	assert(g.focused == "exit", "Departure must be reachable through real collision and interaction focus")

	g.player.position = Vector3(10, 0.1, 9)
	Input.action_press("walk_forward")
	for i in 100: await g.get_tree().physics_frame
	Input.action_release("walk_forward")
	assert(g.player.position.z > 6.6, "Hedge must block the player")
	print("QA PASS: actual WASD traversal through gate, garden, birch grove and terrace; departure focus; hedge collision")
	g.get_tree().quit()
