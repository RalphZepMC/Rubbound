extends Area2D

@export_file("*.tscn") var next_level: String

var activated := false


func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node2D) -> void:
	if activated or not body.is_in_group("player"):
		return

	if next_level.is_empty():
		push_warning("Choose a Next Level for this exit.")
		return

	activated = true
	_change_level.call_deferred()


func _change_level() -> void:
	var error := get_tree().change_scene_to_file(next_level)

	if error != OK:
		activated = false
		push_error("Could not load level: " + next_level)
