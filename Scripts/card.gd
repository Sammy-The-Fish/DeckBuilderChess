extends Node2D

signal hovered
signal hoveredOff

var cardPositionInHand


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	get_parent().connectCardSignals(self)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_mouse_entered() -> void:
	emit_signal("hovered", self)


func _on_area_2d_mouse_exited() -> void:
	emit_signal("hoveredOff", self)
