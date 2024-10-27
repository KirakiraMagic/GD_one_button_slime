extends MeshInstance3D

@onready var player = $Slime

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var mat: ShaderMaterial = get_surface_override_material(0)
	var bodies = get_children()
	var blobs = PackedFloat32Array()
	var p = player.global_position
	blobs.append(p.x)
	blobs.append(p.y)
	blobs.append(p.z)
	blobs.append(0.5)

	if player.is_sticking and player.stick_point:
		p = player.stick_point.global_position
		blobs.append(p.x)
		blobs.append(p.y)
		blobs.append(p.z)
		blobs.append(0.2)
		mat.set_shader_parameter("numBlobs", 2)
	else:
		mat.set_shader_parameter("numBlobs", 1)
	mat.set_shader_parameter("floorHeight", player.floor_pos)
	if player.floor:
		mat.set_shader_parameter("floorStickiness", 0.5)
	else:
		mat.set_shader_parameter("floorStickiness", 0.0)
	mat.set_shader_parameter("blobs", blobs)