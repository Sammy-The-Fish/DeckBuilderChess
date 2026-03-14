extends Node2D

# Game States
var game_over;
var player_color;
var status; # who is playing
var player2_type; # Where AI or Human is playing

enum TURN_STATES {
	CARDS,
	CHESS
}

var turn_state = TURN_STATES.CARDS
var selectedCard: CardStats = null
var selectedPiece = []


# To drag piece
var is_dragging: bool;
var selected_piece = null;
var previous_position = null;

@onready var board = $board
@onready var details = $details

func _ready():
	init_game()
	
	
	
func _input(event) :
	if (turn_state == TURN_STATES.CARDS):
		if Input.is_action_just_pressed("clicked"):
			print("yayayayay")
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
	if (selectedCard == null):
			return
	match selectedCard.target_type:
		Globals.TARGETS.PIECE:
			var pos = board.get_pos_under_mouse()
			if pos == null : return
			var piece = board.get_piece(pos)
			if selectedPiece.size() == selectedCard.target_quantity:
				var unselected = selectedPiece.pop_back()
				unselected.modulate = Color("#FFFFFF")
				selectedPiece.push_front(piece)
			else:
				selectedPiece.push_front(piece)
			
			for selected in selectedPiece:
				selected.modulate = Color("#FF0000")
			

	
func init_game():
	game_over = false
	is_dragging = false 
	player_color = Globals.COLORS.WHITE
	status = Globals.COLORS.WHITE
	turn_state = TURN_STATES.CARDS
	
	
	
func drop_piece():
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
		return true
	return false



func valid_move(from_pos, to_pos):
	var board_copy = board.clone()
	var src_piece = board_copy.get_piece(from_pos)
	
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
	var card = CardStats.new(0, 3, "this is jump!!!!", "jump", "res://cards/Jump.png", Globals.TARGETS.PIECE, 1)
	selectedCard = card
	details.setDetails(card)
	
	
	
	
