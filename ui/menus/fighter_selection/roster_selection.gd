extends Control

# @export_range(-360, 360, 0.001, "radians_as_degrees") var min_angle: float = PI
# @export_range(-360, 360, 0.001, "radians_as_degrees") var max_angle: float = TAU-0.00001
# @export var rows = 3
# @export var columns: Array[int]
# @export var minimum_radius = 256
# @export var row_height = 128
# @export_range(-360, 360, 0.001, "radians_as_degrees") var column_spacing: float = PI/100
# @export var row_spacing = 12

var universes: Dictionary = {
	"npa":   UniverseData.new("npa",   "Nouveau Parti anticapitaliste", "res://assets/images/universes/npa.png"),
	"lfi":   UniverseData.new("lfi",   "La France Insoumise",           "res://assets/images/universes/lfi.png"),
	"pcf":   UniverseData.new("pcf",   "Parti Communiste Français",     "res://assets/images/universes/pcf.png"),
	"hor":   UniverseData.new("hor",   "Horizons",                      "res://assets/images/universes/hor.png"),
	"le":    UniverseData.new("le",    "Les Écologistes",               "res://assets/images/universes/le.png"),
	"ps":    UniverseData.new("ps",    "Parti Socialistxe",              "res://assets/images/universes/ps.png"),	
	"liot":  UniverseData.new("liot",  "Libertés et territoires",       "res://assets/images/universes/liot.png"),
	"modem": UniverseData.new("modem", "Mouvement démocrate",           "res://assets/images/universes/modem.png"),
	"re":    UniverseData.new("re",    "Renaissance",                   "res://assets/images/universes/re.png"),
	"lr":    UniverseData.new("lr",    "Les Républicains",              "res://assets/images/universes/lr.png"),
	"rn":    UniverseData.new("rn",    "Rassemblement national",        "res://assets/images/universes/rn.png"),
	"rec":   UniverseData.new("rec",   "Reconquête",                    "res://assets/images/universes/rec.png"),
}

var fighters: Array[Array] = [
	[
		FighterData.new(universes["lfi"],   "Jean-Luc", "Mélenchon",   "res://assets/images/fighters/jean_luc_melenchon.png"),
		FighterData.new(universes["le"],    "Marine", "Tondelier",     "res://assets/images/fighters/marine_tondelier.png"),
		FighterData.new(universes["ps"],    "Raphaël", "Glucksmann",   "res://assets/images/fighters/raphael_glucksmann.png"),
		FighterData.new(universes["re"],    "Emmanuel", "Macron",      "res://assets/images/fighters/emmanuel_macron.png"),
		FighterData.new(universes["lr"],    "Éric", "Ciotti",          "res://assets/images/fighters/eric_ciotti.png"),
		FighterData.new(universes["rn"],    "Marine", "Le Pen",        "res://assets/images/fighters/marine_le_pen.png"),
		FighterData.new(universes["rec"],   "Éric", "Zemmour",         "res://assets/images/fighters/eric_zemmour.png"),
	], 
	[
		FighterData.new(universes["lfi"],   "Manuel", "Bompart",       "res://assets/images/fighters/manuel_bompart.png"),
		FighterData.new(universes["lfi"],   "Mathilde", "Panot",       "res://assets/images/fighters/mathilde_panot.png"),
		FighterData.new(universes["lfi"],   "François", "Ruffin",      "res://assets/images/fighters/francois_ruffin.png"),
		FighterData.new(universes["ps"],    "François", "Hollande",    "res://assets/images/fighters/francois_hollande.png"),
		FighterData.new(universes["modem"], "François", "Bayrou",      "res://assets/images/fighters/francois_bayrou.png"),
		FighterData.new(universes["re"],    "Élisabeth", "Borne",      "res://assets/images/fighters/elisabeth_borne.png"),
		FighterData.new(universes["re"],    "Gérald", "Darmanin",      "res://assets/images/fighters/gerald_darmanin.png"),
		FighterData.new(universes["lr"],    "Bruno", "Retailleau",     "res://assets/images/fighters/bruno_retailleau.png"),
		FighterData.new(universes["rn"],    "Jordan", "Bardella",      "res://assets/images/fighters/jordan_bardella.png"),
		FighterData.new(universes["rec"],   "Marion", "Maréchal",      "res://assets/images/fighters/marion_marechal.png"),
	],
	[	
		FighterData.new(universes["npa"],   "Philippe", "Poutou",      "res://assets/images/fighters/philippe_poutou.png"),
		FighterData.new(universes["lfi"],   "Antoine", "Léaument",     "res://assets/images/fighters/antoine_leaument.png"),
		FighterData.new(universes["lfi"],   "Louis", "Boyard",         "res://assets/images/fighters/louis_boyard.png"),
		FighterData.new(universes["pcf"],   "Fabien", "Roussel",       "res://assets/images/fighters/fabien_roussel.png"),
		FighterData.new(universes["liot"],  "Jean", "Lassalle",        "res://assets/images/fighters/jean_lassalle.png"),
		FighterData.new(universes["hor"],   "Édouard", "Philippe",     "res://assets/images/fighters/edouard_philippe.png"),
		FighterData.new(universes["re"],    "Gabriel", "Attal",        "res://assets/images/fighters/gabriel_attal.png"),
		FighterData.new(universes["lr"],    "Valérie", "Pecresse",     "res://assets/images/fighters/valerie_pecresse.png"),
		FighterData.new(universes["lr"],    "Michel", "Barnier",       "res://assets/images/fighters/michel_barnier.png"),
		FighterData.new(universes["rn"],    "Jean-Philippe", "Tanguy", "res://assets/images/fighters/jean_philippe_tanguy.png"),
		FighterData.new(universes["rn"],    "Jean-Marie", "Le Pen",    "res://assets/images/fighters/jean_marie_le_pen.png"),
	],
]
var rows = fighters.size()

var roster_position = Vector2(0, 100)
var min_angle: float = PI
var max_angle: float = TAU-0.00001
var total_angle_range: Vector2

var minimum_radius = 200
var row_height = 100
var column_spacing: float = PI/100
var row_spacing = 12

var total_bounds: Rect2
var button_scene: PackedScene = preload("res://ui/fighter_button.tscn")
var star_image: Image


func _ready():
	total_angle_range = Vector2(min_angle, max_angle)
	total_bounds = MathUtil.get_pizza_crust_bounds(total_angle_range, minimum_radius, fighters.size() * row_height + (fighters.size() - 1) * row_spacing)

	_init_min_max_angle()
	_create_buttons()


func _init_min_max_angle():
	min_angle = fmod(min_angle, TAU)
	max_angle = fmod(max_angle, TAU)
	if min_angle > max_angle:
		var temp = max_angle
		max_angle = min_angle
		min_angle = temp

func _create_buttons():
	var radius = minimum_radius
	for i_row in range(rows):
		_create_row(fighters[i_row], total_angle_range, radius, row_height)
		radius += row_height + row_spacing

	_create_button(
		FighterData.new(UniverseData.new("?", "?", "res://assets/images/universes/npa.png"), "", "Aléatoire", "res://assets/images/fighters/random.png"),
		total_angle_range, 0, row_height
	)


func _create_row(fighters_row, angle_range: Vector2, min_radius: float, height: float):
	var row_columns = float(fighters_row.size())
	var columns_float: float = float(row_columns)
	var total_angle: float = angle_range.y - angle_range.x
	for i_col in range(row_columns):
		var ang_min = angle_range.x + total_angle * float(float(i_col)     / columns_float) + column_spacing * 0.5
		var ang_max = angle_range.x + total_angle * float(float(i_col + 1) / columns_float) - column_spacing * 0.5
		
		_create_button(fighters_row[i_col], Vector2(ang_min, ang_max), min_radius, height)



func _create_button(fighter_data: FighterData, angle_range: Vector2, min_radius: float, height: float):
	var button: FighterButton = button_scene.instantiate()
	add_child(button)
	button.initialize(fighter_data, angle_range, min_radius, height)

	button.position += Vector2(size.x / 2, total_bounds.size.y) 
