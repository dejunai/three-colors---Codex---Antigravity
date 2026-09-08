extends Node3D

# The Subterranean Descent — Cellar Passage, Fissure Ledge, & Sea Cave beneath the Ophion Club House.
# Procedurally generated 3D blockout following estate.gd, town.gd, and club.gd conventions.

var mats = {}
var points = {}
var colliders: Array[Rect2] = []

func mat(c: String, glow: bool = false) -> StandardMaterial3D:
	var key = c + str(glow)
	if mats.has(key): return mats[key]
	var m = StandardMaterial3D.new()
	m.albedo_color = Color(c)
	m.roughness = 0.92
	if glow:
		m.emission_enabled = true
		m.emission = Color(c)
		m.emission_energy_multiplier = 0.6
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

func lantern(pos: Vector3, light_color: String = "d4a86a", energy: float = 1.6, range_m: float = 6.5) -> void:
	cylinder(self, pos + Vector3.UP * 0.2, 0.08, 0.4, "25221d")
	box(self, pos + Vector3.UP * 0.45, Vector3(0.24, 0.32, 0.24), "9e947d")
	var light = OmniLight3D.new()
	light.position = pos + Vector3.UP * 0.45
	light.light_color = Color(light_color)
	light.light_energy = energy
	light.omni_range = range_m
	add_child(light)

func target(id: String, title: String, pos: Vector3) -> void:
	points[id] = {"title": title, "pos": pos}

func _init() -> void:
	_build_subterranean()

func _build_subterranean() -> void:
	# Subterranean dark coastal environment
	var we = WorldEnvironment.new()
	var env = Environment.new()
	env.background_mode = Environment.BG_COLOR
	env.background_color = Color("05070a")
	env.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	env.ambient_light_color = Color("0f1318")
	env.fog_enabled = true
	env.fog_light_color = Color("141c22")
	env.fog_density = 0.024
	we.environment = env
	add_child(we)

	# --- 1. THE STAIRWELL LANDING (Z: 14 to 22, X: -3 to 3) ---
	# Floor (Solid)
	box(self, Vector3(0, -0.3, 18), Vector3(6, 0.5, 9), "181c1f", true)
	# Ceiling
	box(self, Vector3(0, 3.8, 18), Vector3(6, 0.3, 9), "121417")
	# Walls
	box(self, Vector3(-3.2, 1.8, 18), Vector3(0.5, 3.8, 9), "1c2024", true)
	box(self, Vector3(3.2, 1.8, 18), Vector3(0.5, 3.8, 9), "1c2024", true)
	box(self, Vector3(0, 1.8, 22.3), Vector3(6, 3.8, 0.6), "1c2024", true) # Back wall
	# Stepped stone blocks representing ascending stairs
	for i in 4:
		var step_z = 21.0 - i * 0.7
		var step_y = 0.15 + i * 0.3
		box(self, Vector3(0, step_y, step_z), Vector3(3.5, 0.3, 0.7), "252a2e")
	target("stair_exit", "Ascend the stone stair to the club pantry", Vector3(0, 0.1, 20.0))
	lantern(Vector3(-2.4, 1.4, 16.5))

	# --- 2. UPPER SHORED PASSAGE (Z: 0 to 14, X: -3.5 to 3.5) ---
	# Floor (Solid)
	box(self, Vector3(0, -0.3, 7), Vector3(7, 0.5, 15), "181b1e", true)
	# Ceiling
	box(self, Vector3(0, 3.6, 7), Vector3(7, 0.3, 15), "121417")
	# Rock Walls
	box(self, Vector3(-3.2, 1.8, 7), Vector3(0.5, 3.8, 15), "1b1f22", true)
	box(self, Vector3(3.2, 1.8, 7), Vector3(0.5, 3.8, 15), "1b1f22", true)
	# Timber Shoring Arches (Ribs)
	for r_z in [12.0, 8.0, 4.0, 0.5]:
		box(self, Vector3(-2.8, 1.7, r_z), Vector3(0.25, 3.4, 0.3), "382c22") # Left post
		box(self, Vector3(2.8, 1.7, r_z), Vector3(0.25, 3.4, 0.3), "382c22")  # Right post
		box(self, Vector3(0, 3.3, r_z), Vector3(5.8, 0.3, 0.35), "382c22")    # Crossbeam
	lantern(Vector3(2.6, 1.5, 8.0))

	# --- 3. SILT ALCOVE & PATROL GALLERY (Z: -14 to 0, X: -6 to 6) ---
	# Floor (Solid)
	box(self, Vector3(0, -0.3, -7), Vector3(12, 0.5, 15), "16191c", true)
	# Ceiling
	box(self, Vector3(0, 3.9, -7), Vector3(12, 0.3, 15), "101214")
	# Outer Rock Walls
	box(self, Vector3(-5.8, 1.8, -7), Vector3(0.6, 3.8, 15), "191d20", true)
	box(self, Vector3(5.8, 1.8, -7), Vector3(0.6, 3.8, 15), "191d20", true)
	# Central Stone Support Pillars (forming left/right navigation alcoves)
	box(self, Vector3(-2.2, 1.8, -6.5), Vector3(1.0, 3.6, 1.2), "202428", true)
	box(self, Vector3(2.2, 1.8, -6.5), Vector3(1.0, 3.6, 1.2), "202428", true)

	# Silt bank along West wall where Patrolman Thomas's whistle lies
	box(self, Vector3(-4.5, 0.08, -6.5), Vector3(2.0, 0.16, 3.5), "545044") # Dry silt mound
	cylinder(self, Vector3(-4.2, 0.18, -6.5), 0.08, 0.18, "72947d")       # Corroded brass whistle
	target("whistle", "Examine the silt alcove", Vector3(-3.5, 0.1, -6.5))
	lantern(Vector3(-5.0, 1.3, -4.5))

	# Mineral fracture along East wall with impossible violet-blue glint
	box(self, Vector3(5.2, 1.6, -10.0), Vector3(0.2, 2.2, 3.0), "1e2328")
	box(self, Vector3(5.25, 1.6, -10.0), Vector3(0.08, 1.6, 1.8), "4d446b", true) # Violet-blue vein
	target("strata", "Inspect the mineral fracture", Vector3(3.8, 0.1, -10.0))
	lantern(Vector3(5.0, 1.4, -12.0), "a88ed4", 1.8, 5.0)

	# --- 4. THE CHASM LEDGE & FISSURE (Z: -24 to -14, X: -4 to 4) ---
	# Ledge Floor (Solid, narrower pathway hugging the east rock)
	box(self, Vector3(0.5, -0.3, -19), Vector3(5.0, 0.5, 11), "15181b", true)
	# Ceiling
	box(self, Vector3(0, 4.2, -19), Vector3(8.0, 0.3, 11), "0e1012")
	# East Rock Wall
	box(self, Vector3(3.2, 2.0, -19), Vector3(0.6, 4.2, 11), "191d20", true)
	# West Abyss / Chasm (Black crevasse where water sounds churn below)
	box(self, Vector3(-2.8, -2.5, -19), Vector3(3.5, 4.0, 11), "06080a") # Deep drop
	# Broken timber guardrail along ledge
	for gr_z in [-15.5, -18.5, -21.5]:
		cylinder(self, Vector3(-1.4, 0.45, gr_z), 0.06, 0.9, "32261c")
	box(self, Vector3(-1.4, 0.8, -18.5), Vector3(0.08, 0.1, 6.0), "32261c")
	# The treacherous point where the seam yields and the flask tears loose
	target("fissure", "Step to the narrow chasm ledge", Vector3(-0.5, 0.1, -18.5))
	lantern(Vector3(2.6, 1.5, -18.5))

	# --- 5. THE SEA CAVE & SEA-GATE CHAMBER (Z: -38 to -24, X: -9 to 9) ---
	# Large cavern floor (Solid)
	box(self, Vector3(0, -0.3, -31), Vector3(18, 0.5, 15), "16191d", true)
	# High vaulted cavern ceiling
	box(self, Vector3(0, 5.2, -31), Vector3(18, 0.4, 15), "0c0e10")
	# Cavern perimeter rock walls
	box(self, Vector3(-8.8, 2.5, -31), Vector3(0.8, 5.2, 15), "171b1f", true)
	box(self, Vector3(8.8, 2.5, -31), Vector3(0.8, 5.2, 15), "171b1f", true)

	# Central Ancient Stone Plinth with ritual basins and silver implements
	box(self, Vector3(0, 0.55, -29.0), Vector3(3.4, 1.1, 2.4), "2b2e32") # Dressed granite block
	# Six shallow bronze basins in a circle
	for i in 6:
		var rad = i * (PI / 3.0)
		var bx = sin(rad) * 1.05
		var bz = cos(rad) * 0.75
		cylinder(self, Vector3(bx, 1.12, -29.0 + bz), 0.22, 0.06, "695a3d")
	# Velvet cloth roll with six hollow silver needles in center
	box(self, Vector3(0, 1.12, -29.0), Vector3(0.6, 0.04, 0.4), "1c1724")
	for n_i in [-0.15, -0.09, -0.03, 0.03, 0.09, 0.15]:
		cylinder(self, Vector3(n_i, 1.15, -29.0), 0.015, 0.32, "d8dbdb", 0.005).rotation.x = PI / 2.0
	target("plinth", "Examine the stone plinth and implements", Vector3(0, 0.1, -27.5))
	lantern(Vector3(-1.8, 1.6, -29.0))
	lantern(Vector3(1.8, 1.6, -29.0))

	# The Subterranean Sea-Gate Arch (North cavern wall)
	box(self, Vector3(-5.5, 2.5, -38.0), Vector3(7.0, 5.2, 0.8), "171a1d", true)
	box(self, Vector3(5.5, 2.5, -38.0), Vector3(7.0, 5.2, 0.8), "171a1d", true)
	# Cyclopean arch beam over the water opening
	box(self, Vector3(0, 4.2, -38.0), Vector3(5.0, 1.8, 1.2), "22272b", true)
	# Seawater slip basin opening to ocean tide
	box(self, Vector3(0, -0.2, -37.5), Vector3(4.2, 0.3, 2.5), "182c33")
	# Iron mooring ringbolts in stone
	cylinder(self, Vector3(-2.2, 0.4, -36.5), 0.08, 0.12, "4a4d50")
	cylinder(self, Vector3(2.2, 0.4, -36.5), 0.08, 0.12, "4a4d50")
	target("sea_gate", "Observe the subterranean sea gate", Vector3(0, 0.1, -35.5))
	lantern(Vector3(0, 2.8, -36.8), "5a8ba6", 2.2, 8.0) # Cold sea-light from open bay
