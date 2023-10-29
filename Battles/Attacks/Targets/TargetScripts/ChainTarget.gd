extends "res://Battles/Attacks/Targets/TargetScripts/UnselectableTarget.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var targetSlots = []
var orientation = 0
var nextTarget = null
var nextTargetOrientation = 0
var baseTarget
# Called when the node enters the scene tree for the first time.
func _ready():
	var purple = Color(1,0,1,1) # Replace with function body.
	$Sprite.modulate = purple
	print("CHAIN HAS BEEN MADE")
	
	targetSlots.remove(0)
	baseTarget.chainTargets.append(self)
	create_chain_target(targetSlots)
	get_my_sprite()
	

func create_chain_target(targetSlots):
	if(targetSlots.size() > 1):
		print("SHOULD BE MADE")
		print(targetSlots)
		var targetType = "Chain"
		nextTarget = gridManager.create_chain_targets(targetSlots[0],attack,targetSlots.duplicate(),1,baseTarget,nextTargetOrientation)
func get_my_sprite():
	pass
func set_arrow_visible():
	pass
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
