extends Node2D

signal state_changed(newState,oldState)
signal depth_changed(newDepth)
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
#Hero = hero turn
#Enemy = enemy turn
#Targeting = Player is deciding on target
#PerformingAttack = attack is currently in progress
var gridManager = null
var validStates = ["Hero", "Enemy", "Targeting", "PerformingAttack","SlotSelected"]
var gameState = "Hero"
var baseAttacker = null


# Called when the node enters the scene tree for the first time.
func _ready():
	gridManager = get_tree().get_root().find_node("GridManager",true,false)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func changeState(state):
	if state in validStates:
		print("State was changed")
		print(state)
		emit_signal("state_changed",state,gameState)
		gameState = state

		if(state == "Attacking"):
			perform_attack()
	else:
		assert("Gabe's Error: error wrong state inputted")
		
func _input(event):
	if event is InputEventKey:
		if event.pressed:
			if event.scancode == KEY_BACKSPACE:
				
				if(gameState == "SlotSelected"):
					
					changeState("Hero")
		

func perform_attack():
	for attacker in baseAttacker:
		attacker.perform_damage(true)
	baseAttacker = null
	
	
	
