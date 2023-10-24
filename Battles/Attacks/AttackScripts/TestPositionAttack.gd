extends "res://Battles/Attacks/AttackScripts/AttackBase.gd"





# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	#define these per attack
	targetSpots = [[0,0],[1,0],[-1,0],[0,1],[0,-1]]
	splashSpots = [[-1,0],[0,1]]
	damage = 1002 # base damage
	statusEffects = []
	splashDegredation = 1
	maxDepth = 0
	
	#leave these alone
	gridManager = get_tree().get_root().find_node("GridManager",true,false)
	battleManager =  get_tree().get_root().find_node("BattleManager",true,false)
	initialize_attack()
	# Replace with function body.




func attack_code(gridSlot): # overide
	gridSlot.perform_damage(self)

func target_code():
	set_position_dependent_targets()


#lave this function alone
func initialize_attack():
	caster = get_parent()
	attackClickable = attackClickableScene.instance()
	attackClickable.distanceMult = attackClickableNumber
	add_child(attackClickable)
	
	affiliation = caster.affiliation
	if affiliation == "hero":
		for spots in splashSpots:
			print("added")
			spots[0] *= -1
