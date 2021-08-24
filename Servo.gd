extends RigidBody2D

class_name Servo2D

export var deg_setpoint := 0.0
export var max_ang_velocity := 20.0

var integral = 0

func _physics_process(delta):
	rotation_degrees = clamp(rotation_degrees, -90, 90)
	angular_velocity = deg_setpoint - rotation_degrees
	angular_velocity = clamp(angular_velocity, -max_ang_velocity, max_ang_velocity)
