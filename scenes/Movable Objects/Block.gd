extends RigidBody2D

class_name MovableBlock 
#func added to make the movable object not rotate while being pushed
func _integrate_forces(state: Physics2DDirectBodyState) -> void:
	angular_velocity = 0
	rotation_degrees = 0 

