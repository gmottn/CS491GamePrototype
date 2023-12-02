extends "res://Battles/Attacks/AttackScripts/AttackBase.gd"





# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	#define these per attack
	targetSpots = []
	#splashSpots = [[1,1],[1,-1],[-1,1],[-1,-1],[2,2],[2,-2],[-2,2],[-2,-2]]
	splashSpots = []
	damage = 30 # base damage
	statusEffects = []
	splashDegredation = 1
	maxDepth = 1
	mpCost = 25
	description = "Zap an enemy with a lightning bolt, shocks those adjacent"
	subDescription = "hits a target and any target next to that target, chaining together"
	#leave these alone

	initialize_attack()
	# Replace with function body.




func attack_code(gridSlot, ignore = []): # overide
	gridSlot.perform_damage(self)
	ignore.append(gridSlot.entity)
	for y in range(3):
		for x in range(3):
			var column = y-1
			var row = x - 1
			if(row == 0 and column == 0):
				continue
			var t = gridSlot.location
			var check = [gridSlot.location[0] + row, gridSlot.location[1] + column]
			var slot = gridManager.get_slot(check, gridSlot.affiliation)
			if (is_instance_valid(slot) and is_instance_valid(slot.entity) and !(in_list(ignore,slot.entity))):
				attack_code(slot,ignore)

func target_code():
	set_all_targets()
func in_list(list,check):
	for i in list:
		if i == check:
			return true
	return false

#lave this function alone

