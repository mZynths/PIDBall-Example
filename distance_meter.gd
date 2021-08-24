extends RayCast2D
class_name DistanceMeter2D

export var polling_rate := 0
export var max_error := 0

var result := 0.0

func _physics_process(delta):
	if is_colliding():
		var origin = global_transform.origin
		var collision_point = get_collision_point()
		result = origin.distance_to(collision_point)
	else:
		result = 0
