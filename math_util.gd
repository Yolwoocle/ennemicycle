extends Node

## Returns whether 0 <= vect.x < bounds.x AND 0 <= vect.y < bounds.y
func is_vect_within_vect(vect: Vector2, bounds: Vector2):
	return 0 <= vect.x and vect.x < bounds.x and 0 <= vect.y and vect.y < bounds.y


func squared(x):
	return x*x


## Returns whether a point is within a pizza crust shape. 
func is_point_in_pizza_crust(point: Vector2, angle_range: Vector2, min_radius: float, height: float) -> bool:
	var dist_sqr = point.length_squared()
	var ang = fmod(point.angle() + TAU*2, TAU)

	return squared(min_radius) <= dist_sqr and dist_sqr <= squared(min_radius + height) and (angle_range.x <= ang and ang <= angle_range.y)


## Returns the rect bounds of a "pizza crust" shape, defined by a minimum radius, a height (or thickness), and an angle range.[br]
## Looks a bit like this:
## [codeblock]
##    __
##   /  /
##  |  |
##  |  |
##   \__\
## [/codeblock]
func get_pizza_crust_bounds(angle_range: Vector2, min_radius: float, height: float) -> Rect2:
	var min_ang_unit_vec = Vector2.from_angle(angle_range.x)
	var max_ang_unit_vec = Vector2.from_angle(angle_range.y)

	var points = [
		min_ang_unit_vec * min_radius,
		min_ang_unit_vec * (min_radius + height),
		max_ang_unit_vec * min_radius,
		max_ang_unit_vec * (min_radius + height),
	]

	for a in [0, PI/2, PI, 3*PI/2]:
		if angle_range.x <= a and a <= angle_range.y:
			points.append(Vector2.from_angle(a) * (min_radius + height))
	
	var min_x = INF
	var max_x = -INF
	var min_y = INF
	var max_y = -INF

	for p in points:
		min_x = min(min_x, p.x)
		max_x = max(max_x, p.x)
		min_y = min(min_y, p.y)
		max_y = max(max_y, p.y)

	return Rect2(min_x, min_y, max_x - min_x, max_y - min_y)