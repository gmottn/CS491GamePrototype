extends "res://Battles/Attacks/AttackScripts/AttackBase.gd"





# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	#define these per attack
	targetSpots = []
	splashSpots = []
	damage = 30 # base damage
	statusEffects = []
	splashDegredation = 1
	maxDepth = 0
	mpCost = 0
	knockback = [1,0]
	description = "Throw a blazing ball of fire"
	subDescription = "Hits frontmost target in same row as caster"
	#leave these alone

	initialize_attack()
	# Replace with function body.




func attack_code(gridSlot): # overide
	gridSlot.perform_damage(self)

func target_code():
	var row = caster.gridSlot.location[1]
	targetSpots = [get_opposing_grid_slot_row(row,1)]
	create_targets(targetSpots)


#lave this function alone

