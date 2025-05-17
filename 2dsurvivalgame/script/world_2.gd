extends Node2D

@onready var animplayer = $world2openingcutscene/AnimationPlayer
@onready var camera = $world2openingcutscene/Path2D/PathFollow2D/Camera2D

var is_openingcutscene = false
var has_player_entered_area = false
var player = null
var is_pathfollowing = false
var smoke_has_happened = false
var smoke_is_happening = false

func _physics_process(delta: float) -> void:
	if (is_openingcutscene):
		var pathfollower = $world2openingcutscene/Path2D/PathFollow2D
		
		if (is_pathfollowing):
			pathfollower.progress_ratio += 0.001
			
			if (pathfollower.progress_ratio >= 1):
				cutsceneclosing()

func _on_player_detection_body_entered(body: Node2D) -> void:
	if (body.has_method("player")):
		player = body
		
		if (!has_player_entered_area):
			has_player_entered_area = true
			cutsceneopening()

func cutsceneopening():
	is_openingcutscene = true
	animplayer.play("cover_fade")
	player.camera.enabled = false
	camera.enabled = true
	is_pathfollowing = true

func cutsceneclosing():
	is_pathfollowing = false
	is_openingcutscene = false
	camera.enabled = false
	player.camera.enabled = true
	
	$world2openingcutscene.visible = false
	$world2main.visible = true
