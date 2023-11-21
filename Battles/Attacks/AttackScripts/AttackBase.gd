extends "res://Battles/GridManager/BattleElement.gd"

var attackClickableScene = preload("res://Battles/Attacks/AttackClickable/AttackClickable.tscn")
var targetSpots = []# edit
var targets = []
var splashSpots = [] # edit
var caster = null
var affiliation = null
var damage = 0 # base damage # edit
var statusEffects = [] # edit
var splashDegredation = 1 # edit
var maxDepth = 0 # edit
var depth = 0 # depth >= 1 means selected
var attackClickable = null
var attackClickableNumber = 1
var knockback = [0,0]
var isItem = false;
var attackName = null
var mpCost = 0



func _ready():
	attackName = self.get_script().resource_path.get_file().get_basename()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func enough_MP():
	if(caster.mp >= mpCost):
		return true
	else:
		UI.temp_message("Not enough MP", "", 2)
		return false
func deduct_MP():
	caster.mp -= mpCost

func attack_code(gridSlot): # overide
	deduct_MP()
	gridSlot.perform_damage(self)



	
func set_all_targets():
	
	if(affiliation == "hero"):
		targetSpots = gridManager.get_all_enemy_slots()
	else:
		targetSpots = gridManager.get_all_hero_slots()
	#print(targetSpots)
	create_targets(targetSpots)
	#battleManager.changeState("Targeting")
func create_targets(targetSlots):
	var targetType = ""
	if(maxDepth == 0):
		targetType = "Unselectable"
	targets = gridManager.create_targets(targetSlots,self,targetType,1)

		
func set_position_dependent_targets(opposing = true):
	var location = caster.gridSlot.location
	var newSpots = []
	for spot in targetSpots:
		var slot = null
		if(opposing):
			slot = get_opposing_grid_slot([spot[0] + location[0],spot[1] + location[1]])
		else:
			slot = get_my_grid_slot([spot[0] + location[0],spot[1] + location[1]])
		if slot != null:
			newSpots.append(slot)
	create_targets(newSpots)
func set_specific_targets(opposing = true):
	var newSpots = []
	var slot = null 
	for spot in targetSpots:
		if(opposing):
			slot = get_opposing_grid_slot(spot)
		else:
			slot = get_my_grid_slot(spot)
		if slot != null:
			newSpots.append(slot)
	create_targets(newSpots)
func target_code():
	set_position_dependent_targets()
func target_removal_code():
	print("DEAD")
	for target in targets:
		if(is_instance_valid(target)):
			target.delete_self()
	targets = []
func delete_self():
	target_removal_code()
	queue_free()
func update_depth(increment):
	if(increment == -1):
		print("DEPTH TESTTTTTTTTTTTTTTTTTTTT")
	depth += increment
	print(depth)
	if(depth <=0):
		depth = 0
		target_removal_code()
	else:
		validate_targets()
	if(depth > maxDepth):
		perform_attack()
		
func validate_targets():
	for target in targets:
		if(is_instance_valid(target)):
			target.validate_self()
func _input(event):
	if event is InputEventKey and depth >= 1:
		if event.pressed:
			if Input.is_action_just_pressed("ui_cancel"):
				
				if(battleManager.is_state("targeting")):
					update_depth(-1)
					if(depth == 0):
						print(self)
						battleManager.changeState("SlotSelected")
					
						
						
func perform_attack():
	
	for target in targets:
		target.perform_attack()
	caster.active = false
	
	print("I Changed It")
func get_opposing_grid_slot(slotLocation):
	if(affiliation == "hero"):
		return gridManager.get_slot(slotLocation,"enemy")
	else:
		return gridManager.get_slot(slotLocation,"hero")
func get_my_grid_slot(slotLocation):
	return gridManager.get_slot(slotLocation,affiliation)
func initialize_attack():
	
	caster = get_parent()
	if(attackName == "Move"):
		attackClickable = UI.get_node("MoveButton")
	else:
		attackClickable = attackClickableScene.instance()
	
	attackClickable.attack = self
	if(attackName != "Move"):
		if(isItem):
			gridManager.get_node("UI_Layer/Panel/Items").add_child(attackClickable)
		else:
			gridManager.get_node("UI_Layer/Panel/Attacks").add_child(attackClickable)
	
	affiliation = caster.affiliation
	if affiliation == "hero":
		for spots in splashSpots:
			print("added")
			spots[0] *= -1
