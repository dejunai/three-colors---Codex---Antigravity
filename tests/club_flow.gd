extends RefCounted

# Integration test suite for the Ophion Club House interior and service wing.

func cards(g: Node) -> void:
	while g.page == "dialogue": g._next_card()

func settle(g: Node) -> void:
	await g.get_tree().physics_frame
	await g.get_tree().physics_frame

func run(g: Node) -> void:
	await settle(g)
	g.state = g.CaseState.new()
	g.state.started = true
	g.state.discover("wounds")
	g.state.discover("eight")
	g.state.complete_report("Full inquest requested")
	g.state.estate_complete = true

	# Travel to the Ophion Club
	g._travel("club", Vector3(0, 0.1, 15), 0.0)
	await settle(g)
	assert(g.state.world == "club")
	assert(g._region_name() == "OPHION CLUB — FOYER")

	# Walk to Banquet Room via East archway
	await g._walk_to(Vector3(0, 0, 8.5))
	await g._walk_to(Vector3(10, 0, 8.5))
	await g._walk_to(Vector3(14, 0, 14.5))
	assert(g._region_name() == "THE BANQUET ROOM")
	assert(g.focused == "steward", "Steward must be reachable in Banquet Room")
	g._interact("steward")
	cards(g)
	assert(g.state.statements.has("The steward referred all questions of membership to Captain Odell."))

	# Inspect the 7 place settings on the banquet table
	await g._walk_to(Vector3(14, 0, 8.5))
	assert(g.focused == "linens", "Linens must be reachable at banquet table")
	g._interact("linens")
	cards(g)
	assert(g.state.evidence.has("seventh_place"))

	# Walk to Bar & Lounge via East archway
	await g._walk_to(Vector3(10, 0, 8.5))
	await g._walk_to(Vector3(0, 0, 8.5))
	await g._walk_to(Vector3(-3.4, 0, 2.5))
	assert(g._region_name() == "THE BAR & LOUNGE")
	assert(g.focused == "barman", "Barman must be reachable at the bar")

	# Test Barman in uniform (curt official answer)
	g.state.coat = "Police coat"
	g._interact("barman")
	cards(g)
	assert(not g.state.evidence.has("barman_her"), "Uniformed inquiry must not unlock intimate confession")

	# Test Barman in plain wool coat
	g.state.coat = "Plain wool coat"
	g._refresh_outfit()
	g._interact("barman")
	cards(g)
	assert(g.page == "barman", "Plain coat inquiry opens the bar conversation menu")
	var choices = g.content.find_children("*", "Button", true, false)
	assert(choices.size() >= 2)
	# Select 'Ask about the meetings and Her'
	choices[0].pressed.emit()
	cards(g)
	assert(g.state.evidence.has("barman_her"))
	# Select 'Ask about the pre-war gin'
	choices = g.content.find_children("*", "Button", true, false)
	choices[1].pressed.emit()
	cards(g)
	assert(g.state.statements.has("The barman mentioned pre-war gin behind the old pantry door in the kitchen wing."))
	g._close()

	# Walk to Dr. Fenn's Study via West archway
	await g._walk_to(Vector3(0, 0, 8.5))
	await g._walk_to(Vector3(-10, 0, 8.5))
	await g._walk_to(Vector3(-14, 0, 7.2))
	assert(g._region_name() == "DR. FENN'S STUDY")
	assert(g.focused == "fenn_study", "Fenn's desk must be reachable in his study")
	g._interact("fenn_study")
	cards(g)
	assert(g.state.evidence.has("fenn_book"))

	# Walk to Kitchen corridor and observe grounds crew through window
	await g._walk_to(Vector3(-10, 0, 8.5))
	await g._walk_to(Vector3(0, 0, 8.5))
	await g._walk_to(Vector3(1.5, 0, -2.0))
	await g._walk_to(Vector3(1.5, 0, -8.0))
	await g._walk_to(Vector3(-1.5, 0, -16.5))
	assert(g.focused == "kitchen_window", "Kitchen window must be reachable")
	g._interact("kitchen_window")
	cards(g)
	assert(g.state.evidence.has("observers_discipline"))

	# Walk to Old Service Pantry and discover the stone stair
	await g._walk_to(Vector3(-1.5, 0, -9.0))
	await g._walk_to(Vector3(-6.0, 0, -9.0))
	await g._walk_to(Vector3(-16.0, 0, -9.0))
	await g._walk_to(Vector3(-16.0, 0, -16.0))
	assert(g._region_name() == "THE SERVICE PANTRY")
	assert(g.focused == "pantry_stair", "Pantry stair must be reachable behind crates")
	g._interact("pantry_stair")
	cards(g)
	assert(g.state.evidence.has("pantry_stair"))

	# Verify perception growth
	assert(g.state.perception() >= 5)

	# Verify save and reload persistence within the Club
	g.comfort_time = 50
	assert(g._save_game())
	g.state = g.CaseState.new()
	g._load_game()
	assert(g.state.world == "club")
	assert(g.state.evidence.has("seventh_place") and g.state.evidence.has("barman_her"))
	assert(g.state.evidence.has("fenn_book") and g.state.evidence.has("pantry_stair"))
	assert(g.state.coat == "Plain wool coat" and g.comfort_time == 50)
	assert(g.player.position.distance_to(Vector3(-16.0, 0, -15.5)) < 0.6)

	print("CLUB PASS: traversal of all 5 club areas; coat-dependent barman testimony; 7th place setting; Fenn's library; Observers window; pantry stair; save/load persistence")
	g.get_tree().quit()
