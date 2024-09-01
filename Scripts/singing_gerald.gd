extends AnimatedSprite2D

var my_scale: float = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
		
	if my_scale > 1:
		my_scale -= .1
		
	scale = (Vector2(my_scale, my_scale))


func _on_player_one_event_emitter_started() -> void:
	my_scale = 2
	frame = 1


func _on_player_one_event_emitter_stopped() -> void:
	frame = 0


func _on_player_one_event_emitter_restarted() -> void:
	my_scale = 2
