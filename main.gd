extends Node2D


var white_score := 0
var black_score := 0

@onready var drafter = preload("res://src/Drafting/drafting_control.tscn")
@onready var game = preload("res://src/game.tscn")


@onready var victoryScene = await("res://main.tscn")



var currentScene


func _ready():
	print("hellooooo")
	var intro = drafter.instantiate()
	add_child(intro)
	currentScene = intro
	intro.connect("finished_drafting", _change_to_first_round)



func _change_to_first_round():
	var gameInstance = game.instantiate()
	add_child(gameInstance)
	print(currentScene.player1Deck)
	for item in currentScene.player1Deck:
		gameInstance.black_deck.append(item)
	print(gameInstance.black_hand)
	
	for item in currentScene.player2Deck:
		gameInstance.white_deck.append(item)
	
	gameInstance.init_turn()
	
	gameInstance.connect("game_won", _round_over)
	currentScene.queue_free()
	currentScene = gameInstance
	

func _round_over(winner: Globals.COLORS):
	if (winner == Globals.COLORS.BLACK):
		black_score+=1
	else:
		white_score+=1
		
	
		
		
	currentScene.queue_free()
	
	
	if black_score >= 2:
		Globals.black_wins = true
		get_tree().change_scene_to_file(victoryScene)
		return
	elif white_score >= 2:
		Globals.black_wins = false
		get_tree().change_scene_to_file(victoryScene)
	return
	
	var intro = drafter.instantiate()
	add_child(intro)
	currentScene = intro
	intro.connect("finished_drafting", _change_to_first_round)
