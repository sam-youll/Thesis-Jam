extends Sprite2D
var my_scale: float = 1
var timer: float = 0
var timer2: float = 0
var bpm: int = 120
var mimic: bool = false
@onready var beat_label: Label = $"../BeatLabel"

var beatmap = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("hit") and get_scale() == Vector2(1,1):
		my_scale = 2
		beatmap.append(timer)
		timer = 0
		
	timer += delta
	timer2 += delta
	
	if timer2/60*bpm >= 8:
		timer2 = 0
	
	if my_scale > 1:
		my_scale -= .1
		
	scale = (Vector2(my_scale, my_scale))
	
		
	beat_label.text = str(int(timer2/60*bpm)+1) + "/8"
