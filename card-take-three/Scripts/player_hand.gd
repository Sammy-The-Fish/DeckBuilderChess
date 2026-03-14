extends Node2D

const handCount = 5
const cardScenePath = "res://Scenes/card.tscn"
const cardWidth = 200 # this is just a magic number which changes the distance between cards in hand

var playerHand = []
var centerScreenXValue
var playerHandYValue = 890 #also a magic number

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	centerScreenXValue = get_viewport().size.x / 2
	
	var cardScene = preload(cardScenePath)
	for i in range (handCount):
		var newCard = cardScene.instantiate()
		$"../cardManager".add_child(newCard)
		newCard.name = "CardTemp"
		addCardToHand(newCard)

func addCardToHand(card):
	if card not in playerHand:
		playerHand.insert(0, card)
		updateHandPositions()
	else:
		animateCardToPosition(card, card.cardPositionInHand)
	
func updateHandPositions():
	for i in range(playerHand.size()): #check if this is wrong
		# get new card position based on what the index passed in was
		var newPosition = Vector2(calculateCardPosition(i), playerHandYValue)
		var card = playerHand[i]
		card.cardPositionInHand = newPosition
		animateCardToPosition(card, newPosition)
	
func calculateCardPosition(index):
	var totalWidth = (playerHand.size() - 1) * cardWidth #again here
	var xOffset = centerScreenXValue + index * cardWidth - totalWidth / 2
	return xOffset

func animateCardToPosition(card, newPosition):
	var tween = get_tree().create_tween()
	tween.tween_property(card, "position", newPosition, 0.4).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
	
func removeCardFromHand(card):
	if card in playerHand:
		playerHand.erase(card)
		updateHandPositions()


# Called every frame. 'delta' is the elapsed time since the previous frame.s
