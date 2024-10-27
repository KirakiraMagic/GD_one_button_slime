extends Camera3D

@export var player: NodePath

var offset = Vector3(0, 0, 0)
# Called when the node enters the scene tree for the first time.
func _ready():
	offset = position
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.x = get_node(player).global_position.x + offset.x
	position.z = get_node(player).global_position.z + offset.z
	position.y = lerp (position.y, get_node(player).global_position.y + offset.y, 0.1)
	pass
