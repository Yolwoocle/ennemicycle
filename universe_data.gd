extends Node
class_name UniverseData

var universe_id: String
var universe_name: String
var image: Image
var image_texture: ImageTexture

func _init(_universe_id: String, _universe_name: String, _image_path: String):
    universe_id = _universe_id
    universe_name = _universe_name
    image = Image.load_from_file(_image_path)
    image_texture = ImageTexture.create_from_image(image)