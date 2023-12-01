extends "res://Battles/Attacks/AttackScripts/AttackBase.gd"





# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	#define these per attack
	targetSpots = []
	splashSpots = []
	damage = 1  # base damage
	statusEffects = []
	splashDegredation = 1
	maxDepth = 0
	mpCost = 5
	description = "Flood your enemies and knock them all back"
	subDescription = "Hits all enemies"
	knockback = [1,0]
	#leave these alone

	initialize_attack()
	# Replace with function body.




func attack_code(gridSlot): # overide
	gridSlot.perform_damage(self)

func target_code():
	set_all_targets()


#lave this function alone

