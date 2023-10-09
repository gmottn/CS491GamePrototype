extends Node

var sprite = null #which sprite for it to display
var gridPlacement = [0,0] # position on the grid 
var entity = null # reference to the entity inside of this GridSlot, null means this GridSlot is empty
var type = null # ither "hero" or "enemy" to dictate which grid it is part of  



# Called when the node enters the scene tree for the first time.
func _ready():
	set_sprite()
	create_entity()


func create_entity():
	#TODO creates an instance of the entity that it initially starts with
	pass
func set_sprite():
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
