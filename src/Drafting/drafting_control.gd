extends Control

@onready var CardContainer = $VBoxContainer/CardContainer
@onready var CardTextLabel = $VBoxContainer/Label
@onready var PlayerTurnLabel = $VBoxContainer/HBoxContainer/Label
@onready var CardImageSprite = $VBoxContainer/HBoxContainer/Sprite2D
@onready var textureButtonTags = preload("res://src/Drafting/textureButtonTags.tscn")
@onready var CardScene = preload("res://Scenes/card.tscn")

var rawCards = []
var selectedButtonIndex = -1
var player1Turn = true
var player1Deck = []
var player2Deck = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for x in range(22) :
		rawCards.append(Cards.CARDS.values().pick_random())
	rawCards.sort()
	
	for x in range(22) :
		var cardToAdd = CardScene.instantiate()
		CardContainer.add_child(cardToAdd)
		cardToAdd.position = Vector2(x % 11 * 179 + 85, int(float(x) / 11) * 240 + 130)
		var CardOfInfo = Cards.cardList.get(rawCards[x])
		cardToAdd.image.texture = load(CardOfInfo.sprite_path)
		cardToAdd.id = CardOfInfo.id
		#Make the card selected when pressed by updating the selected button index using the pressed signal from this utton also ideally some visual indicator? (depressed etc)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var tempSelectedCards = []
	for x in CardContainer.get_children() :
		print(x.id)
		if x.isClicked == true:
			tempSelectedCards.append(x.id)

	for x in tempSelectedCards:
		if selectedButtonIndex != x :
			for y in CardContainer.get_children() :
				if y.id == selectedButtonIndex :
					y.unselect()
			selectedButtonIndex = x
			CardTextLabel.text = Cards.cardList[x].desc
			CardImageSprite.texture = load(Cards.cardList[x].sprite_path)
			break;
	
	
	

func _on_button_pressed() -> void:
	if selectedButtonIndex != -1 :
		for x in CardContainer.get_children() :
			x.unselect()
			CardTextLabel.text = "No cards selected"
		if player1Turn == true :
			player1Deck.append(selectedButtonIndex)
			player1Turn = false
			PlayerTurnLabel.text = "Player 2's Turn to pick a card"
		else:
			player2Deck.append(selectedButtonIndex)
			player1Turn = true
			PlayerTurnLabel.text = "Player 1's Turn to pick a card"
		for x in CardContainer.get_children():
			if x.id == selectedButtonIndex :
				CardContainer.remove_child(x)
				selectedButtonIndex = -1
				break
