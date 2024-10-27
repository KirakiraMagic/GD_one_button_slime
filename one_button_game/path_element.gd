extends PathFollow3D

@export var speed = 0.5
var direction = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	progress_ratio += direction * delta * speed
	if progress_ratio >= 1.0 or progress_ratio <= 0.0:
		direction *= -1
	pass
