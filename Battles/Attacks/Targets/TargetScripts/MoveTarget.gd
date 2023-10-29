extends "res://Battles/Attacks/Targets/TargetScripts/Target.gd"

var chainTargets = []
var orientation = 0;
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	create_shadow()
	var green = Color(0,1,0,1) # Replace with function body.
	$Sprite.modulate = green
	create_chain(attack.caster.gridSlot.location,gridSlot.location)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func create_chain(start,end):
	var spots = null
	var slot = null
	var targetSlots= []
	spots = try_horizontal_dominant_way(start,end)
	print("Spots")
	print(spots)
	if spots != null:
		for spot in spots:
			slot = get_my_slot(spot)
			
			if(slot != null):
				targetSlots.append(slot)
		create_chain_targets(targetSlots)
			
			
func try_horizontal_dominant_way(start,end):
	var spots = []
	var location = start.duplicate()
	var increment = 1
	if(location[0] < end[0]):
		increment = 1
		orientation = 0
	else:
		increment = -1
		orientation = 180
	print("Start")
	print(start)
	print("End")
	print(end)
	while location[0]!= end[0]:
		
		location[0] += increment
		spots.append(location.duplicate())
		print("Increment")
		print(spots)
		
	if(location[1] < end[1]):
		increment = 1
	else:
		increment = -1
	while location[1] != end[1]:
		location[1] += increment
		print("IncrementY")
		spots.append(location.duplicate())
		print(spots)		
	return spots
	
		
func delete_self():
	remove_chain_targets()
	remove_splash_targets()
	queue_free()
func remove_chain_targets():
	for target in chainTargets:
		target.delete_self()
	chainTargets = []
func create_chain_targets(targetSlots):
	if(targetSlots.size() > 1):
		print("SHOULD BE MADE")
		print(targetSlots)
		var targetType = "Chain"
		gridManager.create_chain_targets(targetSlots[0],attack,targetSlots.duplicate(),1,self,orientation)
func _on_Area2D_mouse_entered():
	#.super()
	display_shadow()
func _on_Area2D_mouse_exited():
	#.super()
	if(!selected and $Sprite.visible):
		remove_shadow()
	
func create_shadow():
	print("Shadow")
	var spriteTexture = attack.caster.get_node("Sprite").texture
	var shadowSprite = Sprite.new()
	shadowSprite.texture = spriteTexture
	shadowSprite.modulate.a = 0.5
	shadowSprite.visible = false
	shadowSprite.name = "shadowSprite"
	add_child(shadowSprite)
func display_shadow():
	$shadowSprite.visible = true
	
	for target in chainTargets:
		target.set_arrow_visible()
func remove_shadow():
	$shadowSprite.visible = false
	

