extends Node2D
var battleEntityScene = preload("res://Battles/BattleEntities/BattleEntity.gd")
signal state_changed(newState,oldState)
signal depth_changed(newDepth)
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
#Hero = hero turn
#Enemy = enemy turn
#Targeting = Player is deciding on target
#PerformingAttack = attack is currently in progress
var heroes = []
var enemies = []
var gridManager = null
enum battleStates {
	HERO,
	ENEMY,
	TARGETING,
	PERFORMING_ATTACK,
	SLOT_SELECTED
}
var turn = "hero"
var gameState = battleStates.HERO

var baseAttacker = null

var frameCounter = 0;
var changeState = false;
var stateToChangeTo = null;

# Called when the node enters the scene tree for the first time.
func _ready():
	gridManager = get_tree().get_root().find_node("GridManager",true,false)
	battleEntityScene.connect("entity_deactivated",self,"_on_enity_deactivated_triggered")
	


# Called every frame. 'delta' is the elapsed time since the previous frame.

			
			
func changeState(state):
	print("State was changed")
	print(state)
	gameState = convert_to_state(state)
	if(gameState == battleStates.HERO):
		turn = "hero"
	elif(gameState == battleStates.ENEMY):
		turn = "enemy"
	$Label.text = str(gameState)
	$Label.modulate = Color(1,1,1,1)
	emit_signal("state_changed")

	

func _input(event):
	if event is InputEventKey:
		if event.pressed:
			if event.scancode == KEY_BACKSPACE:
				
				if(gameState == battleStates.SLOT_SELECTED):
					changeState("hero")
func is_state(checkState):
	checkState = convert_to_state(checkState)
	
	if(checkState == gameState):
		return true
	else:
		return false
	
# converts a string into its corresponding state, null if that state is not available
func convert_to_state(stateString):
		#print(stateString)
		stateString = stateString.to_lower()
		stateString.replace(" ", "")
		if(stateString == "hero"):
			return battleStates.HERO
		elif(stateString == "enemy"):
			return battleStates.ENEMY
		elif(stateString == "targeting"):
			return battleStates.TARGETING
		elif(stateString == "performingattack"):
			return battleStates.PERFORMING_ATTACK
		elif(stateString == "slotselected"):
			return battleStates.SLOT_SELECTED
		else:
			push_error("ERROR invalid state checked")
			return null
func activate_heroes():
	for hero in heroes:
		if(is_instance_valid(hero) and !hero.dead):
			hero.active = true;
func activate_enemies():
	for enemy in enemies:
		if(is_instance_valid(enemy)):
			enemy.active = true;
func add_entity(entity):
	
	if(entity.affiliation == "hero"):
		heroes.append(entity)
		entity.active = true
	else:
		enemies.append(entity)
func _on_enity_deactivated_triggered(entity):
	print("ENTITY DEACTIVATED")
	if(turn == "hero"):
		if(is_hero_turn_over()):
			changeState("enemy")
			activate_enemies()
			activate_enemy_AI()
		else:
			changeState("hero")
	else:
		if(is_enemy_turn_over()):
			changeState("hero")
			activate_heroes()
		else:
			changeState("enemy")
func is_hero_turn_over():
	for hero in heroes:
		if(is_instance_valid(hero) and hero.active):
			return false
	return true
func is_enemy_turn_over():
	for enemy in enemies:
		if(is_instance_valid(enemy) and enemy.active):
			return false
	return true

func activate_enemy_AI():
	enemies[0].AI.activate(enemies.duplicate())
func is_turn(check):
	return check == turn
