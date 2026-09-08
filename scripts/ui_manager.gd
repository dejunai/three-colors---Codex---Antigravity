extends RefCounted

# Dedicated UIManager managing all 2D menus, modals, cards, HUD prompts, and toasts.

const INK = Color("111615")
const PAPER = Color("d6d2bd")
const MUTED = Color("a6aa9b")

var root_node: Node
var serif: SystemFont
var sans: SystemFont
var ui_layer: CanvasLayer
var ui: Control
var modal: Control
var content: VBoxContainer
var prompt: Label
var location_label: Label
var toast_label: Label

var page: String = "title"
var toast_time: float = 0.0
var location_time: float = 0.0
var settings_ref: Dictionary

func _init(p_root: Node, p_settings: Dictionary) -> void:
	root_node = p_root
	settings_ref = p_settings
	serif = SystemFont.new()
	serif.font_names = PackedStringArray(["Georgia","Times New Roman"])
	sans = SystemFont.new()
	sans.font_names = PackedStringArray(["Segoe UI","Arial"])
	_build_canvas()

func _build_canvas() -> void:
	ui_layer = CanvasLayer.new()
	ui_layer.layer = 30
	root_node.add_child(ui_layer)

	ui = Control.new()
	ui.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	ui.mouse_filter = Control.MOUSE_FILTER_IGNORE
	ui_layer.add_child(ui)

	prompt = label("", 22, false)
	prompt.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	prompt.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_WIDE)
	prompt.offset_top = -96
	prompt.offset_bottom = -52
	ui.add_child(prompt)

	location_label = label("", 22, false)
	location_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	location_label.set_anchors_and_offsets_preset(Control.PRESET_TOP_WIDE)
	location_label.offset_top = 70
	location_label.offset_bottom = 145
	ui.add_child(location_label)

	toast_label = label("", 19, false)
	toast_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	toast_label.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_WIDE)
	toast_label.offset_top = -153
	toast_label.offset_bottom = -105
	ui.add_child(toast_label)

func update_timers(delta: float) -> void:
	toast_time = maxf(0, toast_time - delta)
	toast_label.modulate.a = minf(1, toast_time)
	location_time = maxf(0, location_time - delta)
	location_label.modulate.a = minf(1, location_time)

func label(text: String, size: int = 24, literary: bool = true) -> Label:
	var l = Label.new()
	l.text = text
	l.add_theme_font_override("font", serif if literary else sans)
	var scale = float(settings_ref.get("text_scale", 1.0))
	l.add_theme_font_size_override("font_size", int(size * scale))
	l.add_theme_color_override("font_color", PAPER)
	l.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	l.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return l

func style(bg: Color, border: Color = Color("626d5b")) -> StyleBoxFlat:
	var s = StyleBoxFlat.new()
	s.bg_color = bg
	s.border_color = border
	s.set_border_width_all(1)
	s.content_margin_left = 20
	s.content_margin_right = 20
	s.content_margin_top = 12
	s.content_margin_bottom = 12
	return s

func button(text: String, callback: Callable, parent: Node = null) -> Button:
	var b = Button.new()
	b.text = text
	b.custom_minimum_size.y = 48
	b.add_theme_font_override("font", sans)
	var scale = float(settings_ref.get("text_scale", 1.0))
	b.add_theme_font_size_override("font_size", int(18 * scale))
	b.add_theme_color_override("font_color", PAPER)
	b.add_theme_color_override("font_hover_color", Color.WHITE)
	b.add_theme_stylebox_override("normal", style(Color("18201b")))
	b.add_theme_stylebox_override("hover", style(Color("303a2e"), PAPER))
	b.add_theme_stylebox_override("pressed", style(Color("3d4938"), PAPER))
	b.add_theme_stylebox_override("focus", style(Color(0,0,0,0), PAPER))
	b.pressed.connect(callback)
	if parent == null:
		if content != null: content.add_child(b)
	else:
		parent.add_child(b)
	return b

func open_panel(kind: String, heading: String, kicker: String = "", wide: bool = false) -> void:
	if is_instance_valid(modal):
		ui.remove_child(modal)
		modal.queue_free()
	page = kind
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	modal = Control.new()
	modal.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	ui.add_child(modal)

	var dark = ColorRect.new()
	dark.color = Color(0.025, 0.035, 0.03, 0.9 if kind == "dialogue" else 0.84)
	dark.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	modal.add_child(dark)

	var panel_box = PanelContainer.new()
	panel_box.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	panel_box.offset_left = 170 if wide else 320
	panel_box.offset_right = -170 if wide else -320
	panel_box.offset_top = 150 if kind == "dialogue" else 60
	panel_box.offset_bottom = -150 if kind == "dialogue" else -60
	panel_box.add_theme_stylebox_override("panel", style(Color("111914"), Color("727b66")))
	modal.add_child(panel_box)

	var scroll = ScrollContainer.new()
	panel_box.add_child(scroll)

	content = VBoxContainer.new()
	content.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	content.add_theme_constant_override("separation", 18)
	scroll.add_child(content)

	if not kicker.is_empty():
		var k = label(kicker, 13, false)
		k.add_theme_color_override("font_color", MUTED)
		content.add_child(k)

	content.add_child(label(heading, 38))
	content.add_child(HSeparator.new())

	prompt.visible = false
	toast_label.visible = false
	location_label.visible = false

func paragraph(text: String, size: int = 23) -> void:
	if content: content.add_child(label(text, size))

func focus_first() -> void:
	if content == null: return
	for b in content.find_children("*", "Button", true, false):
		if not b.disabled:
			b.grab_focus()
			return

func close_modal() -> void:
	if is_instance_valid(modal):
		modal.queue_free()
	modal = null
	page = "play"
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	prompt.visible = true
	toast_label.visible = true
	location_label.visible = true

func toast(text: String, duration: float = 4.0) -> void:
	toast_label.text = text
	toast_time = duration

func show_location(text: String, sub: String = "BEFORE DAWN") -> void:
	location_label.text = text + "\n—  " + sub + "  —"
	location_time = 4.0

func set_prompt(text: String) -> void:
	prompt.text = text

func render_card(heading: String, text: String, card_index: int, on_continue: Callable) -> void:
	open_panel("dialogue", heading, "NO EXIT WOUND  /  %02d" % card_index)
	paragraph(text, 27)
	var space = Control.new()
	space.custom_minimum_size.y = 30
	content.add_child(space)
	button("Continue", on_continue)
	for child in content.get_children():
		if child is Label: child.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	focus_first()
