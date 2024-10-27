extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	#pause scene
	get_tree().paused = true
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		visible = false
		get_tree().paused = false
	pass
