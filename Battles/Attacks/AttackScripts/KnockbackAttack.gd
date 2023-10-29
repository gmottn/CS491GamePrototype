extends "res://Battles/Attacks/AttackScripts/AttackBase.gd"





# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	#define these per attack
	targetSpots = []
	splashSpots = []
	damage = 50# base damage
	statusEffects = []
	splashDegredation = 0.8
	maxDepth = 1
	knockback = [-1,0]
	
	#leave these alone
	gridManager = get_tree().get_root().find_node("GridManager",true,false)
	battleManager =  get_tree().get_root().find_node("BattleManager",true,false)
	initialize_attack()
	# Replace with function body.




func attack_code(gridSlot): # overide
	gridSlot.perform_damage(self)

func target_code():
	set_all_targets()


#lave this function alone
func initialize_attack():
	caster = get_parent()
	attackClickable = attackClickableScene.instance()
	attackClickable.distanceMult = attackClickableNumber
	attackClickable.attack = self
	gridManager.get_node("UI_Layer/Panel").add_child(attackClickable)
	
	affiliation = caster.affiliation
	if affiliation == "hero":
		knockback[0] *= -1
		for spots in splashSpots:
			print("added")
			spots[0] *= -1
