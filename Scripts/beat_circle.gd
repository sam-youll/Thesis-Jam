extends Sprite2D

var target_scale: float = 6
enum player {one, two}
var my_player = player.one

signal good_hit
signal ok_hit
signal bad_hit

signal die

var i_am_oldest: bool = false

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
	scale -= Vector2(delta * 3.5, delta * 3.5)
	
	#if modulate.a == .9 and Input.is_action_just_pressed("hit"):
		#print(scale.x)
		#if scale.x > 3:
			#bad_hit.emit()
		#elif scale.x > 2.4:
			#ok_hit.emit()
		#elif scale.x > 1.9:
			#good_hit.emit()
		#else:
			#ok_hit.emit()
	
	if scale.x < 2:
		modulate.a = .8
	if scale.x < 1.8:
		bad_hit.emit()
		free()
		
func set_player(player: int) -> void:
	my_player = player
