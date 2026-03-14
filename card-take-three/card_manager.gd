extends Node2D

const collisionMaskCard = 1

var cardBeingDragged
var screenSize

func _ready() -> void:
	screenSize = get_viewport_rect().size

func _process(delta: float) -> void:
	if cardBeingDragged:
		var mousePosition = get_global_mouse_position()
		cardBeingDragged.position = Vector2(clamp(mousePosition.x, 0, screenSize.x), clamp(mousePosition.y, 0, screenSize.y))
		


func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed():
			var card = checkForCard()
			if card:
				cardBeingDragged = card
		else:
				cardBeingDragged = null



func checkForCard():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = collisionMaskCard
	var result = space_state.intersect_point(parameters)
	if result.size() > 0:
		return result[0].collider.get_parent()
	return null
	
	
	
	

# Called when the node enters the scene tree for the first time.





# Called every frame. 'delta' is the elapsed time since the previous frame.
