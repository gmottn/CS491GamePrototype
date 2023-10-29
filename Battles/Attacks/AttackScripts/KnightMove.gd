extends "res://Battles/Attacks/AttackScripts/AttackBase.gd"





# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	#define these per attack
	targetSpots = [[2,1],[-2,1],[2,-1],[-2,-1]]
	splashSpots = []
	damage = 1002 # base damage
	statusEffects = []
	splashDegredation = 0.8
	maxDepth = 1
	
	#leave these alone
	gridManager = get_tree().get_root().find_node("GridManager",true,false)
	battleManager =  get_tree().get_root().find_node("BattleManager",true,false)
	initialize_attack()
	# Replace with function body.




func attack_code(gridSlot): # overide
	gridManager.transfer_entity(caster.gridSlot,gridSlot)
func target_code():
	set_position_dependent_targets(false)


#lave this function alone
func initialize_attack():
	caster = get_parent()
	attackClickable = attackClickableScene.instance()
	attackClickable.distanceMult = attackClickableNumber
	attackClickable.attack = self
	gridManager.get_node("UI_Layer/Panel").add_child(attackClickable)
	
	affiliation = caster.affiliation
	if affiliation == "hero":
		for spots in splashSpots:
			print("added")
			spots[0] *= -1
func create_targets(targetSlots):
	var targetType = "Move"
	targets = gridManager.create_targets(targetSlots,self,targetType,1)
