extends Spatial

const PickUp = preload("res://Item/Pickup.tscn")

onready var player : KinematicBody = $Player
onready var interface : Control = $CanvasLayer/Interface

# Generation Code

const dir = [Vector2.RIGHT, Vector2.LEFT, Vector2.UP, Vector2.DOWN]

var grid_size = 10
var grid_steps = 100


#entities

onready var chest = $Chest
onready var pickup = $Pickup
onready var enemy = $Enemy

#set this to -12, basically the 'floor' of the map
var floor_level = -12

#
#
#
#
#
#
#
#
#

func _generatemap():
	randomize()
	
	var current_pos = Vector2(0,0)
	var current_dir = Vector2.RIGHT
	
	var last_dir = current_dir * -1
		
	for x in range(-12,12):
		for y in range(-12,12):
			$GridMap.set_cell_item(x, -1, y, 0)
			$GridMap.set_cell_item(x, 0, y, 1)
			$GridMap.set_cell_item(x, 1, y, 1)
	
	for i in range(0,grid_steps):
		var temp_dir = dir.duplicate()
		temp_dir.shuffle()
		var d = temp_dir.pop_front()
		
		while (abs(current_pos.x + d.x) > grid_size or 
		abs(current_pos.y + d.y) > grid_size or d == last_dir * -1):
			temp_dir.shuffle()
			d = temp_dir.pop_front()
			
		current_pos += d
		last_dir = d
		
		$GridMap.set_cell_item(current_pos.x, -1, current_pos.y, 0)
		$GridMap.set_cell_item(current_pos.x, 0, current_pos.y, -1)
		#$GridMap.set_cell_item(current_pos.x, 1, current_pos.y, 1)
		
	#decorate level
	for x1 in range (-12,12):
		for y1 in range(-12,12):
			#get cell item setup: get_cell_item(xPos,Level,yPos)
			#First, we check if the cell is unoccupied,
			#Then, we check if two sides of it are filled
			#If so, we add a doorway
			if ($GridMap.get_cell_item(x1, 0, y1) == -1): 
				if ($GridMap.get_cell_item(x1+1, 0, y1) == 1) and ($GridMap.get_cell_item(x1-1, 0, y1) == 1): 
					$GridMap.set_cell_item(x1, 0, y1, 2)
				if ($GridMap.get_cell_item(x1, 0, y1+1) == 1) and ($GridMap.get_cell_item(x1, 0, y1-1) == 1): 
					$GridMap.set_cell_item(x1, 0, y1, 2,16)
			# or, we add a light
			if ($GridMap.get_cell_item(x1, 0, y1) == -1) or $GridMap.get_cell_item(x1, 0, y1) == 2: 
				var randomNumber = rand_range(0,1)
				if (randomNumber <= 0.15):
					var light = OmniLight.new()
					#light.light_color = Color(1, 1, 1)  # White light
					light.omni_range = 20
					add_child(light)
					var tilepos = $GridMap.map_to_world(x1,0,y1)
					#have to multiply by 3 or something
					light.translation = Vector3(tilepos.x*3,0,tilepos.z*3)
					light.translation.y = floor_level
				
				
			
		
	
	#How this works:
	#
	#
	#
	#
	#
	#
	#
	
	var playerLocation
	var npclocation
	var itemlocation
	var enemylocation
	var enemylocation2
	
	
	#add player and npc
	for x2 in range (-12,12):
		for y2 in range(-12,12):
			#check for empty cell
			var rx = rand_range(-12,12)
			var ry = rand_range(-12,12)
			if ($GridMap.get_cell_item(rx, 0, ry) == -1): 
				var tilepos = $GridMap.map_to_world(rx,0,ry)
				$Player.translation = Vector3(tilepos.x*3,0,tilepos.z*3)
				$Player.translation.y = floor_level
				playerLocation = tilepos
				#extremely bad way of spawning but screw it, who cares
				if ($GridMap.get_cell_item(rx+3, 0, ry) == -1) or ($GridMap.get_cell_item(rx+3, 0, ry) == 2): 
					tilepos = $GridMap.map_to_world(rx+3,0,ry)
					$BillBoard.translation = Vector3(tilepos.x*3,0,tilepos.z*3)
					$BillBoard.translation.y = floor_level
					npclocation = tilepos
					
				elif ($GridMap.get_cell_item(rx-3, 0, ry) == -1) or ($GridMap.get_cell_item(rx-3, 0, ry) == 2): 
					tilepos = $GridMap.map_to_world(rx-3,0,ry)
					$BillBoard.translation = Vector3(tilepos.x*3,0,tilepos.z*3)
					$BillBoard.translation.y = floor_level
					npclocation = tilepos
					
				elif ($GridMap.get_cell_item(rx, 0, ry+3) == -1) or ($GridMap.get_cell_item(rx, 0, ry+3) == 2):
					tilepos = $GridMap.map_to_world(rx,0,ry+3)
					$BillBoard.translation = Vector3(tilepos.x*3,0,tilepos.z*3)
					$BillBoard.translation.y = floor_level
					npclocation = tilepos
			
				elif ($GridMap.get_cell_item(rx, 0, ry-3) == -1) or ($GridMap.get_cell_item(rx, 0, ry-3) == 2):
					tilepos = $GridMap.map_to_world(rx,0,ry-3)
					$BillBoard.translation = Vector3(tilepos.x*3,0,tilepos.z*3)
					$BillBoard.translation.y = floor_level
					npclocation = tilepos
					
					
				# ITEM SPAWNING
				if ($GridMap.get_cell_item(rx+3, 0, ry) == -1) or ($GridMap.get_cell_item(rx+3, 0, ry) == 2): 
					
					tilepos = $GridMap.map_to_world(rx+1,0,ry)
					$Pickup.translation = Vector3(tilepos.x*3,0,tilepos.z*3)
					$Pickup.translation.y = floor_level
					itemlocation = tilepos
				elif ($GridMap.get_cell_item(rx-3, 0, ry) == -1) or ($GridMap.get_cell_item(rx-3, 0, ry) == 2): 
					
					tilepos = $GridMap.map_to_world(rx-1,0,ry)
					$Pickup.translation = Vector3(tilepos.x*3,0,tilepos.z*3)
					$Pickup.translation.y = floor_level
					itemlocation = tilepos
				elif ($GridMap.get_cell_item(rx, 0, ry+3) == -1) or ($GridMap.get_cell_item(rx, 0, ry+3) == 2):
					
					tilepos = $GridMap.map_to_world(rx,0,ry+1)
					$Pickup.translation = Vector3(tilepos.x*3,0,tilepos.z*3)
					$Pickup.translation.y = floor_level
					itemlocation = tilepos
				elif ($GridMap.get_cell_item(rx, 0, ry-3) == -1) or ($GridMap.get_cell_item(rx, 0, ry-3) == 2):
					
					tilepos = $GridMap.map_to_world(rx,0,ry-1)
					$Pickup.translation = Vector3(tilepos.x*3,0,tilepos.z*3)
					$Pickup.translation.y = floor_level
					itemlocation = tilepos

				break;
				
			
	
	#add enemy
	for x2 in range (-12,12):
		for y2 in range(-12,12):
			var tilepos = $GridMap.map_to_world(x2,0,y2)
			if ($GridMap.get_cell_item(x2, 0, y2) == -1) and ((tilepos != playerLocation) or (tilepos != npclocation) or (tilepos != itemlocation)): 
				var randomNumber = rand_range(0,1)
				if (randomNumber <= 0.15):
					
					$Enemy.translation = Vector3(tilepos.x*3,0,tilepos.z*3)
					$Enemy.translation.y = floor_level
					enemylocation = tilepos
					break
					
	#add 2nd enemy 
	
	#for x2 in range (-12,12):
	#	for y2 in range(-12,12):
	#		var tilepos = $GridMap.map_to_world(x2,0,y2)
	#		if ($GridMap.get_cell_item(x2, 0, y2) == -1) and ((tilepos != playerLocation) or (tilepos != npclocation) or (tilepos != itemlocation) or (tilepos != enemylocation)): 
	#			var randomNumber = rand_range(0,1)
	#			if (randomNumber <= 0.15):
	#				
	#				$Enemy2.translation = Vector3(tilepos.x*3,0,tilepos.z*3)
	#				#$Enemy2.translation.y = floor_level
	#				enemylocation2 = tilepos
	#				break
	#				
	
	#add chest
	for x2 in range (-12,12):
		for y2 in range(-12,12):
			var tilepos = $GridMap.map_to_world(x2,0,y2)
			#($GridMap.get_cell_item(x2-1, 0, y2) == 1) or ($GridMap.get_cell_item(x2, 0, y2-1) == 1)
			if ($GridMap.get_cell_item(x2, 0, y2) == -1) and ((tilepos != playerLocation) or (tilepos != npclocation) or (tilepos != itemlocation) or (tilepos != enemylocation)): 
				var randomNumber = rand_range(0,1)
				
				if (randomNumber <= 0.15) and (tilepos != playerLocation):
					
					$Chest.translation = Vector3(tilepos.x*3,0,tilepos.z*3)
					$Chest.translation.y = floor_level
					break
		
	
	
	

func _ready() ->void:
	_generatemap()
	player.connect("toggle_inventory", self, "toggle_interface")
	interface.set_player_inventory_data(player.inventory_data)
	interface.set_player_equipment_data(player.equipment_data)
	
	for node in get_tree().get_nodes_in_group("external_inventory"):
		node.connect("toggle_inventory", self, "toggle_interface")
		

func toggle_interface(external_inventory_owner = null) -> void:
	interface.visible = not interface.visible
	
	if interface.visible:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	if external_inventory_owner and interface.visible:
		interface.set_external_inventory(external_inventory_owner)
	else:
		interface.clear_external_inventory()


func _on_Interface_drop_slot_data(slot_data):
	var pick_up = PickUp.instance()
	pick_up.slot_data = slot_data
	pick_up.global_transform.origin = player.get_drop_position()
	add_child(pick_up)
	
