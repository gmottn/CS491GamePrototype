extends Node2D
var battleEntityScene = preload("res://Battles/BattleEntities/BattleEntity.gd")
var itemScene = preload("res://Battles/Attacks/Item.tscn")
signal state_changed(newState,oldState)
signal depth_changed(newDepth)
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
#Hero = hero turn
#Enemy = enemy turn
#Targeting = Player is deciding on target
#PerformingAttack = attack is currently in progress
var player = null
var inventory = null
var equipment = null
var stats = null
var heroes = []
var enemies = []
var goldWon = 0;
var gridManager = null
var UI = null
enum battleStates {
	HERO,
	ENEMY,
	TARGETING,
	PERFORMING_ATTACK,
	SLOT_SELECTED,
	FINISHED
	
}
var turn = "hero"
var gameState = battleStates.HERO

var baseAttacker = null

var frameCounter = 0;
var changeState = false;
var stateToChangeTo = null;

var strengthBonus = 0
var defenseBonus = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	gridManager = get_tree().get_root().find_node("GridManager",true,false)
	battleEntityScene.connect("entity_deactivated",self,"_on_enity_deactivated_triggered")
	battleEntityScene.connect("entity_dead",self,"_on_enity_dead_triggered")
	UI = gridManager.get_node("UI_Layer").get_node("Panel")
	stats = get_parent().stats
	inventory = get_parent().player.inventory_data
	equipment = get_parent().player.equipment_data
	set_up_items()
	set_up_equipment()


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
		elif(stateString == "finished"):
			return battleStates.FINISHED
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
	if(!is_state("finished")):
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

func _on_enity_dead_triggered(entity):
	if(entity.affiliation == "hero"):
		if(is_lose()):
			lose_code()
	else:
		goldWon += entity.gold
		if(is_win()):
			win_code()
func is_lose():
	for hero in heroes:
		if(!hero.dead):
			return false
	return true
func lose_code():
	changeState("finished");
	UI.update_message("Battle Lost!", "Your team lost " + str(goldWon) + " gold")
	$TransitionTimer.start(3)
func is_win():
	if(enemies.size() == 0):
		return true
	else:
		return false
func win_code():
		changeState("finished");
		UI.update_message("Battle Won!", "Your team gained " + str(goldWon) + " gold")
		$TransitionTimer.start(3)
	


func _on_TransitionTimer_timeout():
	transition_to_overworld()
func transition_to_overworld():
	get_parent().transition_to_overworld()
func set_up_items():
	for item in inventory.Data:
		if(is_instance_valid(item) and !(item.item_data is EquipmentData)):
			var existingButton = UI.get_node("Items").exists(item.item_data.name)
			if(is_instance_valid(existingButton)):
				existingButton.attack.amount += item.stack_size
			else:
				create_item(item.item_data.name,item.stack_size)
func create_item(itemName, amount):
	
	var itemInstance = itemScene.instance()
	var itemScript = find_item_script(itemName)
	
	itemInstance.script = itemScript
	itemInstance.amount = amount
	add_child(itemInstance)
	
	return itemInstance
func find_item_script(itemName):
	#print("Attack startup works")
	if itemName == null:
		assert("item was not defined for me to be")
	var itemScript = load("res://Battles/Attacks/ItemScripts/" + itemName + ".gd")
	return itemScript
func deduct_from_inventory(name):
	for item in inventory.Data:
		if(is_instance_valid(item)):
			
			if item.item_data.name == name and item.stack_size > 0:
				item.stack_size = item.stack_size - 1
				inventory.emit()
				break;
func set_up_equipment():
	for equip in equipment.Data:
		if(is_instance_valid(equip)):
			strengthBonus += equip.item_data.attack
			defenseBonus += equip.item_data.defense
				
		
func get_stats_for(name):
	return stats.get_node(name)	
