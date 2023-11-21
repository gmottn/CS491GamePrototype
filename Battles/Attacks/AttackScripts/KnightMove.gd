extends "res://Battles/Attacks/AttackScripts/AttackBase.gd"





# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	#define these per attack
	targetSpots = [[2,1],[-2,1],[2,-1],[-2,-1]]
	splashSpots = []
	damage = 1002 # base damage
	statusEffects = []
	splashDegredation = 0.8
	maxDepth = 1
	
	#leave these alone
	
	initialize_attack()
	# Replace with function body.




func attack_code(gridSlot): # overide
	gridManager.transfer_entity(caster.gridSlot,gridSlot)
func target_code():
	set_position_dependent_targets(false)


#lave this function alone

func create_targets(targetSlots):
	var targetType = "Move"
	targets = gridManager.create_targets(targetSlots,self,targetType,1)
