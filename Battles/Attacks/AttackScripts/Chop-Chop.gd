extends "res://Battles/Attacks/AttackScripts/AttackBase.gd"





# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	#define these per attack
	targetSpots = [[0,0],[1,0],[-1,0],[0,1],[0,-1]]
	splashSpots = []

	damage = 10 # base damage
	statusEffects = []
	splashDegredation = 1
	maxDepth = 0
	mpCost = 10
	description = "powerful swings"
	subDescription = "position dependent attack"
	finalCount = false
	#leave these alone

	initialize_attack()
	# Replace with function body.




func attack_code(gridSlot): # overide
	gridSlot.perform_damage(self)

func target_code():
	set_position_dependent_targets()


#lave this function alone

