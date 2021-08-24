extends Node2D

onready var ultrasonic: DistanceMeter2D = $Platform/RayCast2D
onready var servo = $Servo

export var P := 0.55
export var I := 0.002
export var D := 0.1

export var eP := true
export var eI := true
export var eD := true

export var distance_setpoint := 101.294014

var error = 0
var last_measurement = 0
var integral_error = 0
var ball_velocity = 0

func _physics_process(delta):
	
	if ultrasonic.result != 0:
		ball_velocity = (last_measurement - ultrasonic.result) / delta
		error = ultrasonic.result - distance_setpoint
		servo.deg_setpoint = (error * P * int(eP)) + (integral_error * I * int(eI)) + (ball_velocity * (-D) * int(eD))
		last_measurement = ultrasonic.result
		integral_error += error
		
	print(error)

