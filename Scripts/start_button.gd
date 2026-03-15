extends TextureButton

@onready var menuScene = await("res://src/Drafting/drafting_control.tscn")

func _ready() -> void:
	pressed.connect(set_scene);


func set_scene():
	get_tree().change_scene_to_file(menuScene);
