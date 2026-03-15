extends Node2D

# Game States
var game_over;
var player_color;
var status; # who is playing
var player2_type; # Where AI or Human is playing

var turnCount = 0;
var currentMana = 0;
var maxMana = 0

var storedMana;
var playerStored


const DRAW_AMOUNT = 5

enum TURN_STATES {
	CARDS,
	CHESS
}

var white_deck = [Cards.CARDS.JUMP, Cards.CARDS.JUMP, Cards.CARDS.JUMP, Cards.CARDS.JUMP, Cards.CARDS.JUMP, Cards.CARDS.JUMP, Cards.CARDS.JUMP, Cards.CARDS.JUMP, Cards.CARDS.JUMP]
var black_deck = [Cards.CARDS.ASSASSINATE, Cards.CARDS.ASSASSINATE, Cards.CARDS.JUMP, Cards.CARDS.JUMP, Cards.CARDS.JUMP, Cards.CARDS.JUMP]

var white_hand = []
var black_hand = []


var white_discard = []
var black_discard = []

var turn_state = TURN_STATES.CARDS
var selectedCard: CardStats = null
var selectedPiece = []
var selectedSquare



# To drag piece
var is_dragging: bool;
var selected_piece = null;
var previous_position = null;

@onready var board = $board
@onready var details = $details
@onready var manager = $manager
@onready var selector = $selector

func _ready():
	init_game()
	

	
func _input(event) :
	if (turn_state == TURN_STATES.CARDS):
		if (selectedCard == null):
			return
		if Input.is_action_just_pressed("clicked"):
			manageSelection()
			
	if (turn_state == TURN_STATES.CHESS):
		if Input.is_action_just_pressed("clicked"):
			var pos = board.get_pos_under_mouse() 
			selected_piece = board.get_piece(pos)
			
			if selected_piece == null or selected_piece.color != status:
				return
		
			is_dragging = true
			previous_position = selected_piece.position
			selected_piece.z_index = 100
		elif event is InputEventMouseMotion and is_dragging:
			selected_piece.position = board.get_local_mouse_position()
		
		elif Input.is_action_just_released("clicked") and is_dragging:
			var is_valid_move = drop_piece()
			if !is_valid_move:
				selected_piece.position = previous_position
			selected_piece.z_index = 0
			selected_piece = null
			is_dragging = false
			
			if evaluate_end_game():
				return
				
	
func manageSelection():
	match selectedCard.target_type:
		Globals.TARGETS.FRIENDLY_PIECE:
			var pos = board.get_pos_under_mouse()
			if pos == null : return
			var piece = board.get_piece(pos)
			if piece == null: return
			if piece.color != player_color:
				return
			if selectedPiece.size() == selectedCard.target_quantity:
				var unselected = selectedPiece.pop_back()
				unselected.modulate = Color("#FFFFFF")
				selectedPiece.push_front(piece)
			else:
				selectedPiece.push_front(piece)
			
			for selected in selectedPiece:
				selected.modulate = Color("#FF0000")
				
			details.setQuantitySelected(selectedPiece.size())
		Globals.TARGETS.PIECE:
			var pos = board.get_pos_under_mouse()
			if pos == null : return
			var piece = board.get_piece(pos)
			if piece == null: return

			
			
			if selectedPiece.size() == selectedCard.target_quantity:
				var unselected = selectedPiece.pop_back()
				unselected.modulate = Color("#FFFFFF")
				selectedPiece.push_front(piece)
			else:
				selectedPiece.push_front(piece)
			
			for selected in selectedPiece:
				selected.modulate = Color("#FF0000")
				
			details.setQuantitySelected(selectedPiece.size())
		Globals.TARGETS.SQUARE:
			print("we testin")
			var pos = board.get_pos_under_mouse()
			if pos == null : return
			
			selector.position = Vector2(
				board.position.x + (pos.x * Globals.CELL_SIZE),
				board.position.y + (pos.y * Globals.CELL_SIZE)
			)
			
			selector.visible = true
			details.button.disabled = false


func init_turn():
	var deck: Array
	var hand: Array
	var discard: Array
	

	
	if (status == Globals.COLORS.WHITE):
		deck = white_deck
		hand = white_hand
		discard = white_discard
		turnCount += 1
	else:
		deck = black_deck
		hand = black_hand
		discard = black_discard
	
	if (turnCount < 9):
		maxMana += 1
		currentMana = maxMana
	else:
		currentMana = 9
	
	deck.shuffle()
	# REPLACE WITH DRAW SIZE LATER
	for i in range(2):
		print("test")
		hand.push_front(deck.pop_front())
		if deck.size() == 0:
			for card in discard:
				deck.append(card)
			deck.shuffle()
	
	for card in hand:
		manager.addCard(Cards.cardList[card])
	

func init_game():
	game_over = false
	is_dragging = false 
	player_color = Globals.COLORS.WHITE
	status = Globals.COLORS.WHITE
	turn_state = TURN_STATES.CARDS
	init_turn()
	
	
	
func drop_piece():
	print(">>>>>>>>>>> ", selected_piece.board_position)
	
	var to_move = board.get_pos_under_mouse()
	if valid_move(selected_piece.board_position, to_move):
		# For valid move:
		# - if target has piece, then replace it
		var dest_piece = board.get_piece(to_move)
		# Delete only if the target piece is of different color
		if dest_piece != null and dest_piece.color != selected_piece.color:
			board.delete_piece(dest_piece)
		selected_piece.move_position(to_move)
		# - change current status of active color
		status = Globals.COLORS.BLACK if status == Globals.COLORS.WHITE else Globals.COLORS.WHITE
		turn_state = TURN_STATES.CARDS
		details.setDetails(null)
		init_turn()
		return true
	return false



func valid_move(from_pos, to_pos):
	print(selected_piece)
	#print("valid move")
	#return jumpMovement(from_pos,to_pos)

	
	
	var board_copy = board.clone()
	var src_piece = board_copy.get_piece(from_pos)
	
	print(from_pos)
	print(to_pos)
	
	#if(selected_piece != null and selected_piece.isJumped):
		#jumpMovement(from_pos, to_pos)
	
	
	
	# If we cannot move to threatened or moveable position
	if(
		to_pos not in src_piece.get_moveable_positions() 
		and 
		to_pos not in src_piece.get_threatened_positions()
	):
		return false
	
	
	var dst_piece = board_copy.get_piece(to_pos)
	if dst_piece != null:
		board_copy.delete_piece(dst_piece)
	src_piece.move_position(to_pos)
	
	# Check whether there is no check threaten the color
	for piece in board_copy.pieces:
		if status == Globals.COLORS.BLACK and board_copy.black_king_pos in piece.get_threatened_positions():
			return false
		if status == Globals.COLORS.WHITE and board_copy.white_king_pos in piece.get_threatened_positions():
			return false
	
	return true
	
	
func get_valid_moves():
	# Get possible moves for current player
	var valid_moves = []
	for piece in board.pieces:
		if piece.color == status:
			var candi_pos = piece.get_moveable_positions()
			if piece.piece_type == Globals.PIECE_TYPES.PAWN:
				candi_pos += piece.get_threatened_positions()
			candi_pos = unique(candi_pos)
			for pos in candi_pos:
				if valid_move(piece.board_position, pos):
					valid_moves.append([piece, pos])
	return valid_moves

func unique(arr: Array) -> Array:
	var dict = {}
	for a in arr:
		dict[a] = 1
	return dict.keys()

func evaluate_end_game():
	# Check whether the current user can make any legal move
	var moves = get_valid_moves()
	if len(moves) == 0:
		game_over = true
		set_win(Globals.PLAYER.TWO if status == player_color else Globals.PLAYER.ONE)
		return true
	return false
	
	
func set_win(who: Globals.PLAYER):
	game_over = true
	print("winner")
	#if who == Globals.PLAYER.ONE:
		#win_label.text = "Player One Won"
	#else:
		#win_label.text = "Player Two Won"
	#win_label.show()
	#ui_control.show()


# card building aspects

func on_card_select():
	pass

func _on_test_button_pressed() -> void:
	var card = CardStats.new(0, 3, "this is jump!!!!", "jump", "res://cards/Jump.png", Globals.TARGETS.PIECE, 2)
	selectedCard = card
	
func jumpMovement(from_pos, to_pos):	
	print("LLOOOOK AT MEEEEEE!!!!<><><><><><><><><><><><><><><><><>")

	#if (selectedCard == null) : return false
	
	if selected_piece.piece_type == Globals.PIECE_TYPES.ROOK:
		if (to_pos.x == selectedPiece[0].x) or (to_pos.y == selectedPiece[0].y) and (board.get_piece(to_pos) == null):
			return true
		else:
			return false
	elif selected_piece.piece_type == Globals.PIECE_TYPES.QUEEN:
		print("LLOOOOK AT MEEEEEE!!!!<><><><><><><><><><><><><><><><><>")
		if (to_pos.x == selectedPiece[0].x) or (to_pos.y == selectedPiece[0].y) or (abs(from_pos.x - to_pos.x) == abs(from_pos.y - to_pos.y)) and (board.get_piece(to_pos) == null):
			return true
		else:
			return false
	elif selected_piece.piece_type == Globals.PIECE_TYPES.BISHOP:
		if (abs(from_pos.x - to_pos.x) == abs(from_pos.y - to_pos.y)) and (board.get_piece(to_pos) == null):
			return true
		else:
			return false
	return false
	#else:
		#valid_move(to_pos, from_pos)
		
		
			
		
	
func jump() -> int:
	selectedPiece.isJumped = true
	return Cards.cardList[Cards.CARDS.JUMP].manacost
	
	
func _on_execute_card_button_pressed() -> void:
	# massive fuck off switch statement which is yet to be implemented
	var requiredMana = selectedCard.mana_cost
	if(selectedCard.mana_cost == -1):
		match selectedPiece[0].type:
			Globals.PIECE_TYPES.QUEEN:
				requiredMana = 9
			Globals.PIECE_TYPES.ROOK:
				requiredMana = 5
			Globals.PIECE_TYPES.BISHOP:
				requiredMana = 3
			Globals.PIECE_TYPES.KNIGHT:
				requiredMana = 3
			Globals.PIECE_TYPES.PAWN:
				requiredMana = 1
				
	print(currentMana)
	print(requiredMana)
	#if(currentMana >= requiredMana):
	selectedCard = null
	for piece in selectedPiece:
		piece.modulate =Color("#FFFFFF")
	selectedPiece = []
	potofgreed()
	manager.remove_selected_node()
	
	
	selector.visible = false
	details.setDetails(null)
	
	
	


func _on_proceed_button_pressed() -> void:
	selector.visible = false
	
	selectedCard = null
	for piece in selectedPiece:
		piece.modulate =Color("#FFFFFF")
	
	
		
	selectedPiece = []
	
	
	
	turn_state = TURN_STATES.CHESS
	details.chessMode()


func _on_manager_card_selected(id: Cards.CARDS) -> void:
	details.button.disabled = false
	selectedCard = Cards.cardList[id]
	selectedSquare = null
	selector.visible=false
	details.setDetails(null)
	details.setDetails(selectedCard)

var whiteElectricute = false;
var blackElectricute = false;
func upkeep() -> void:
	if(hardcorePawn != false):
		board.delete_piece(hardcorePawn)
		#SAM ADD REGULAR PAWN HERE
		hardcorePawn = false;
	
	if (status == Globals.COLORS.WHITE):
		if(whiteElectricute):
			whiteElectricute = false;
			for i in range(5):
				for j in range(6):
					if(board.getElectricute()):
						board.deletePiece(i, j);
		if(playerStored == Globals.COLORS.WHITE):
			currentMana = currentMana + storedMana
			storedMana = 0
			playerStored = -1
	else:
		if(blackElectricute):
			blackElectricute = false;
			for i in range(5):
				for j in range(6):
					if(board.getElectricute()):
						board.deletePiece(i, j);
		if(playerStored == Globals.COLORS.BLACK):
			currentMana = currentMana + storedMana
			storedMana = 0
			playerStored = -1
	
func assassinate() -> int:
	#if threatened
	board.delete_piece(selectedPiece[0]);
	
	match selectedPiece[0].type:
		Globals.PIECE_TYPES.QUEEN:
			return 9
		Globals.PIECE_TYPES.ROOK:
			return 5
		Globals.PIECE_TYPES.BISHOP:
			return 3
		Globals.PIECE_TYPES.KNIGHT:
			return 3
		Globals.PIECE_TYPES.PAWN:
			return 1
	return -100
	
func potofgreed() -> int:
	var deck: Array
	var hand: Array
	var discard: Array
	var drawn: Array
	if (status == Globals.COLORS.WHITE):
		deck = white_deck
		hand = white_hand
		discard = white_discard
	else:
		deck = black_deck
		hand = black_hand
		discard = black_discard
	
	for i in range(3):
		print("test")
		var cards = deck.pop_front()
		hand.push_front(cards)
		drawn.push_front(cards)
		if deck.size() == 0:
			for card in discard:
				deck.append(card)
			deck.shuffle()
	
	for card in drawn:
		manager.addCard(Cards.cardList[card])
	return true
	
func electrocute() -> int:
	board.electrocute(selectedPiece[0].position.x, selectedPiece[0].position.y);
	if (status == Globals.COLORS.WHITE):
		whiteElectricute = true;
	else:
		blackElectricute = true;
	return selectedCard.mana_cost
	
func sacrifice() -> int:
	board.delete_piece(selectedPiece[0])
	match selectedPiece[0].type:
		Globals.PIECE_TYPES.QUEEN:
			return -9
		Globals.PIECE_TYPES.ROOK:
			return -5
		Globals.PIECE_TYPES.BISHOP:
			return -3
		Globals.PIECE_TYPES.KNIGHT:
			return -3
		Globals.PIECE_TYPES.PAWN:
			return -1
	return -100
	
func ritual() -> int:
	storedMana = currentMana;
	playerStored = status
	# SAM END TURN HEREREREREREREREREREREE
	return 0
	
var hardcorePawn = false
func hardcorePAEWNNNWNWNW() -> int:
	board.delete_piece(selectedPiece[0])
	#WAY TO ADD PIECE HERE SHOULD BE HARDCORE PAWN
	#hardcorePawn = new hardcore pawn piece
	return selectedCard.mana_cost
	
