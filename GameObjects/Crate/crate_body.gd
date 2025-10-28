extends CharacterBody2D
@export var gravity = 7
@export var friction = 0.2
@export var saved_pos: Vector2

func _ready() -> void:
	saved_pos = global_position
	SignalsArray.checkpoint.connect(set_saved_pos)
	SignalsArray.load_checkpoint.connect(load_saved_pos)

func apply_gravity():
	if is_on_floor() == false:
		velocity.y += gravity

func apply_friction():
	if is_on_floor() == true:
		velocity.x = lerp(velocity.x, 0.0, friction)

func set_saved_pos(chk_pos):
	print("crate position saved")
	saved_pos = global_position

func load_saved_pos():
	print("crate position loaded")
	global_position = saved_pos

func _physics_process(delta: float) -> void:
	apply_friction()
	apply_gravity()
	move_and_slide()
