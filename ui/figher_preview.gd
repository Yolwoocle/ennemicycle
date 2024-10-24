extends Control
class_name FighterPreview

@export var player_index = 1

@onready var player_index_label: Label = %PlayerIndexLabel 
@onready var first_name_label: Label = %FirstNameLabel 
@onready var last_name_label: Label = %LastNameLabel 
@onready var preview_texture_rect: TextureRect = %FighterPreviewImage 
@onready var universe_icon: TextureRect = %UniverseIcon

var cursor: Cursor

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func update_selected_fighter(fighter_data: FighterData):
	player_index_label.text = "J{0}".format([player_index])

	first_name_label.text = fighter_data.first_name
	last_name_label.text = fighter_data.last_name

	preview_texture_rect.texture = fighter_data.image_texture
	universe_icon.texture = fighter_data.universe.image_texture

func _on_cursor_enter_button(button: FighterButton):
	update_selected_fighter(button.fighter_data)


func link_cursor(_cursor: Cursor):
	cursor = _cursor
	cursor.enter_button.connect(_on_cursor_enter_button)