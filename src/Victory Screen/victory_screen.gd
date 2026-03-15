extends Control

@onready var VictoryLabel = $VictoryLabel


@onready var mainMenu = await("res://Scenes/titleScreen.tscn")
var player1wins = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Globals.black_wins == true:
		VictoryLabel.text = "Congratulations, Black wins!"
	else :
		VictoryLabel.text = "Congratulations, White wins!"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file(mainMenu)
