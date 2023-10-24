extends Node
var battleManager = null
var gridManager = null
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
var depth = 0
var attackClickable = null
var attackClickableNumber = 1



func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func attack_code(gridSlot): # overide
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

		
func set_position_dependent_targets():
	var location = caster.gridSlot.location
	var newSpots = []
	for spot in targetSpots:
		var slot = get_opposing_grid_slot([spot[0] + location[0],spot[1] + location[1]])
		if slot != null:
			newSpots.append(slot)
	create_targets(newSpots)
		
		
	
func target_code():
	set_position_dependent_targets()
func target_removal_code():
	print("DEAD")
	for target in targets:
		target.delete_self()
func update_depth(increment):
	depth += increment
	validate_targets()
	if(depth > maxDepth):
		perform_attack()
		
func validate_targets():
	for target in targets:
		target.validate_self()
func _input(event):
	if event is InputEventKey:
		if event.pressed:
			if event.scancode == KEY_BACKSPACE:
				
				if(battleManager.gameState == "Targeting"):
					if(depth == 0):
						battleManager.changeState("SlotSelected")
					else:
						update_depth(-1)
						
func perform_attack():
	for target in targets:
		target.perform_attack()
	battleManager.changeState("Hero")
func get_opposing_grid_slot(slotLocation):
	if(affiliation == "Hero"):
		return gridManager.get_slot(slotLocation,"Enemy")
	else:
		return gridManager.get_slot(slotLocation,"Hero")
func get_my_grid_slot(slotLocation):
	return gridManager.get_slot(slotLocation,affiliation)
