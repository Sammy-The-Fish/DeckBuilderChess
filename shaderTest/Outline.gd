extends Sprite2D
@onready var shader = preload("res://new_shader.gdshader");

##func _ready() -> void:
##	apply_shader();
##	pass # Replace with function body.

func apply_shader() -> void:
	var mat = ShaderMaterial.new();
	mat.shader = shader;
	material = mat;
	pass
