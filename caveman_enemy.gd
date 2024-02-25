extends Node2D


var moving = true

func start_movement():
	moving = true

func stop_movement():
	moving = false

func _process(delta):
	if moving:
		position.x -=  50 * delta


func _on_area_2d_area_entered(area):
	stop_movement()


func _on_area_2d_area_exited(area):
	start_movement()
