extends Node
@onready var bank_loader: FmodBankLoader = $FmodBankLoader
@onready var event_emitter: FmodEventEmitter2D = $FmodEventEmitter2D
@onready var label: Label = $Label

enum Turn 
{
	PLAYER_ONE,
	PLAYER_TWO
}
var turn: Turn = Turn.PLAYER_ONE

var beat: float = 0
var timer: float = 0

# array of floats showing time since measure start for each beat
# e.g. index 1 is the first beat, which happened at 1.12
var beatmap = []

# returns time difference between hit and closest beat in beatmap
func _check_hit(hit_time: float) -> float:
	var num_beats = beatmap.size()
	var beatmap_index_to_check = 0
	for i in num_beats - 1:
		if hit_time > beatmap[i] + (beatmap[i+1]-beatmap[i])/2:
			beatmap_index_to_check += 1
	return abs(beatmap[beatmap_index_to_check]-hit_time)
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("hit"):
		_do_hit()
	# use event_emitter signals to do conductory stuff
	
	match turn:
		Turn.PLAYER_ONE:
			label.text = "PLAYER ONE"
		Turn.PLAYER_TWO:
			label.text = "PLAYER TWO"
	
func _on_timeline_beat() -> void:
	pass
	
func _do_hit() -> void:
	event_emitter.event_guid = "rlgkjbnwg"
	event_emitter.play()
