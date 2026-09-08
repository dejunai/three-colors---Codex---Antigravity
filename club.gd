extends Node3D

# The Ophion Club House — Interior Architecture & Interactivity.
# Procedurally generated 3D blockout following estate.gd and town.gd conventions.

var mats = {}
var points = {}
var colliders: Array[Rect2] = []

func mat(c: String, glow: bool = false) -> StandardMaterial3D:
	var key = c + str(glow)
	if mats.has(key): return mats[key]
	var m = StandardMaterial3D.new()
	m.albedo_color = Color(c)
	m.roughness = 0.88
	if glow:
		m.emission_enabled = true
		m.emission = Color(c)
		m.emission_energy_multiplier = 0.5
	mats[key] = m
	return m

func mesh_at(parent: Node3D, mesh: Mesh, pos: Vector3, c: String, glow: bool = false) -> MeshInstance3D:
	var n = MeshInstance3D.new()
	n.mesh = mesh
	n.position = pos
	n.material_override = mat(c, glow)
	parent.add_child(n)
	return n

func box(parent: Node3D, pos: Vector3, size: Vector3, c: String, solid: bool = false) -> MeshInstance3D:
	var m = BoxMesh.new()
	m.size = size
	var n = mesh_at(parent, m, pos, c)
	if solid:
		var body = StaticBody3D.new()
		var shape = BoxShape3D.new()
		shape.size = size
		var col = CollisionShape3D.new()
		col.shape = shape
		n.add_child(body)
		body.add_child(col)
		if parent == self and pos.y > 0.1:
			colliders.append(Rect2(Vector2(pos.x - size.x/2, pos.z - size.z/2), Vector2(size.x, size.z)))
	return n

func cylinder(parent: Node3D, pos: Vector3, radius: float, height: float, c: String, top: float = -1.0) -> MeshInstance3D:
	var m = CylinderMesh.new()
	m.bottom_radius = radius
	m.top_radius = radius if top < 0 else top
	m.height = height
	m.radial_segments = 10
	return mesh_at(parent, m, pos, c)

func person(pos: Vector3, coat: String = "353838", hat: bool = true) -> Node3D:
	var root = Node3D.new()
	root.position = pos
	add_child(root)
	cylinder(root, Vector3(0, 1.08, 0), 0.32, 0.85, coat, 0.24).name = "Coat"
	box(root, Vector3(0, 1.48, 0), Vector3(0.52, 0.27, 0.32), coat)
	cylinder(root, Vector3(0, 1.78, 0), 0.15, 0.3, "a0a095", 0.17)
	box(root, Vector3(0, 1.38, -0.18), Vector3(0.08, 0.24, 0.025), "b9b8ac")
	for side in [-1, 1]:
		var leg = Node3D.new()
		leg.name = "LeftLeg" if side == -1 else "RightLeg"
		leg.position = Vector3(side * 0.14, 0.76, 0)
		root.add_child(leg)
		box(leg, Vector3(0, -0.38, 0), Vector3(0.16, 0.76, 0.2), "26292b")
		var arm = Node3D.new()
		arm.name = "LeftArm" if side == -1 else "RightArm"
		arm.position = Vector3(side * 0.32, 1.45, 0)
		root.add_child(arm)
		box(arm, Vector3(0, -0.35, 0), Vector3(0.14, 0.7, 0.16), coat)
	if hat:
		cylinder(root, Vector3(0, 1.94, 0), 0.3, 0.05, "242728")
		cylinder(root, Vector3(0, 2.06, 0), 0.18, 0.2, "242728")
	return root

func lamp(pos: Vector3, tall: bool = true) -> void:
	var h = 3.6 if tall else 1.7
	cylinder(self, pos + Vector3.UP * h * 0.45, 0.08, h * 0.9, "242626")
	box(self, pos + Vector3.UP * h, Vector3(0.42, 0.55, 0.42), "aaa99d")
	var light = OmniLight3D.new()
	light.position = pos + Vector3.UP * (h - 0.1)
	light.light_color = Color("eeeee2")
	light.light_energy = 2.0
	light.omni_range = 7.5
	add_child(light)

func target(id: String, title: String, pos: Vector3) -> void:
	points[id] = {"title": title, "pos": pos}

func _init() -> void:
	_build_club()

func _build_club() -> void:
	# Floor & Ceiling for entire ground floor
	box(self, Vector3(0, -0.3, 0), Vector3(44, 0.5, 40), "222625", true)
	box(self, Vector3(0, 4.4, 0), Vector3(44, 0.2, 40), "1a1d1c")

	# Exterior Perimeter Walls
	box(self, Vector3(0, 2.2, 18.5), Vector3(44, 4.4, 0.8), "2b2d2d", true) # South
	box(self, Vector3(0, 2.2, -18.5), Vector3(44, 4.4, 0.8), "2b2d2d", true) # North
	box(self, Vector3(-21.5, 2.2, 0), Vector3(0.8, 4.4, 38), "2b2d2d", true) # West
	box(self, Vector3(21.5, 2.2, 0), Vector3(0.8, 4.4, 38), "2b2d2d", true) # East

	# Interior Dividing Walls
	# West wall separating Fenn's Study from Foyer & Lounge (X = -7)
	box(self, Vector3(-7, 2.2, 14.5), Vector3(0.6, 4.4, 7), "2b2826", true) # Z: 11 to 18
	box(self, Vector3(-7, 2.2, 0.5), Vector3(0.6, 4.4, 11), "2b2826", true)  # Z: -5 to 6
	# Archway between Z = 6 and Z = 11 is wide open (5m archway)

	# East wall separating Banquet Room from Foyer & Lounge (X = 7)
	box(self, Vector3(7, 2.2, 14.5), Vector3(0.6, 4.4, 7), "2b2826", true) # Z: 11 to 18
	box(self, Vector3(7, 2.2, 0.5), Vector3(0.6, 4.4, 11), "2b2826", true)  # Z: -5 to 6
	# Archway between Z = 6 and Z = 11 is wide open (5m archway)

	# North dividing wall separating Grand Lounge from Kitchen Wing (Z = -5)
	box(self, Vector3(-3.5, 2.2, -5), Vector3(7, 4.4, 0.6), "282a29", true)  # X: -7 to 0
	box(self, Vector3(4.5, 2.2, -5), Vector3(3, 4.4, 0.6), "282a29", true)   # X: 3 to 6
	# Service doorway between X = 0 and X = 3 at Z = -5

	# Wall separating Kitchen from Pantry (X = -4, Z: -5 to -18)
	box(self, Vector3(-4, 2.2, -6.0), Vector3(0.6, 4.4, 2), "282a29", true)  # Z: -5 to -7
	box(self, Vector3(-4, 2.2, -14.5), Vector3(0.6, 4.4, 7), "282a29", true) # Z: -11 to -18
	# Pantry doorway between Z = -7 and Z = -11 (4m opening)

	# --- FOYER (Z: 10 to 18, X: -6 to 6) ---
	# Entrance Doors (to Estate / Town)
	box(self, Vector3(0, 1.5, 18.0), Vector3(2.4, 3.0, 0.2), "1e1a17")
	target("club_exit", "Leave the Ophion Club", Vector3(0, 0.1, 17.0))
	lamp(Vector3(-3.5, 0.1, 14.0), false)
	lamp(Vector3(3.5, 0.1, 14.0), false)

	# --- GRAND LOUNGE & BAR (Z: -5 to 10, X: -6 to 6) ---
	# Mahogany Bar Counter along west side of lounge
	box(self, Vector3(-4.5, 0.6, 2.5), Vector3(1.2, 1.2, 10.0), "3d271d", true)
	box(self, Vector3(-4.5, 1.25, 2.5), Vector3(1.6, 0.1, 10.4), "2b1a13")
	# Shelves behind bar with liquor bottles
	box(self, Vector3(-6.6, 2.0, 2.5), Vector3(0.4, 2.2, 9.0), "241710", true)
	for b_z in [-1.5, 0.5, 2.5, 4.5, 6.0]:
		cylinder(self, Vector3(-6.4, 1.6, b_z), 0.08, 0.35, "4a5943")
		cylinder(self, Vector3(-6.4, 2.3, b_z), 0.08, 0.35, "6e4c36")
	# Stools in front of the bar
	for s_z in [-1.0, 1.5, 4.0, 6.5]:
		cylinder(self, Vector3(-3.2, 0.45, s_z), 0.24, 0.9, "1f1712")
		cylinder(self, Vector3(-3.2, 0.85, s_z), 0.28, 0.1, "472619")

	# Barman NPC standing behind the counter
	var barman_npc = person(Vector3(-5.5, 0.1, 2.5), "2a2d2e", false)
	barman_npc.name = "BarmanNPC"
	target("barman", "Speak to the club barman", Vector3(-3.4, 0.1, 2.5))

	# Lounge seating on East side
	box(self, Vector3(3.5, 0.4, 2.0), Vector3(2.2, 0.8, 2.2), "36221c", true) # Leather armchair
	box(self, Vector3(3.5, 0.4, 6.0), Vector3(2.2, 0.8, 2.2), "36221c", true)
	lamp(Vector3(0, 0.1, 2.0), true)

	# --- BANQUET ROOM (Z: 0 to 17, X: 7 to 21) ---
	# Long dining table
	box(self, Vector3(14.0, 0.78, 8.5), Vector3(3.2, 0.08, 9.0), "3b2318")
	for t_leg in [Vector3(12.8, 0.38, 4.5), Vector3(15.2, 0.38, 4.5), Vector3(12.8, 0.38, 12.5), Vector3(15.2, 0.38, 12.5)]:
		cylinder(self, t_leg, 0.12, 0.76, "2b1810")
	# Seven chairs: 3 on west, 3 on east, 1 at head (Z = 3.5)
	for i in 3:
		var cz = 5.5 + i * 2.5
		box(self, Vector3(12.0, 0.55, cz), Vector3(0.6, 1.1, 0.6), "2b1810") # West chair
		box(self, Vector3(16.0, 0.55, cz), Vector3(0.6, 1.1, 0.6), "2b1810") # East chair
	box(self, Vector3(14.0, 0.55, 3.5), Vector3(0.6, 1.1, 0.6), "2b1810") # Head chair (empty seventh)
	# Silver plates on table
	for p_z in [5.5, 8.0, 10.5]:
		cylinder(self, Vector3(13.2, 0.84, p_z), 0.22, 0.02, "b4b8b6")
		cylinder(self, Vector3(14.8, 0.84, p_z), 0.22, 0.02, "b4b8b6")
	cylinder(self, Vector3(14.0, 0.84, 4.5), 0.22, 0.02, "b4b8b6") # Seventh plate

	target("linens", "Examine the seven banquet place settings", Vector3(14.0, 0.1, 8.5))

	# Club Steward NPC
	var steward_npc = person(Vector3(14.0, 0.1, 14.5), "242629", false)
	steward_npc.name = "StewardNPC"
	target("steward", "Question the club steward", Vector3(14.0, 0.1, 14.5))
	lamp(Vector3(14.0, 0.1, 8.5), true)

	# --- DR. FENN'S STUDY (Z: 0 to 17, X: -21 to -7) ---
	# Bookshelves along the west wall
	box(self, Vector3(-20.5, 2.1, 8.5), Vector3(0.8, 4.0, 12.0), "241b14", true)
	# Desk and reading lamp
	box(self, Vector3(-14.0, 0.75, 8.5), Vector3(2.4, 0.75, 1.4), "38241a")
	# Open volume on the desk
	box(self, Vector3(-14.0, 0.82, 8.5), Vector3(0.45, 0.04, 0.35), "d1cbb6")
	lamp(Vector3(-14.8, 0.82, 8.8), false)
	target("fenn_study", "Inspect Dr. Fenn's open volume on Ophion", Vector3(-14.0, 0.1, 7.2))

	# --- KITCHEN & SERVICE WING (Z: -18 to -5, X: -4 to 6) ---
	# Iron kitchen stove along north wall
	box(self, Vector3(1.0, 0.9, -17.5), Vector3(4.0, 1.8, 1.2), "1e2120", true)
	box(self, Vector3(3.5, 0.75, -11.0), Vector3(2.2, 0.75, 2.5), "54493e", true) # Prep table along east wall

	# North service window overlooking the rose hedge
	box(self, Vector3(-1.5, 1.8, -18.2), Vector3(2.8, 1.6, 0.1), "6b7673")
	target("kitchen_window", "Observe the grounds crew through the service window", Vector3(-1.5, 0.1, -16.5))

	# --- PANTRY & HIDDEN DESCENT (Z: -18 to -5, X: -21 to -4) ---
	# Stacked crates of pre-war gin
	box(self, Vector3(-10.0, 0.6, -12.0), Vector3(1.4, 1.2, 1.4), "453c30", true)
	box(self, Vector3(-10.0, 0.6, -14.0), Vector3(1.4, 1.2, 1.4), "453c30", true)
	box(self, Vector3(-10.0, 1.7, -13.0), Vector3(1.2, 1.0, 1.2), "453c30", true)

	# Boarded service door
	box(self, Vector3(-16.0, 1.5, -18.0), Vector3(2.0, 3.0, 0.3), "26201b")
	# Narrow stone opening behind crate
	box(self, Vector3(-16.0, 0.2, -18.2), Vector3(1.4, 0.4, 0.8), "141517")
	target("pantry_stair", "Examine the unboarded gap behind the crates", Vector3(-16.0, 0.1, -16.0))
	lamp(Vector3(-10.0, 0.1, -8.0), false)
