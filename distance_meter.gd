extends RayCast2D
class_name DistanceMeter2D

export var polling_rate := 0.1
var elapsed_time = 0
export var max_error := 0.0

var result := 0.00
var crude_result := 0.00
var last_result := 0.00
var smoothing := 0

func _physics_process(delta):
	elapsed_time += delta
	if is_colliding():
		if elapsed_time >= polling_rate:
			var origin = global_transform.origin
			var collision_point = get_collision_point()
			result = origin.distance_to(collision_point)
			result += rand_range(-max_error, max_error)
			elapsed_time = 0
			last_result = result
	else:
		pass
	
#	print(result)

func _on_PollingRateVal_value_changed(value):
	polling_rate = value


func _on_MaxErrorVal_value_changed(value):
	max_error = value


func _on_SmoothVal_value_changed(value):
	smoothing = value
