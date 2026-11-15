extends ProgressBar


func _ready() -> void:
	min_value = -80.0
	max_value = 0.0
	show_percentage = false
	print("Audio driver: ", AudioServer.get_driver_name())


func _process(_delta: float) -> void:
	var left := AudioServer.get_bus_peak_volume_left_db(0, 0)
	var right := AudioServer.get_bus_peak_volume_right_db(0, 0)

	value = maxf(left, right)
