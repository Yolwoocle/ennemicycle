extends TextureButton
class_name FighterButton

signal enter_cursor_hover(cursor: Cursor)
signal exit_cursor_hover(cursor: Cursor)
signal cursor_pressed(cursor: Cursor)

var cursor: Cursor

var fighter_data: FighterData
var is_fighter_hovered = false

var current_cursors: Dictionary = {}

const overlay_thickness = 5
const overlay_angle = PI/200
const overlay_flash_duration := 0.1
const overlay_flash_intensity := 0.3
var overlay_flash_timer := 0.0

@onready var hover_overlay: TextureRect = $HoverOverlay

func initialize(_fighter_data: FighterData, angle_range: Vector2, min_radius: float, height: float):
	enter_cursor_hover.connect(_enter_cursor_hover)
	exit_cursor_hover.connect(_exit_cursor_hover)
	cursor_pressed.connect(_cursor_pressed)

	fighter_data = _fighter_data
	name = _fighter_data.first_name + " " + _fighter_data.last_name
	print(name)

	var rect_bounds = MathUtil.get_pizza_crust_bounds(angle_range, min_radius, height)
	position = rect_bounds.position
	var images = _generate_image(_fighter_data, rect_bounds.position, rect_bounds.size, angle_range, min_radius, height)
	var image = images[0]
	var image_overlay = images[1]

	var bit_map = BitMap.new()
	bit_map.create_from_image_alpha(image)

	texture_click_mask = bit_map

	var image_texture = ImageTexture.create_from_image(image)
	texture_normal = image_texture
	texture_hover = image_texture
	texture_disabled = image_texture
	texture_pressed = image_texture

	hover_overlay.texture = ImageTexture.create_from_image(image_overlay)



func has_hovered_cursor(_cursor: Cursor):
	return current_cursors.has(_cursor)



func _process(delta):
	if is_fighter_hovered:
		$Label.text = "[color=green]TRUE[/color]"
	else:
		$Label.text = "[color=red]FALSE[/color]"
	
	_update_overlay(delta)

func _update_overlay(delta):
	hover_overlay.visible = is_fighter_hovered

	if is_fighter_hovered:
		var _cursor: Cursor
		for c in current_cursors:
			_cursor = c
			break

		overlay_flash_timer = fmod(overlay_flash_timer + delta*10, TAU)
		hover_overlay.modulate = _cursor.color.lightened((sin(overlay_flash_timer) + 1.0) / 3) 


func _generate_mask(offset_pos: Vector2, region_size: Vector2i, angle_range: Vector2, min_radius: float, height: float) -> Array[Image]:
	var image = Image.create(region_size.x, region_size.y, false, Image.Format.FORMAT_RGBA8)
	var image_overlay = Image.create(region_size.x, region_size.y, false, Image.Format.FORMAT_RGBA8)

	for ix in range(region_size.x):
		for iy in range(region_size.y):
			var image_pos = Vector2i(ix, iy) 
			var real_pos = offset_pos + Vector2(image_pos)

			if MathUtil.is_point_in_pizza_crust(real_pos, angle_range, min_radius, height):
				image.set_pixelv(image_pos, Color.WHITE)

				if not MathUtil.is_point_in_pizza_crust(real_pos, angle_range + overlay_angle * Vector2(1, -1), min_radius + overlay_thickness, height - 2*overlay_thickness):
					image_overlay.set_pixelv(image_pos, Color.WHITE)

			else:
				image.set_pixelv(image_pos, Color.TRANSPARENT)
				image_overlay.set_pixelv(image_pos, Color.TRANSPARENT)
			
	return [image, image_overlay]


func _generate_image(_fighter_data: FighterData, offset_pos: Vector2, region_size: Vector2i, angle_range: Vector2, min_radius: float, height: float) -> Array[Image]:
	var images = _generate_mask(offset_pos, region_size, angle_range, min_radius, height)
	var image = images[0]
	var image_overlay = images[1]

	var new_size = max(region_size.x, region_size.y)
	var new_size_v = Vector2i(new_size, new_size)
	var image_mask_source = Image.new()
	image_mask_source.copy_from(_fighter_data.image)
	image_mask_source.resize(new_size, new_size)
	image_mask_source = image_mask_source.get_region(Rect2i(
		new_size_v/2 - region_size/2, region_size
	))
	image_mask_source.convert(Image.Format.FORMAT_RGBA8)
	image.blit_rect_mask(image_mask_source, image, Rect2(Vector2.ZERO, region_size), Vector2i(0, 0))

	var bit_map = BitMap.new()
	bit_map.create_from_image_alpha(image)

	return [image, image_overlay]


func _enter_cursor_hover(_cursor: Cursor):
	current_cursors[_cursor] = true
	_update_hovered_status()


func _exit_cursor_hover(_cursor: Cursor):
	if current_cursors.has(_cursor):
		current_cursors.erase(_cursor)
	_update_hovered_status()

func _cursor_pressed(cursor: Cursor):
	print("SELECTIONNE ", fighter_data.first_name, " ", fighter_data.last_name)

func _update_hovered_status():
	is_fighter_hovered = not current_cursors.is_empty()

