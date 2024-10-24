extends Node

var ui_scene: PackedScene = preload("res://ui/ui.tscn") 

var ui: UI
var main_control: Control

var viewport_size = Vector2i(
	ProjectSettings.get_setting("display/window/size/viewport_width"),
	ProjectSettings.get_setting("display/window/size/viewport_height")
)

func _ready():
	ui = ui_scene.instantiate()
	add_child(ui)

	main_control = ui.get_node("Control")

func _process(delta):
	pass
