extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var attackName = null

# Called when the node enters the scene tree for the first time.
func _ready():
	find_attack_script()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func find_attack_script():
	#print("Attack startup works")
	if attackName == null:
		assert("Attack was not defined for me to be")
	var attackScript = load("res://Battles/Attacks/AttackScripts/" + attackName + ".gd")
	self.script = attackScript
	call_deferred("initialize_attack")
