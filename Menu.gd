extends VBoxContainer

onready var tab_menu = $TabContainer

func _ready():
#	tab_menu.set_tab_disabled(4, true)
	pass

func _on_GravityVal_value_changed(value):
	var balls = get_tree().get_nodes_in_group("Balls")
	for ball in balls:
		ball.gravity_scale = value

func _on_FrictionVal_value_changed(value):
	var balls = get_tree().get_nodes_in_group("Balls")
	for ball in balls:
		ball.friction = value


func _on_TabContainer_tab_changed(tab):
	get_node("Error").visible = !(tab == 4)
