extends RefCounted

# Dedicated runner for silent-film intertitle card sequences.

var scene_cards: Array = []
var scene_index: int = 0
var scene_callback: Callable
var ui_manager: RefCounted

func _init(p_ui_manager: RefCounted = null) -> void:
	ui_manager = p_ui_manager

func start(cards: Array, after: Callable) -> void:
	scene_cards = cards
	scene_index = 0
	scene_callback = after
	_draw_card()

func _draw_card() -> void:
	if scene_index >= scene_cards.size():
		finish()
		return
	var card = scene_cards[scene_index]
	if ui_manager:
		ui_manager.render_card(str(card[0]), str(card[1]), scene_index + 1, Callable(self, "next_card"))

func next_card() -> void:
	scene_index += 1
	if scene_index >= scene_cards.size():
		finish()
	else:
		_draw_card()

func finish() -> void:
	var cb = scene_callback
	if ui_manager:
		ui_manager.close_modal()
	if cb.is_valid():
		cb.call()
