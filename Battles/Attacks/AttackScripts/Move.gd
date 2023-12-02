extends "res://Battles/Attacks/AttackScripts/AttackBase.gd"





# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	#define these per attack
	
	splashSpots = []
	damage = 0 # base damage
	statusEffects = []
	splashDegredation = 1
	maxDepth = 1
	description = "Move this hero"
	subDescription = ""
	#leave these alone

	initialize_attack()
	# Replace with function body.
	targetSpots = caster.moveSpots



func attack_code(gridSlot): # overide
	gridManager.transfer_entity(caster.gridSlot,gridSlot)
func target_code():
	set_position_dependent_targets(false)


#lave this function alone

func create_targets(targetSlots, num = 1):
	targetSlots = filter_targetSlots(targetSlots)
	var targetType = "Move"
	targets = gridManager.create_targets(targetSlots,self,targetType,1)
func filter_targetSlots(targetSlots):
	for slot in targetSlots:
		if slot.entity != null:
			targetSlots.erase(slot)
	return targetSlots
