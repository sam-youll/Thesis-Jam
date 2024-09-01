extends Sprite2D
@onready var conductor: Node = $Conductor

var target_scale: float = 6
enum player {one, two}
var my_player = player.one

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	scale = Vector2(7.5, 7.5)
	match my_player:
		player.one:
			position = Vector2(410, 338)
		player.two:
			position = Vector2(804, 338)
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	scale -= Vector2(delta * 3.3, delta * 3.3)
	
	if scale.x < 2:
		free()
		
func set_player(player: int) -> void:
	my_player = player
