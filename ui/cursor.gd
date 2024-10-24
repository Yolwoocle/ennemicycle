extends Control
class_name Cursor

signal enter_button(button: FighterButton)
signal exit_button(button: FighterButton)
signal pressed_button(button: FighterButton)
signal pressed()

@export var player_index := 0

var current_control_scheme: Dictionary
var user: User
var color: Color

var holding_token := true
var hovered_button: FighterButton

var token_scene: PackedScene = preload("res://ui/menus/fighter_selection/token.tscn")

@onready var hand := $Hand 
@onready var token := %Token

const control_schemes = [
	{"move": ["game_left_p1", "game_right_p1", "game_up_p1", "game_down_p1"], "select": "game_select_p1"},
	{"move": ["game_left_p2", "game_right_p2", "game_up_p2", "game_down_p2"], "select": "game_select_p2"},
	{"move": ["game_left_p1", "game_right_p1", "game_up_p1", "game_down_p1"], "select": "game_select_p1"},
	{"move": ["game_left_p2", "game_right_p2", "game_up_p2", "game_down_p2"], "select": "game_select_p2"},
]

const MOVEMENT_SPEED = 800	

func set_user(new_user: User):
	user = new_user

	current_control_scheme = control_schemes[player_index]

	color = user.main_color

	hand.get_node("HandSprite").self_modulate = color.lightened(0.7)
	hand.get_node("HandSprite/HandLabel").text = user.text_abbreviation
	hand.get_node("HandSprite/HandLabel").label_settings.font_color = color

	token.self_modulate = color
	token.get_node("TokenLabel").text = user.text_abbreviation

	
func _ready():
	var fetched_user = UserManager.get_user(player_index)
	if not fetched_user:
		push_error("cursor.gd: User {0} doesn't exist".format([player_index]))
	
	set_user(fetched_user)


func _process(delta):
	_update_hand(delta)

func _update_hand(delta):
	var input_vec = Input.get_vector(current_control_scheme["move"][0], current_control_scheme["move"][1], current_control_scheme["move"][2], current_control_scheme["move"][3])

	hand.position += input_vec * MOVEMENT_SPEED * delta

	var cursor_buttons = get_tree().get_nodes_in_group("cursor_button") 
	for button in cursor_buttons:
		if Rect2(button.global_position, button.size).has_point(hand.global_position):
			if button is FighterButton:
				var check_position = Vector2i(hand.global_position - button.global_position)
				if MathUtil.is_vect_within_vect(check_position, button.texture_click_mask.get_size()) and button.texture_click_mask.get_bitv(check_position):
					_on_hover_button(button)
				else:
					_on_exit_hover_button(button)
		else:
			_on_exit_hover_button(button)


func _input(event):
	if event.is_action_pressed(current_control_scheme["select"]):
		_on_pressed()


func _deposit_token():
	holding_token = false
	token.reparent(self)


func _take_token():
	holding_token = true
	token.reparent(hand)

	var tween = get_tree().create_tween()
	tween.tween_property(token, "position", Vector2.ZERO, 0.1)


func _on_pressed():
	if hovered_button and holding_token:
		_on_button_pressed(hovered_button)

	else:
		if not holding_token:
			_take_token()

	pressed.emit()


func _on_button_pressed(button: FighterButton):
	_deposit_token()

	pressed_button.emit(button)
	hovered_button.cursor_pressed.emit(self)


func _on_hover_button(button: FighterButton):
	if not button.has_hovered_cursor(self) and holding_token:
		hovered_button = button

		button.enter_cursor_hover.emit(self)
		enter_button.emit(button)


func _on_exit_hover_button(button: FighterButton):
	if button.has_hovered_cursor(self) and holding_token:
		hovered_button = null

		button.exit_cursor_hover.emit(self)
		exit_button.emit(button)
