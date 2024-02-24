extends Node2D

var movement_speed

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_2d_area_entered(area):
	movement_speed = 0


func _on_area_2d_area_exited(area):
	movement_speed = 50
