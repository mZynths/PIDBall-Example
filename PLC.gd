extends Node2D

onready var ultrasonic: DistanceMeter2D = $Platform/RayCast2D
onready var servo = $Servo

export var P := 0.55
export var I := 0.002
export var D := 0.1

export var eP := true
export var eI := true
export var eD := true

export(float) var distance_setpoint = 120 setget set_setpoint

var error := 0.0
var measurement := 0.0
var last_measurement := 0.0
var integral_error := 0
var ball_velocity := 0
var deg_setpoint := 0

var currentBall: Object = null

func get_measurement(delta):
	if ultrasonic.result < 1000:
		last_measurement = measurement
		measurement = ultrasonic.result
		ball_velocity = lerp(ball_velocity, (last_measurement - measurement) / delta, 0.3)
		error = measurement - (distance_setpoint-20)
		deg_setpoint = (error*P*int(eP)) + (integral_error*I*int(eI)) + (ball_velocity*(-D)*int(eD))
		integral_error += error

func _physics_process(delta):
	currentBall = ultrasonic.get_collider()
	get_measurement(delta)
	servo.rotate_to(deg_setpoint)

func _on_ReloadBtn_pressed():
	get_tree().change_scene("res://World.tscn")

func _on_SetpointVal_value_changed(value):
	distance_setpoint = 240 - value

func _on_PVal_value_changed(value):
	P = value

func _on_IVal_value_changed(value):
	I = value

func _on_DVal_value_changed(value):
	D = value

func _on_PCheck_toggled(state):
	eP = state

func _on_ICheck_toggled(state):
	eI = state

func _on_DCheck_toggled(state):
	eD = state

func _on_RndSetpointBtn_pressed():
	self.distance_setpoint = int(rand_range(30, 210)/5)*5

func set_setpoint(new_value):
	distance_setpoint = new_value
	get_parent().get_node("Menu/Setpoint/SetpointVal").value = distance_setpoint

func _on_RndImpulseBtn_pressed():
	if currentBall is Ball:
		var angle_error = rand_range(-70, 70)
		var angle = rad2deg(atan2(100, 100 - ultrasonic.result)) + angle_error
		var magnitude = rand_range(-250, -300)
		var impulse = Vector2()
		
		impulse.x = cos(deg2rad(angle)) * magnitude
		impulse.y = sin(deg2rad(angle)) * magnitude
		
		currentBall.apply_central_impulse(impulse)

