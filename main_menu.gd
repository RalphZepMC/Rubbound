extends Control

@export_file("*.tscn") var first_level: String

var starting := false


func _input(event: InputEvent) -> void:
	if starting:
		return

	# Accept keyboard keys, mouse buttons, and controller buttons.
	var button_event := (
		event is InputEventKey
		or event is InputEventMouseButton
		or event is InputEventJoypadButton
	)

	if not button_event:
		return

	# Ignore releases and repeated events from holding a key.
	if not event.is_pressed() or event.is_echo():
		return

	if first_level.is_empty():
		push_warning("Choose a First Level in the menu Inspector.")
		return

	starting = true
	get_viewport().set_input_as_handled()
	_start_game.call_deferred()


func _start_game() -> void:
	var error := get_tree().change_scene_to_file(first_level)

	if error != OK:
		starting = false
		push_error("Could not load level: " + first_level)
