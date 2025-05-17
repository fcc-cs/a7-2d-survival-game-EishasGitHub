extends CharacterBody2D

signal stick_collected
signal apple_collected
signal slime_collected

var speed = 100
var player_state
var bow_equipped = false
var bow_cooldown = true
var mouse_loc_from_player = null

@export var inv: Inv
@onready var camera = $Camera2D

var arrow = preload("res://scene/arrow.tscn")

func _physics_process(delta: float) -> void:
	
	mouse_loc_from_player = get_global_mouse_position() - self.position
	#print(mouse_loc_from_player)
	
	var direction = Input.get_vector("left", "right", "up", "down")
	
	if (direction.x == 0) and (direction.y == 0):
		player_state = "idle"
		
	elif (direction.x != 0) or (direction.y != 0):
		player_state = "walking"
		
	velocity = direction * speed
	move_and_slide()
	
	if (Input.is_action_just_pressed("e")):
		if (bow_equipped):
			bow_equipped = false
			
		else:
			bow_equipped = true
	
	var mouse_pos = get_global_mouse_position()
	$Marker2D.look_at(mouse_pos)
	
	if (Input.is_action_just_pressed("left_mouse")) and (bow_equipped) and (bow_cooldown):
		bow_cooldown = false
		
		var arrow_instance = arrow.instantiate()
		arrow_instance.rotation = $'Marker2D'.rotation
		arrow_instance.global_position = $Marker2D.global_position
		
		add_child(arrow_instance)
		
		await get_tree().create_timer(0.4).timeout
		bow_cooldown = true
	
	play_anim(direction)
	
func play_anim(dir):
	if !bow_equipped:
		speed = 100
		
		if player_state == "idle":
			$AnimatedSprite2D.play("idle")
			
		if player_state == "walking":
			
			if dir.y == -1:
				$AnimatedSprite2D.play("n-walk")
			
			if dir.x == 1:
				$AnimatedSprite2D.play("e-walk")
				
			if dir.y == 1:
				$AnimatedSprite2D.play("s-walk")

			if dir.x == -1:
				$AnimatedSprite2D.play("w-walk")
				
			if (dir.x > 0.5) and (dir.y < -0.5):
				$AnimatedSprite2D.play("ne-walk")
				
			if (dir.x > 0.5) and (dir.y > 0.5):
				$AnimatedSprite2D.play("se-walk")
				
			if (dir.x < -0.5) and (dir.y > 0.5):
				$AnimatedSprite2D.play("sw-walk")
				
			if (dir.x < -0.5) and (dir.y < -0.5):
				$AnimatedSprite2D.play("nw-walk")
	
	if bow_equipped:
		speed = 0
		
		if (mouse_loc_from_player.x >= -25) and (mouse_loc_from_player.x <= 25) and (mouse_loc_from_player.y < 0):
			$AnimatedSprite2D.play("n-attack")

		if (mouse_loc_from_player.y >= -25) and (mouse_loc_from_player.y <= 25) and (mouse_loc_from_player.x > 0):
			$AnimatedSprite2D.play("e-attack")
	
		if (mouse_loc_from_player.x >= -25) and (mouse_loc_from_player.x <= 25) and (mouse_loc_from_player.y > 0):
			$AnimatedSprite2D.play("s-attack")
		
		if (mouse_loc_from_player.y >= -25) and (mouse_loc_from_player.y <= 25) and (mouse_loc_from_player.x < 0):
			$AnimatedSprite2D.play("w-attack")
			
		if (mouse_loc_from_player.x >= 25) and (mouse_loc_from_player.y <= -25):
			$AnimatedSprite2D.play("ne-attack")
			
		if (mouse_loc_from_player.x >= 0.5) and (mouse_loc_from_player.y >= 25):
			$AnimatedSprite2D.play("se-attack")
			
		if (mouse_loc_from_player.x <= -0.5) and (mouse_loc_from_player.y >= 25):
			$AnimatedSprite2D.play("sw-attack")
			
		if (mouse_loc_from_player.x <= -25) and (mouse_loc_from_player.y <= -25):
			$AnimatedSprite2D.play("nw-attack")
			
func player():
	pass

func collect(item):
	inv.insert(item)
	#print(item)
	if str(item) == "<Resource#-9223372003233233473>": #stick
		#print("PICKED UP STICK")
		emit_signal("stick_collected")
		
	if str(item) == "<Resource#-9223372004139203147>": #apple
		#print("PICKED UP APPLE")
		emit_signal("apple_collected")
	
	if str(item) == "<Resource#-9223372002193046070>": #slime
		#print("PICKED UP SLIME")
		emit_signal("slime_collected")
