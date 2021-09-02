extends Node2D

func _ready():
	randomize()
	get_tree().debug_collisions_hint = true
