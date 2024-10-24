extends Node
class_name User

var user_index: int
var main_color: Color

var text_abbreviation: String

func _init(_user_index: int, _main_color: Color):
	user_index = _user_index
	main_color = _main_color

	text_abbreviation = "J{0}".format([user_index + 1]) 

func _ready():
	pass


func _process(delta):
	pass
