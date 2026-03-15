extends Node2D


var card_id: int


@onready var desc = $description
@onready var sprite = $sprite
@onready var button = $executeCardButton
@onready var procceedButton = $proceedButton
@onready var selectionContainer = $HBoxContainer

@onready var selectionIndicator = preload("res://src/seletion_indicator.tscn")

var selectionIndicators = []
var currentlySelected = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	setDisabled()

func setDetails(card: CardStats):
	if (card == null):
		setDisabled()
		return
	
	desc.text = card.desc
	sprite.texture = load(card.sprite_path)
	card_id = card.id
	
	selectionIndicators = []
	currentlySelected = 0
	
	if card.target_quantity == 0 : button.disabled = false
	
	for i in range(card.target_quantity):
		var indicator = selectionIndicator.instantiate()
		selectionIndicators.append(indicator)
		selectionContainer.add_child(indicator)
	print(selectionIndicators.size())

func setQuantitySelected(quantity: int):
	for indicator in selectionIndicators:
		indicator.modulate = Color("#FFFFFF")
	
	if (quantity == selectionIndicators.size()):
		button.disabled = false
	
	for i in range(quantity):
		selectionIndicators[i].modulate = Color("#00FF00")
		

func chessMode():
	setDetails(null)
	procceedButton.disabled = true

func setDisabled():
	for ind in selectionContainer.get_children():
		ind.queue_free()
	selectionIndicators = []
	desc.text = "select a card"
	button.disabled = true
	procceedButton.disabled = false
	sprite.texture = load("res://cards/none.png")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
