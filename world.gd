extends Node2D

var label
var caveman_ally
var caveman_ally_instance
var caveman_ally_instances = []
var active_sprites = []  # Array to store active sprites
var active_enemy_sprites = []
var movement_speed = 50
var target_position_enemy_base = Vector2(980, 576)

var caveman_enemy
var caveman_enemy_instance
var target_position_ally_base = Vector2(150, 576)

# Called when the node enters the scene tree for the first time.
func _ready():
	var area_2d = $caveman_ally/Area2D  # Accessing the Area2D node within the caveman_ally scene
	
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
		# Start the timer to spawn caveman_enemy every 5 seconds
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
		active_sprites.append(caveman_ally_instance)
		caveman_ally_instances.append(caveman_ally_instance)
		connect_area2d_signals(caveman_ally_instance)
	else:
		print("Failed to instance caveman_ally")

func _process(delta):
	for sprite in active_sprites:
		# Check if sprite is not null before accessing its properties
		if sprite != null:
			sprite.position.x += movement_speed * delta
			# Check if the sprite reaches the target position
			if sprite.position.x >= target_position_enemy_base.x:
				# Remove the sprite from the list of active sprites
				active_sprites.erase(sprite)

	for sprite in active_enemy_sprites:
		if sprite != null:
			sprite.position.x -= movement_speed * delta
		if sprite.position.x <= target_position_ally_base.x:
			active_enemy_sprites.erase(sprite)
			
			

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

# Added function to handle area entered
func _on_area_2d_area_entered(area, node):
	if area.is_in_group("caveman_ally") and node in caveman_ally_instances:
		movement_speed = 0

# Added function to handle area exited
func _on_area_2d_area_exited(area, node):
	if area.is_in_group("caveman_ally") and node in caveman_ally_instances:
		movement_speed = 50
	
func connect_area2d_signals(node):
	var area_2d = node.get_node("Area2D")
	if area_2d != null:
		area_2d.connect("body_entered", _on_area_2d_area_entered, 1)
		area_2d.connect("body_entered", _on_area_2d_area_exited, 1)
