extends Node
class_name FighterData

var universe: UniverseData
var first_name: String
var last_name: String
var image: Image
var image_texture: ImageTexture

func _init(_universe: UniverseData, _first_name: String, _last_name: String, _image_path: String):
    universe = _universe
    first_name = _first_name
    last_name = _last_name

    image = Image.load_from_file(_image_path)
    image_texture = ImageTexture.create_from_image(image)