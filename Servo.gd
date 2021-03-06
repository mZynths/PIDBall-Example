extends RigidBody2D

class_name Servo2D

export var deg_setpoint := 0.0
export var max_ang_velocity := 10
export var max_ang = 76
export var min_ang = -104

func _physics_process(delta):
	angular_velocity = deg_setpoint - rotation_degrees
	angular_velocity = clamp(angular_velocity, -max_ang_velocity, max_ang_velocity)

func rotate_to(deg):
	deg_setpoint = clamp(deg, min_ang, max_ang)

func _on_ServoSpeedVal_value_changed(value):
	max_ang_velocity = value
