extends RayCast2D
class_name DistanceMeter2D

export var polling_rate := 0.5
var elapsed_time = 0
export var max_error := 0.0

var result := 0.0

func _physics_process(delta):
	elapsed_time += delta
	if is_colliding():
		if elapsed_time >= polling_rate:
			var origin = global_transform.origin
			var collision_point = get_collision_point()
			result = origin.distance_to(collision_point)
			result += rand_range(-max_error, max_error)
			elapsed_time = 0
	else:
		result = 1000
	
#	print(result)
