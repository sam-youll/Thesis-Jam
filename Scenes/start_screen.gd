extends Node2D

var main_scene = preload("res://Scenes/main.tscn").instantiate()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("hit"):
		for child in get_children():
			child.free()
		get_tree().root.add_child(main_scene)
