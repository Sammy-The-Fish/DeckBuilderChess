extends Control

@onready var VictoryLabel = $VictoryLabel

var player1wins = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if player1wins == true:
		VictoryLabel.text = "Congratulations, Player 1 wins!"
	else :
		VictoryLabel.text = "Congratulations, Player 2 wins!"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
