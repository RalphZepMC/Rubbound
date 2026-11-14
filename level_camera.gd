extends Camera2D

@export var wheel: Node2D
@export var look_ahead: float = 160.0

func _process(_delta: float) -> void:
	global_position.x = wheel.global_position.x + look_ahead
