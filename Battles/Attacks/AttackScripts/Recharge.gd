extends "res://Battles/Attacks/AttackScripts/AttackBase.gd"





# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	#define these per attack
	targetSpots = []
	splashSpots = []
	damage = 0 # base damage
	statusEffects = []
	splashDegredation = 1
	maxDepth = 1
	mpCost = 0
	description = "Restore 20 MP to selected ally"
	subDescription = ""
	#leave these alone

	initialize_attack()
	# Replace with function body.




func attack_code(gridSlot): # overide
	gridSlot.entity.mp += 25

func target_code():
	set_all_targets(false)


#lave this function alone

