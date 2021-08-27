extends Node2D

onready var ultrasonic: DistanceMeter2D = $Platform/RayCast2D
onready var servo = $Servo

export var P := 0.55
export var I := 0.002
export var D := 0.1

export var eP := true
export var eI := true
export var eD := true

export(float) var distance_deg_setpoint = 101.29

var error := 0.0
var measurement := 0.0
var last_measurement := 0.0
var integral_error := 0
var ball_velocity := 0
var deg_setpoint := 0

func get_measurement(delta):
	if ultrasonic.result < 1000:
		last_measurement = measurement
		measurement = ultrasonic.result
		ball_velocity = lerp(ball_velocity, (last_measurement - measurement) / delta, 0.3)
		error = measurement - distance_deg_setpoint
		deg_setpoint = (error*P*int(eP)) + (integral_error*I*int(eI)) + (ball_velocity*(-D)*int(eD))
		integral_error += error

func _physics_process(delta):
	get_measurement(delta)
	
	servo.rotate_to(deg_setpoint)
	
#	print(error)

