extends Node2D

var label
var caveman_ally
var caveman_ally_instance
var caveman_ally_instances = []
var active_enemy_sprites = []
var movement_speed = 50
var movement_queue = []
var target_position_enemy_base = Vector2(980, 576)

var caveman_enemy
var caveman_enemy_instance
var target_position_ally_base = Vector2(150, 576)


func _ready():
	var area_2d_ally = get_node_or_null("Caveman Ally/Area2D")
	if area_2d_ally == null:
		print("Area2D node not found")
	else:
		area_2d_ally.connect("area_entered", Callable(self, "_on_area_2d_area_entered"))
		area_2d_ally.connect("area_exited", Callable(self, "_on_area_2d_area_exited"))
		
	var area_2d_enemy = get_node_or_null("Caveman Enemy/Area2D")
	if area_2d_enemy == null:
		print("Area2D node not found")
	else:
		area_2d_enemy.connect("area_entered", Callable(self, "_on_area_2d_area_entered"))
		area_2d_enemy.connect("area_exited", Callable(self, "_on_area_2d_area_exited"))


	label = get_node("Money Value")
	if label == null:
		print("Label node not found")
	else:
		print("Label node found: ", label)
		
	caveman_ally = preload("res://caveman_ally.tscn")
	if caveman_ally == null:
		print("Failed to preload caveman_all.tscn")
	else:
		print("caveman_ally.tscn preloaded successfully")
		
	caveman_enemy = preload("res://caveman_enemy.tscn")
	if caveman_enemy == null:
		print("Failed to preload caveman_enemy.tscn")
	else:
		print("caveman_enemy.tscn preloaded successfully")
		
	var timer = get_node("Caveman Enemy Spawn Timer")
	if timer != null:
		timer.wait_time = 5
		timer.start()
	else:
		print("Timer node not found")


func _on_buy_warrior_pressed():
	var value = int(label.text)
	if value >= 100:
		value -= 100
		label.text = str(value)
		add_caveman_ally()
	else:
		print("Value less than 100, not updating label.")


func add_caveman_ally():
	caveman_ally_instance = caveman_ally.instantiate()
	if caveman_ally_instance != null:
		add_child(caveman_ally_instance)
		caveman_ally_instance.position = Vector2(129,576)
		caveman_ally_instances.append(caveman_ally_instance)
	else:
		print("Failed to instance caveman_ally")


func _process(_delta):
	for caveman in caveman_ally_instances:
		if caveman.moving:
			if caveman.position.x >= target_position_enemy_base.x:
				caveman.stop_movement()

	for sprite in active_enemy_sprites:
		if sprite.moving:
			if sprite.position.x <= target_position_ally_base.x:
				sprite.stop_movement()


func _on_caveman_enemy_spawn_timer_timeout():
	# Instance the caveman_enemy
	caveman_enemy_instance = caveman_enemy.instantiate()
	if caveman_enemy_instance != null:
		add_child(caveman_enemy_instance)
		caveman_enemy_instance.position = Vector2(1000, 576)
		# Add the newly created sprite to the list of active sprites
		active_enemy_sprites.append(caveman_enemy_instance)
	else:
		print("Failed to instance caveman_enemy")


func _on_main_menu_button_pressed():
	get_tree().change_scene_to_file("res://main.tscn")
