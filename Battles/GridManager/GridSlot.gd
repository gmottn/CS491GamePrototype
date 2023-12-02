extends "res://Battles/GridManager/BattleElement.gd"
class_name GridSlot
var damagePopupScene = preload("res://Battles/Attacks/DamagePopup/DamagePopup.tscn")
var battleEntityScene = preload("res://Battles/BattleEntities/BattleEntity.tscn")
var sprite = null #which sprite for it to display
var location = [0,0] # position on the grid 
var entityName = null
var entity = null # reference to the entity inside of this GridSlot, null means this GridSlot is empty
var affiliation = null # either "hero" or "enemy" to dictate which grid it is part of
var selected = false setget set_selected
var clickable = true
var delay = 0


func set_selected(value):
	selected = value
	if(!selected):
		UI.selected = null
# Called when the node enters the scene tree for the first time.
func _ready():
	battleManager.connect("state_changed",self,"_on_state_changed_triggered")



func create_entity(entityName):
	entity = battleEntityScene.instance()
	entity.entityName = entityName
	entity.gridSlot = self
	add_child(entity)
	
		
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(delay > 0 and battleManager.is_state("hero")):
		delay-=1
		
func get_x_location():
	return location[0]
func get_y_location():
	return location[1]


func _on_Area2D_mouse_entered(AIPass = false):
	if(battleManager.is_state("hero")) or AIPass: #valid code stuff
		$SelectedSprite.visible = true
		if(is_instance_valid(entity)):
			if(UI.selected != entity):
				UI.attacksPanel.clear()
				entity.selected_code()
				UI.selected = entity
			
		else:
			UI.selected = null



func _on_Area2D_mouse_exited():
	if(!selected and battleManager.is_state("hero")):
		$SelectedSprite.visible = false
		


func _on_Area2D_input_event(viewport, event, shape_idx, AIpass = false):

	if (battleManager.is_state("hero") and event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT and entity != null and !delay and $SelectedSprite.visible) or AIpass:
		set_selected(true)
		battleManager.changeState("SlotSelected")

		

func perform_damage(attack):
	if(entity != null and !entity.dead):
		print("damage done")
		var damage = attack.damage
		
		var strength = attack.caster.strength
		if(damage < 0):
			strength = 0
		var statusEffects = attack.statusEffects
		entity.take_damage(damage + strength,statusEffects)
		print(" a hit occurred")
	else:
		print(" a miss occurred")
		create_damage_popup("Miss", [])
	var xKnockback = attack.knockback[0]
	var yKnockback = attack.knockback[1]
	if (xKnockback != 0 or yKnockback != 0) and entity != null:
		var newLocationX = gridManager.validateLocationX(location[0] + xKnockback,affiliation)
		var newLocationY = gridManager.validateLocationY(location[1] + yKnockback,affiliation)
		var newLocation = [newLocationX,newLocationY]
		if(newLocation != location):
			var newSlot= gridManager.get_slot(newLocation,affiliation)
			if(is_instance_valid(newSlot) and !is_instance_valid(newSlot.entity)):
				gridManager.transfer_entity(self,newSlot)
	
func _on_state_changed_triggered():
	if(battleManager.is_state("hero")):
		delay = 1
	if(!battleManager.is_state("SlotSelected") and !battleManager.is_state("targeting")):
		set_selected(false)
		$SelectedSprite.visible = false
func create_damage_popup(damage, statusEffects):
	var damagePopupInstance = damagePopupScene.instance()
	damagePopupInstance.damage = damage
	damagePopupInstance.statusEffects = statusEffects
	add_child(damagePopupInstance)



	

