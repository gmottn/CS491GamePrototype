extends "res://Battles/Attacks/AttackClickable/AttackClickable.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$Label.text = "X" + str(attack.amount)
func _on_state_changed_triggered():
	attack.depth = 0
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
