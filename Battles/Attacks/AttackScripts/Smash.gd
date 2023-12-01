extends "res://Battles/Attacks/AttackScripts/AttackBase.gd"





# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	#define these per attack
	targetSpots = []
	splashSpots = [[0,-1],[0,1],[1,1],[1,-1],[-1,1],[-1,-1],[1,0],[-1,0],[0,-2],[0,2],[2,2],[2,-2],[-2,2],[-2,-2],[2,0],[-2,0]]
	damage = 60 # base damage
	statusEffects = []
	splashDegredation = 0.75
	maxDepth = 1
	mpCost = 75
	description = "Smash down with tremendous force"
	subDescription = "Deals heavy damge to one enemy and decreasing damage to enemies around"
	#leave these alone

	initialize_attack()
	# Replace with function body.




func attack_code(gridSlot): # overide
	var origin = firstClick.gridSlot.location
	var dist = distance_between(origin,gridSlot.location)
	var rem = damage
	damage = damage * (pow(0.5,dist))
	damage = round(damage)
	gridSlot.perform_damage(self)
	damage = rem

func target_code():
	set_all_targets()
func distance_between(origin,slot):
	var distx = abs(origin[0] - slot[0])
	var disty = abs(origin[1] - slot[1])
	if(distx > disty):
		return distx
	else:
		return disty



