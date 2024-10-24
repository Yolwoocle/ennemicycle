extends Node

var users = [
	User.new(0, Color("F00000")),
	User.new(1, Color("0065E4")),
	User.new(2, Color("E9A200")),
	User.new(3, Color("009319"))
]

func get_user(user_index: int):
	assert(0 <= user_index and user_index < users.size(), "user_manager.gd: User index out of range") 
	return users[user_index]

func _ready():
	pass


func _process(delta):
	pass
