extends RefCounted

# Integration test suite for Chapter One Slice III: The Subterranean Descent.

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
	g.state.discover("pantry_stair")
	g.state.estate_complete = true
	g.state.flask = 2

	# 1. Travel into the subterranean descent beneath the pantry
	g._travel("tunnel", Vector3(0, 0.1, 19.5), 0.0)
	await settle(g)
	assert(g.state.world == "tunnel")
	assert(g._region_name() == "THE STONE STAIRWELL")

	# 2. Descend into the upper shored passage
	await g._walk_to(Vector3(0, 0, 7.0))
	assert(g._region_name() == "THE SHORED PASSAGE")

	# 3. Reach the Silt Alcove and discover Patrolman Thomas's whistle
	await g._walk_to(Vector3(-3.5, 0, -6.5))
	assert(g._region_name() == "THE SILT ALCOVE")
	assert(g.focused == "whistle", "Whistle must be reachable in silt alcove")
	g._interact("whistle")
	cards(g)
	assert(g.state.evidence.has("corroded_whistle"))
	assert(g.state.statements.has("Patrolman Thomas, badge 114. Vanished November 1918. He did not walk off his post."))

	# 4. Inspect the mineral fracture (impossible strata)
	await g._walk_to(Vector3(3.8, 0, -10.0))
	assert(g.focused == "strata", "Strata fracture must be reachable on east wall")
	g._interact("strata")
	cards(g)
	assert(g.state.evidence.has("impossible_strata"))

	# 5. Advance to the Chasm Ledge and trigger the loose flask event
	await g._walk_to(Vector3(0.5, 0, -14.0))
	await g._walk_to(Vector3(-0.5, 0, -18.5))
	assert(g._region_name() == "THE CHASM LEDGE")
	assert(g.focused == "fissure", "Fissure ledge must be reachable")
	g._interact("fissure")
	cards(g)
	assert(g.state.evidence.has("lost_flask"))
	assert(g.state.flask == 0, "Carried flask must be permanently lost into the abyss")

	# 6. Enter the Sea-Gate Cavern and examine the plinth and silver needles
	await g._walk_to(Vector3(0.5, 0, -22.0))
	await g._walk_to(Vector3(0.0, 0, -27.5))
	assert(g._region_name() == "THE SEA-GATE CAVERN")
	assert(g.focused == "plinth", "Stone plinth must be reachable in center of cavern")
	g._interact("plinth")
	cards(g)
	assert(g.state.evidence.has("silver_needles"))

	# 7. Observe the ancient subterranean sea-gate opening to the open bay
	await g._walk_to(Vector3(0.0, 0, -35.5))
	assert(g.focused == "sea_gate", "Sea-gate must be reachable at north cavern wall")
	g._interact("sea_gate")
	cards(g)
	assert(g.state.evidence.has("sea_gate"))

	# 8. Verify perception progression
	assert(g.state.perception() >= 6, "Perception must grow with physical and mineral observations")

	# 9. Verify save and reload persistence within the subterranean tunnel
	assert(g._save_game())
	var d = g.save_manager.load_game_dict()
	assert(not d.is_empty())
	var saved = g.CaseState.new()
	assert(saved.restore(d))
	assert(saved.world == "tunnel")
	assert(saved.evidence.has("silver_needles"))
	assert(saved.evidence.has("corroded_whistle"))
	assert(saved.evidence.has("lost_flask"))
	assert(saved.flask == 0)

	# 10. Ascend back up the passage and stairs to the Club pantry
	await g._walk_to(Vector3(0.0, 0, -27.5))
	await g._walk_to(Vector3(0.5, 0, -18.5))
	await g._walk_to(Vector3(0.0, 0, -6.5))
	await g._walk_to(Vector3(0.0, 0, 7.0))
	await g._walk_to(Vector3(0.0, 0, 19.5))
	assert(g.focused == "stair_exit", "Stair exit must be focused at the landing")
	g._interact("stair_exit")
	await settle(g)
	assert(g.state.world == "club")
	assert(g._region_name() == "THE SERVICE PANTRY")

	print("TUNNEL PASS: full subterranean descent; silt whistle; impossible strata; fissure flask loss; silver needles; sea-gate arch; persistence; return ascent")
	g.get_tree().quit(0)
