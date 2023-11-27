extends "res://Battles/Attacks/Targets/TargetScripts/Target.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	type = "Unselectable"
	var blue = Color(0,0,1,1)
	$Sprite.modulate = blue
func _on_Area2D_mouse_exited(AIPass = false):
	pass

func _on_Area2D_input_event(viewport, event, shape_idx,AIPass = false):
	pass
func _on_Area2D_mouse_entered(AIPass = false):
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
