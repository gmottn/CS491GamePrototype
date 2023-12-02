extends "res://Battles/Attacks/AttackScripts/AttackBase.gd"





# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	#define these per attack
	targetSpots = []
	splashSpots = [[0,1],[-1,0],[0,-1],[1,0]]
	damage = 5 # base damage
	statusEffects = []
	splashDegredation = 1
	maxDepth = 3	
	mpCost = 10
	description = "Three slices, striking with pride"
	subDescription = "choose a target to start and chooe where to slash around"
	finalCount = false
	#leave these alone

	initialize_attack()
	# Replace with function body.




func attack_code(gridSlot): # overide
	gridSlot.perform_damage(self)

func target_code():
	set_all_targets()


#lave this function alone

