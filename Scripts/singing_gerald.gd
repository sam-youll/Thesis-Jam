extends AnimatedSprite2D

var my_scale: float = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("hit") and get_scale() == Vector2(1,1):
		my_scale = 2
		
	if my_scale > 1:
		my_scale -= .1
		
	scale = (Vector2(my_scale, my_scale))




func _on_player_event_emitter_started() -> void:
	frame = 1


func _on_player_event_emitter_stopped() -> void:
	frame = 0
