extends Control

@onready var CardContainer = $VBoxContainer/CardContainer
var buttons = []
var selectedButtonIndex = -1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for x in range(20) :
		var cardDatabaseSize = Cards.cardList.size();
		#This shouold be card database size
		
		var cardID = randi_range(0, cardDatabaseSize - 1)
		
		var newCardButton = Button.new()
		#newCardButton.icon = the picture for the card
		#Make the card selected when pressed by updating the selected button index using the pressed signal from this utton also ideally some visual indicator? (depressed etc)
		buttons.append(newCardButton)
	#sort buttons alphebetically ascending
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	# add card to database
	buttons.remove_at(selectedButtonIndex)
