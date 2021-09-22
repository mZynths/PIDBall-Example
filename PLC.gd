extends Node2D

onready var ultrasonic: DistanceMeter2D = $Platform/RayCast2D
onready var servo = $Servo

var P := 0.75
var I := 0.006
var D := 0.375

var maxIntegralError = 0.6
var eAntiWindup := true

var eP := true
var eI := true
var eD := true

export(float) var distance_setpoint = 120 setget set_setpoint

export var randomImpulseOnArrival := false
export var randomSetpointOnArrival := false
export var arrivalTime := 0.50

var stableStateError = 0.1

var error := 0.0
var measurement := 0.0
var last_measurement := 0.0
var integral_error := 0.0
var ball_velocity := 0.0
var deg_setpoint := 0.0

var current_ball: Object = null

var elapsed_arrival_time := 0.00
var passed_setpoint := false

func get_measurement(delta):
	if ultrasonic.get_collider() != null:
		last_measurement = measurement
		measurement = ultrasonic.result
		ball_velocity = lerp(ball_velocity, (last_measurement - measurement) / delta, 0.3)
		error = measurement - (distance_setpoint-10)
		deg_setpoint = (error*P*int(eP)) + (integral_error) + (ball_velocity*(-D)*int(eD))
		integral_error = (integral_error + error*I) * int(eI)
		if eAntiWindup:
			integral_error = clamp(integral_error, -maxIntegralError, maxIntegralError)

func _process(delta):
	if is_inside_tree():
		get_parent().get_node("Menu/HBoxContainer/Error").text = str(stepify(error, 0.01))

func _physics_process(delta):
	current_ball = ultrasonic.get_collider()
	get_measurement(delta)
	servo.rotate_to(deg_setpoint)
	
	elapsed_arrival_time += delta
	if abs(error) < stableStateError and passed_setpoint == false:
		passed_setpoint = true
		elapsed_arrival_time = 0
	
	if passed_setpoint and elapsed_arrival_time > arrivalTime:
		if abs(error) < 1:
			on_arrival()
			elapsed_arrival_time = 0
			passed_setpoint = false
		else:
			elapsed_arrival_time = 0
			passed_setpoint = false

func on_arrival():
	if randomImpulseOnArrival: doRandomBallImpulse()
	if randomSetpointOnArrival: randomize_setpoint()
	

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

func _on_AWVal_value_changed(value):
	maxIntegralError = value

func _on_PCheck_toggled(state):
	eP = state

func _on_ICheck_toggled(state):
	eI = state

func _on_DCheck_toggled(state):
	eD = state

func _on_AWCheck_toggled(state):
	eAntiWindup = state

func _on_RndSetpointBtn_pressed():
	randomize_setpoint()

func set_setpoint(new_value):
	distance_setpoint = new_value
	get_parent().get_node("Menu/TabContainer/PID/Setpoint/SetpointVal").value = distance_setpoint

func randomize_setpoint():
	self.distance_setpoint = int(rand_range(30, 210) / 5) * 5

func doRandomBallImpulse():
	if current_ball is Ball:
		var angle_error = rand_range(-35, 35)
		var angle = rad2deg(atan2(100, 100 - ultrasonic.result)) + angle_error
		var magnitude = -rand_range(40, 100)
		var impulse = Vector2()
		
		impulse.x = cos(deg2rad(angle)) * magnitude
		impulse.y = sin(deg2rad(angle)) * magnitude
		
		current_ball.apply_central_impulse(impulse)

func _on_RndImpulseBtn_pressed():
	doRandomBallImpulse()

func _on_RandomImpulse_toggled(button_pressed):
	randomImpulseOnArrival = button_pressed

func _on_RandomSetpoint_toggled(button_pressed):
	randomSetpointOnArrival = button_pressed



