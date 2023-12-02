extends "res://Battles/Attacks/AttackScripts/AttackBase.gd"





# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	#define these per attack
	targetSpots = []
	splashSpots = []
	damage = 20 # base damage
	statusEffects = []
	splashDegredation = 1
	maxDepth = 1	
	mpCost = 0
	description = "A giant rock fist to the face"
	subDescription = "Attacks a single selected target"
	#leave these alone

	initialize_attack()
	# Replace with function body.




func attack_code(gridSlot): # overide
	gridSlot.perform_damage(self)

func target_code():
	set_all_targets()


#lave this function alone

