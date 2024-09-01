extends Node
@onready var label: Label = $Label
@onready var beat_label: Label = $BeatLabel
@onready var event_emitter: FmodEventEmitter2D = $PlayerOneEventEmitter
@onready var player_two_event_emitter: FmodEventEmitter2D = $PlayerTwoEventEmitter
@onready var backing_track_emitter: FmodEventEmitter2D = $BackingTrackEmitter
@onready var timer: Timer = $BeatTimer
@onready var transition_timer: Timer = $TransitionTimer

enum Turn 
{
	PLAYER_ONE,
	PLAYER_TWO
}
var turn: Turn = Turn.PLAYER_ONE

enum State
{
	NONE,
	TEST,
	GOTORECORD,
	RECORD,
	READY,
	GOTOPLAYBACK,
	PLAYBACK
}
var state: State = State.NONE

var beat: int = 0
var beat_time: float = 0
var recording_timer: float = 0
var beats_left: int = 16

var chord_bars: int = 0
var chord: int = 0

var test_beatmap = [.5,1,.25,.25,.5,1]
var beatmap_index = 0
# array of floats showing time since measure start for each beat
# e.g. index 1 is the first beat, which happened at 1.12
var beatmap = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	backing_track_emitter.play()
	#spawn_circle()
	#timer.start(test_beatmap[beatmap_index])


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("hit"):
		_do_hit()
	# use event_emitter signals to do conductory stuff
	
	beat_time += delta * 2
	
	match turn:
		Turn.PLAYER_ONE:
			label.set_text("PLAYER ONE")
		Turn.PLAYER_TWO:
			label.set_text("PLAYER TWO")
			
	if Input.is_action_just_pressed("record"):
		beatmap = []
		beatmap_index = 0
		beats_left = 16
		timer.stop()
		transition_timer.stop()
		state = State.GOTORECORD
		
	#print(state)
	
	match state:
		State.NONE:
			pass
			
		State.TEST:
			pass
		State.GOTORECORD:
			pass
		State.RECORD:
			beat_label.set_text(str(beats_left))
			recording_timer += delta
			if Input.is_action_just_pressed("hit"):
				beatmap.append(recording_timer)
				recording_timer = 0
				
			if beats_left <= 0:
				state = State.READY
				
		State.READY:
			beat_label.set_text("press space to continue")
			if Input.is_action_just_pressed("hit"):
				state = State.GOTOPLAYBACK
				if turn == Turn.PLAYER_ONE:
					turn = Turn.PLAYER_TWO
				elif turn == Turn.PLAYER_TWO:
					turn = Turn.PLAYER_ONE
				
		State.GOTOPLAYBACK:
			recording_timer = 0
			
		State.PLAYBACK:
			recording_timer += delta
			beat_label.set_text(str(beat))
			if Input.is_action_just_pressed("hit"):
				recording_timer = 0
			pass
			
	#print(recording_timer)

func _do_hit() -> void:
	if state == State.PLAYBACK:
		print(_check_hit(recording_timer))
	if turn == Turn.PLAYER_ONE:
		event_emitter.play()
	elif turn == Turn.PLAYER_TWO:
		player_two_event_emitter.play()
	

func _on_backing_track_emitter_timeline_beat(params: Dictionary) -> void:
	#print("beat" + str(params.beat))
	beat = params.beat
	#spawn_circle()
	beat_time = 0
	
	if beat == 1:
		chord_bars += 1
	if chord_bars == 2:
		chord_bars = 0
		if chord == 0:
			chord = 1
		elif chord == 1:
			chord = 0
		print(chord)
		event_emitter["event_parameter/Chord/value"] = chord
		player_two_event_emitter["event_parameter/Chord/value"] = chord
	
	match state:
		State.GOTORECORD:
			if beat == 1:
				state = State.RECORD
		State.RECORD:
			beats_left -= 1
		State.GOTOPLAYBACK:
			if beat == 1:
				for beat in beatmap:
					beat = quantize(beat)
				state = State.PLAYBACK
				timer.start(beatmap[beatmap_index])
				

func _on_backing_track_emitter_started() -> void:
	print("started")

func spawn_circle():
	var circle_scene = load("res://Scenes/circle.tscn")
	var circle = circle_scene.instantiate()
	circle.set_player(turn)
	add_child(circle)
	
func quantize(val: float) -> float:
	return .125 * round(val * 8)
	
# returns time difference between hit and closest beat in beatmap
func _check_hit(hit_time: float) -> float:
	var num_beats = beatmap.size()
	var beatmap_index_to_check = 0
	var time_total = 0
	for i in num_beats - 1:
		if hit_time > time_total + (beatmap[i+1]-beatmap[i])/2:
			beatmap_index_to_check += 1
			time_total += beatmap[i]
	return abs(beatmap[beatmap_index_to_check]-hit_time)


func _on_timer_timeout() -> void:
	beatmap_index += 1
	if beatmap_index < beatmap.size():
		spawn_circle()
		timer.start(beatmap[beatmap_index])
	else:
		#print("beatmap empty")
		if state == State.RECORD and transition_timer.is_stopped():
			transition_timer.start(4)


func _on_transition_timer_timeout() -> void:
	state = State.NONE
