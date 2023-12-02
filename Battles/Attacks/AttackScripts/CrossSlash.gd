extends "res://Battles/Attacks/AttackScripts/AttackBase.gd"





# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	#define these per attack
	targetSpots = []
	splashSpots = [[1,1],[1,-1],[-1,1],[-1,-1],[2,2],[2,-2],[-2,2],[-2,-2]]
	damage = 20 # base damage
	statusEffects = []
	splashDegredation = 1
	maxDepth = 1
	mpCost = 5
	description = "Slash enemies and cross them out from existence"
	subDescription = "attacks in an X pattern on origin of hit"
	#leave these alone

	initialize_attack()
	# Replace with function body.




func attack_code(gridSlot): # overide
	gridSlot.perform_damage(self)

func target_code():
	set_all_targets()


#lave this function alone

