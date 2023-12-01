extends "res://Battles/Attacks/AttackScripts/AttackBase.gd"





# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	#define these per attack
	targetSpots = []
	splashSpots = []
	damage = 50 # base damage
	statusEffects = []
	splashDegredation = 0.75
	maxDepth = 1
	mpCost = 0
	description = "Unstable Magic, chance to heal target"
	subDescription = "Hits single target with large splash"
	#leave these alone

	initialize_attack()
	# Replace with function body.




func attack_code(gridSlot): # overide
	if (randi()%100) > 50:
		damage *= -1
	gridSlot.perform_damage(self)

func target_code():
	set_all_targets()


#lave this function alone

