extends StaticBody2D
@onready var anim_play = $Button
@export var control_channel: Array[int]


func _ready() -> void:
	anim_play.play("Unpressed")


func _on_detect_crate_body_entered(body: Node2D) -> void:
	if body.is_in_group("Crate"):
		SignalsArray.Activate.emit(control_channel)
		anim_play.play("Pressed")





func _on_detect_crate_body_exited(body: Node2D) -> void:
	if body.is_in_group("Crate"):
		anim_play.play("Unpressed")
		SignalsArray.Deactivate.emit(control_channel)
