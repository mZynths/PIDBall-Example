extends RigidBody2D

class_name PickableRigidBody2D

var picked_up = false
var mouse_is_inside = false

func _process(delta):
	if picked_up:
		linear_velocity = (get_global_mouse_position() - global_position) * 25
	
	if mouse_is_inside and Input.is_mouse_button_pressed(1):
		picked_up = true
	
	if not Input.is_mouse_button_pressed(1) and picked_up:
		picked_up = false

func _on_Ball_mouse_entered():
	mouse_is_inside = true

func _on_Ball_mouse_exited():
	mouse_is_inside = false
