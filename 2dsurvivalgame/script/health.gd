extends Control

signal no_health


var current_health = MAX_HEALTH

const MAX_HEALTH = 3
const  MIN_HEALTH = 0
const  DAMAGE = 1

@onready var bars_container = $NinePatchRect/GridContainer 

func damage():
	if (current_health > MIN_HEALTH):
		current_health = current_health - DAMAGE
		ui_update()
		
	if (current_health <= MIN_HEALTH):
		emit_signal("no_health")
		
func ui_update():
		for i in range(bars_container.get_child_count()):
			var bar = bars_container.get_child(i)
			
			if (i < current_health):
				bar.visible = true
			
			else:
				bar.visible = false

func reset_health():
	current_health = MAX_HEALTH
	ui_update()
