extends Area2D

signal hit(obj)

func get_collision_shape():
	return $CollisionShape2D.shape
