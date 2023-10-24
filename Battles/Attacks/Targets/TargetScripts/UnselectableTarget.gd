extends "res://Battles/Attacks/Targets/TargetScripts/Target.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var blue = Color(0,0,1,1)
	$Sprite.modulate = blue
func _on_Area2D_mouse_exited():
	pass

func _on_Area2D_input_event(viewport, event, shape_idx):
	pass
func _on_Area2D_mouse_entered():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
