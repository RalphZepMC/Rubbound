extends CharacterBody2D

const MAX_SPEED = 400.0
const ACCELERATION = 900.0
const GRAVITY = 1000.0
const JUMP_SPEED = 420.0
const DIVE_GRAVITY_MULTIPLIER = 2.0
const REBOUND_MULTIPLIER = 0.8
const MAX_REBOUNDS = 3
const SLOPE_ACCELERATION = 750.0
const WHEEL_RADIUS = 20.0
@onready var wheel_sprite: Sprite2D = $Sprite2D
var rebound_launch_pending := false

var dive_armed := false
var rebound_count := 0
@export var rebound_label: Label

func _physics_process(delta: float) -> void:
	var direction := Input.get_axis("ui_left", "ui_right")

	var jump_pressed := Input.is_action_just_pressed("ui_accept")
	var grounded := is_on_floor() and not rebound_launch_pending
	rebound_launch_pending = false
	var slope_x := 0.0

	if grounded:
		slope_x = get_floor_normal().x

	if is_zero_approx(direction) and absf(slope_x) > 0.01:
		velocity.x += slope_x * SLOPE_ACCELERATION * delta
		velocity.x = clampf(velocity.x, -MAX_SPEED, MAX_SPEED)
	else:
		velocity.x = move_toward(
			velocity.x, direction * MAX_SPEED, ACCELERATION * delta
		)
	if grounded:
		if jump_pressed:
			velocity.y = -JUMP_SPEED
	else:
		if jump_pressed and rebound_count < MAX_REBOUNDS:
			dive_armed = true

		var gravity := GRAVITY
		if dive_armed and velocity.y >= 0.0:
			gravity *= DIVE_GRAVITY_MULTIPLIER
		velocity.y += gravity * delta
	# Follow the current slope unless we just pressed jump.
	if grounded and not jump_pressed:
		var floor_normal := get_floor_normal()
		velocity.y = -velocity.x * floor_normal.x / floor_normal.y

	var impact_speed := velocity.y
	move_and_slide()
	if is_on_floor():
		var normal := get_floor_normal()
		var floor_direction := Vector2(-normal.y, normal.x)
		var distance_rolled := get_position_delta().dot(floor_direction)
		wheel_sprite.rotation += distance_rolled / WHEEL_RADIUS

	if is_on_floor():
		if dive_armed and impact_speed > 0.0:
			velocity.y = -impact_speed * REBOUND_MULTIPLIER
			rebound_launch_pending = true
			rebound_count += 1
		else:
			rebound_count = 0

		dive_armed = false
		_update_rebound_label()

		dive_armed = false
		_update_rebound_label()
func _ready() -> void:
	_update_rebound_label()

func _update_rebound_label() -> void:
	var filled := "☐".repeat(rebound_count)
	var empty := "■".repeat(MAX_REBOUNDS - rebound_count)
	rebound_label.text = "Rebounds: " + empty + filled
