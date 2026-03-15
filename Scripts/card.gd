extends Node2D

signal clicked(id: Cards.CARDS, this)

var cardPositionInHand
var id: Cards.CARDS;
var isClicked: bool = false
var hovered = false
@onready var image = $cardImage



func onClicked():
	isClicked = true
	clicked.emit(id, self)
	
	
func unselect():
	isClicked = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	scale = Vector2(1, 1)
	if hovered:
		scale = Vector2(1.1, 1.1)
		if Input.is_action_just_pressed("clicked"):
			onClicked()
		
	if isClicked:
		scale = Vector2(1.25, 1.25)


func _on_area_2d_mouse_entered() -> void:
	hovered = true
	


func _on_area_2d_mouse_exited() -> void:
	hovered = false
	
