extends AnimatableBody2D
@export var speed: float
@export var unactivated_pos: Vector2
@export var activated_pos: Vector2
@export var connect_channel: int
@export_enum("4HighWall", "8HighWall", "12HighWall", "16HighWall", "20HighWall", "4HighDeathWall", "8HighDeathWall", "12HighDeathWall", "16HighDeathWall", "20HighDeathWall") var sprite: String
@export var shape : Shape2D
@export_enum("Wall","Death") var group: String
@export var NumSignalsForActive: int
var number_of_detected_signals = 0
var anim_playing = false

@onready var animation_handler = $AnimationPlayer
@onready var platform_sprite = $AnimatedSprite2D
@onready var collision_shape = $CollisionShape2D

func _ready() -> void:
	self.add_to_group(group)
	global_position = unactivated_pos
	SignalsArray.Activate.connect(activate)
	SignalsArray.Deactivate.connect(deactivate)

	collision_shape.shape = shape
	platform_sprite.animation = sprite
	var move_anim = animation_handler.get_animation("Move")
	var root_track_index = -1
	var shape_track_index = -1
	var sprite_track_index = -1
	animation_handler.speed_scale = speed
	if move_anim:
		for root_pos_track in range(move_anim.get_track_count()): #Looks through the current list of tracks that is in the move animation
			if move_anim.track_get_path(root_pos_track) == NodePath(".:position"): #Specificies what track we are looking for. In this case we are looking for the track that is manipulating the root node's position
				root_track_index = root_pos_track #sets the track index to the specified track

		for sprite_anim_track in range(move_anim.get_track_count()): #Looks through the current list of tracks that is in the move animation
			if move_anim.track_get_path(sprite_anim_track) == NodePath("AnimatedSprite2D:animation"): #Specificies what track we are looking for. In this case we are looking for the track that is manipulating the root node's position
				sprite_track_index = sprite_anim_track #sets the track index to the specified track
		for colsn_shape_track in range(move_anim.get_track_count()): #Looks through the current list of tracks that is in the move animation
			if move_anim.track_get_path(colsn_shape_track) == NodePath("CollisionShape2D:shape"): #Specificies what track we are looking for. In this case we are looking for the track that is manipulating the root node's position
				shape_track_index = colsn_shape_track #sets the track index to the specified track

		if root_track_index != -1: # this just checks to see if we ever found the track that we pointed to at line 14 if not it will just return nothign
			move_anim.track_insert_key(root_track_index, 0.0, unactivated_pos) # Creates a key that begins at the preset starting position
			move_anim.track_insert_key(root_track_index, 1.0, activated_pos) # Creates a key that ends at the preset ending position
		elif root_track_index == -1:
			return

		if sprite_track_index != -1: # this just checks to see if we ever found the track that we pointed to at line 14 if not it will just return nothign
			move_anim.track_insert_key(sprite_track_index, 0.0, platform_sprite.animation) # Creates a key that sets the sprite of the current animation
		elif sprite_track_index == -1:
			return

		if shape_track_index != -1: # this just checks to see if we ever found the track that we pointed to at line 14 if not it will just return nothign
			move_anim.track_insert_key(shape_track_index, 0.0, collision_shape.shape) # Creates a key that sets the collision shape of the current animation
		elif shape_track_index == -1:
			return

func activate(target_channel):
	if connect_channel == target_channel:
		number_of_detected_signals += 1
		if number_of_detected_signals >= NumSignalsForActive:
			animation_handler.play("Move")
		anim_playing = true

func deactivate(target_channel): #ToDo: This is done for the most part now we've got weird behaviors from multiple platforms in terms of animations
	#animation_handler.play("Move")
	if connect_channel == target_channel:
		number_of_detected_signals -= 1
		if number_of_detected_signals < NumSignalsForActive:
			animation_handler.play_backwards("Move")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	anim_playing = false
