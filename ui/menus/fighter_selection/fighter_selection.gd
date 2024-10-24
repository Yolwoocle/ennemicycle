extends Control

var fighter_previews: Array[FighterPreview] = []
@onready var fighter_preview_list = %FighterPreviewList

var cursors: Array[Cursor] = []
@onready var cursors_node = $Cursors

func _ready():
	for cursor in cursors_node.get_children():
		cursors.append(cursor)

	for fighter_preview in fighter_preview_list.get_children():
		fighter_previews.append(fighter_preview)

	_link_cursors_to_previews()

func _link_cursors_to_previews():
	for cursor in cursors:
		if 0 <= cursor.player_index and cursor.player_index < fighter_previews.size():
			fighter_previews[cursor.player_index].link_cursor(cursor) 