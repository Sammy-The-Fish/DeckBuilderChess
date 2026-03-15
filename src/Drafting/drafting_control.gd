extends Control

@onready var CardContainer = $VBoxContainer/CardContainer
@onready var textureButtonTags = preload("res://src/Drafting/textureButtonTags.tscn")

var buttons = []
var selectedButtonIndex = -1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for x in range(20) :
		var randomCard = Cards.cardList[Cards.CARDS.values().pick_random()]
		
		#var newCardButton = textureButtonTags.instantiate()
		#newCardButton.texture_normal = load(randomCard.sprite_path)
		##newCardButton.
		#newCardButton.cardID = randomCard.id
		#newCardButton.cardName = randomCard.card_name
		#
		#newCardButton.stretch_mode = TextureButton.STRETCH_SCALE
		#newCardButton.custom_minimum_size = Vector2(75, 105)
		#newCardButton.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
		#newCardButton.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		#print(newCardButton.size)
		#Make the card selected when pressed by updating the selected button index using the pressed signal from this utton also ideally some visual indicator? (depressed etc)
		#buttons.append(newCardButton)
		

	#buttons.sort_custom(func(a,b): return a.cardName < b.cardName)
	#for x in buttons :
	#	CardContainer.add_child(x)
		
		
		

	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	# add card to database
	buttons.remove_at(selectedButtonIndex)
