extends Node2D


var card_id: int


@onready var desc = $description
@onready var sprite = $sprite
@onready var button = $Button
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
	
	desc.text = card.desc
	sprite.texture = load(card.sprite_path)
	card_id = card.id
	
	selectionIndicators = []
	currentlySelected = 0
	
	
	for i in range(card.target_quantity):
		var indicator = selectionIndicator.instantiate()
		selectionIndicators.append(indicator)
		selectionContainer.add_child(indicator)


func setDisabled():
	desc.text = "select a card"
	button.disabled = true
	sprite.texture = load("res://cards/none.png")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
