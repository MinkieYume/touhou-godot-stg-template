extends Area2D

signal graze

func get_collision_shape():
	return $CollisionShape2D.shape
