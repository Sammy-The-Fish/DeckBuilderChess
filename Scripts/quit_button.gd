extends TextureButton


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pressed.connect(quit);
	pass # Replace with function body.


func quit():
	get_tree().quit()
