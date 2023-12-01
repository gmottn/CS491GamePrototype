extends "res://Battles/Attacks/ItemScripts/ItemBase.gd"





# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	#define these per attack
	targetSpots = []
	splashSpots = [[0,-1],[0,1],[1,1],[1,-1],[-1,1],[-1,-1],[1,0],[-1,0]]
	damage = 100 # base damage
	statusEffects = []
	splashDegredation = 0.8
	maxDepth = 1	
	#leave these alone

	initialize_attack()
	# Replace with function body.




func attack_code(gridSlot): # overide
	gridSlot.perform_damage(self)

func target_code():
	set_all_targets()


#lave this function alone

