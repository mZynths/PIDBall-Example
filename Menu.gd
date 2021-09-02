extends VBoxContainer


func _on_GravityVal_value_changed(value):
	var balls = get_tree().get_nodes_in_group("Balls")
	for ball in balls:
		ball.gravity_scale = value

func _on_MassVal_value_changed(value):
	var balls = get_tree().get_nodes_in_group("Balls")
	for ball in balls:
		ball.mass = value
