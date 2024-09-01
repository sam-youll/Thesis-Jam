extends Sprite2D

var target_scale: float = 6

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	scale = Vector2(7.5, 7.5)
	position = Vector2(410, 338)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	scale -= Vector2(delta * 3.3, delta * 3.3)
	
	if scale.x < 2:
		free()
