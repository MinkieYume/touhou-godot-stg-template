extends Node2D


func _process(delta):
	$FPS.text = str(Engine.get_frames_per_second())+" FPS\n"+str(Spawning.poolBullets.size())
