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
	maxDepth = 0
	mpCost = 10
	description = "Increases defense by 5 for rest of the fight"
	subDescription = ""
	
	#leave these alone

	initialize_attack()
	# Replace with function body.


	
func attack_code(gridSlot): # overide
	caster.defense += 5

func target_code():
	targetSpots = [caster.gridSlot.location]
	set_specific_targets(false)


#lave this function alone

