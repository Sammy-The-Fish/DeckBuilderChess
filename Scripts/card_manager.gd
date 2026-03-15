extends Node2D

const collisionMaskCard = 1

signal card_selected(id: Cards.CARDS)

var cardBeingDragged
var screenSize
var isHoveringOnCard

@onready var cardScene = preload("res://Scenes/card.tscn")
@onready var playerHand = $player_hand


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
				startDrag(card)
		else:
			if cardBeingDragged:
				finshDrag()

func addCard(card: CardStats):
	var newCard = cardScene.instantiate()
	
	newCard.clicked.connect(_on_card_clicked)
	add_child(newCard)
	newCard.name = card.card_name
	newCard.image.texture = load(card.sprite_path)
	newCard.id = card.id
	print(playerHand)
	playerHand.addCardToHand(newCard) 


func startDrag(card):
	cardBeingDragged = card
	#card.scale = Vector2(1, 1)
	

func finshDrag():
	#cardBeingDragged.scale = Vector2(1.1, 1.1)	
	playerHand.addCardToHand(cardBeingDragged)
	cardBeingDragged = null
	

func checkForCard():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = collisionMaskCard
	var results = space_state.intersect_point(parameters)
	if results.size() > 0:
		return getCardWithHighestZIndex(results)
	return null
	
	
	
	
func getCardWithHighestZIndex(cards):
	var highestZValueCard = cards[0].collider.get_parent()
	var highestZValueCardIndex = highestZValueCard.z_index
	
	for i in range(1, cards.size()):
		var currentCard = cards[i].collider.get_parent()
		if currentCard.z_index > highestZValueCardIndex:
			highestZValueCard = currentCard
			highestZValueCardIndex = currentCard.z_index
	
	return highestZValueCard

# Called when the node enters the scene tree for the first time.

func connectCardSignals(card):
	card.connect("hovered", onHoveredOverCard)
	card.connect("hoveredOff", onHoveredOffCard)
	
func onHoveredOverCard(card):
	if !isHoveringOnCard:
		isHoveringOnCard = true
		highlightCard(card, true)
	
func onHoveredOffCard(card):
	
	if !cardBeingDragged:
		highlightCard(card, false)
		
		#if you went off hovering one card to another
		var newHoveredCard = checkForCard()
		if newHoveredCard:
			highlightCard(newHoveredCard, true)
		else:
			isHoveringOnCard = false

func highlightCard(card, hovered):
	if hovered:
		#card.scale = Vector2(1.1, 1.1)
		card.z_index = 2
	else:
		#card.scale = Vector2(1,1)
		card.z_index = 1
		
	
func remove_selected_node():
	playerHand.remove_selected_node()

func _on_card_clicked(id: Cards.CARDS, card):
	emit_signal("card_selected", id)
	playerHand.deselect_all()
	card.isClicked = true
# Called every frame. 'delta' is the elapsed time since the previous frame.
