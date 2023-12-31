extends Node
var battleManager = null
var targetScene = preload("res://Battles/Attacks/Targets/Target.tscn")
var GridSlotScene = preload("res://Battles/GridManager/GridSlot.tscn")
var alternativeSlotSprite = preload("res://Battles/GridManager/GridSprites/sPlaceHolderGrid.PNG")
#define these
var tilesBetweenGrids = 2
var possibleSpawnPoints = []
var party = []
	#vertical ratios
var topBetweenGridRatio = 0.30
var verticalGridRatio = 0.5
var gridBetweenBottomRatio = 0.20
	#horizontal ratios
var leftBetweenGridRatio = 0.15
var horizontalGridRatio = 0.7
var rightBetweenGridRatio = 0.15
#will be defined by BattleScreen scene
var heroGrid = []
var enemyGrid = []
var tileSize = 0
var tileStartX = 0
var tileStartY = 0




# Called when the node enters the scene tree for the first time.
func _ready():
	battleManager = get_tree().get_root().find_node("BattleManager",true,false)
	randomize()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):

#builds the hero and enemy grids while configurng the camera to display everything properly
func build_grids():
	build_hero_grid()
	build_enemy_grid()
	configure_camera()
#builds hero grid on the left side, placing slots on occupiable spaces
func build_hero_grid():
	print("READY")
	party = get_party()
	var y = -1
	var x = -1
	#for i in range (4):
		#create_GridSlot(j,x,y,"hero")
	for i in heroGrid:
		y+=1
		for j in i:
			x+=1
			if j != 2:
				#if(!((x == 0 and y == 0) or (x == 0 and y == 1) or (x == 1 and y == 0) or (x == 1 and y == 1))):
				create_GridSlot(j,x,y,"hero")
				
			
		x = -1
	
#builds enemy grid on the right side, placing slots on occupiable spaces
func build_enemy_grid():
	var y = -1
	var x = -1
	for i in enemyGrid:
		y+=1
		for j in i:
			x+=1
			if typeof(j) != TYPE_INT or j != 2:
				create_GridSlot(j,x,y,"enemy")
		x = -1
	spawn_heroes()
#creates a gridslot based on the x,y position given by the previous build_rid functions
#entity = the name of the entity to create there if a string is given here
#affiliation = hero or enemy, used to pass off to the slot instance itself TODO
func create_GridSlot(entity,x,y,affiliation):
	var slotInstance = GridSlotScene.instance()
	var slotSprite = slotInstance.get_node("Sprite")
	var baseX = 0 #base is the base position that is different for hero and enemy grid used for calculating the position the grid should be
	var baseY = 0
	if(affiliation == "hero"):
		if entity == 1:
			possibleSpawnPoints.append(slotInstance)
		baseX = tileStartX
		baseY = tileStartY * slotSprite.texture.get_height()
	else: #affiliation = "enemy"
		baseX = tileStartX + ((get_grid_width(heroGrid) + tilesBetweenGrids) * tileSize)
		baseY = tileStartY * slotSprite.texture.get_height()
	baseY = (slotSprite.texture.get_height()/2) + slotSprite.texture.get_height()* 2
	change_sprite(x,y, slotSprite)
	slotInstance.position = Vector2(baseX + x*slotSprite.texture.get_width(),baseY + y*slotSprite.texture.get_height())
	
	slotInstance.affiliation = affiliation
	slotInstance.location[0] = x
	slotInstance.location[1] = y
	if(affiliation == "hero"):
		heroGrid[y][x] = slotInstance
	else:
		enemyGrid[y][x] = slotInstance
	add_child(slotInstance)
	if(typeof(entity) == TYPE_STRING):
		slotInstance.create_entity(entity)
	
	
	
#changes the sprite based on its placement on the board... should alternate so that the grid is clearly viible
func change_sprite(x,y,slotSprite):
	if((x + y) % 2 == 0):
		slotSprite.texture = alternativeSlotSprite
#configures the camera placement
func configure_camera():
	configure_camera_placement()
	configure_camera_zoom()
#zooms in camera according to screen ratios and sprite sizes
func configure_camera_zoom():
	var desiredHeight = (get_largest_column() * tileSize)/verticalGridRatio
	var desiredWidth = (((get_largest_row() * 2) + tilesBetweenGrids) * tileSize)/horizontalGridRatio
	var viewportSize = get_viewport().size
	var viewportWidth = viewportSize.x
	var viewportHeight = viewportSize.y
	var zoomY = desiredHeight/viewportHeight
	var zoomX = desiredWidth/viewportWidth
	var newZoom = 0
	if (zoomY > zoomX):
		newZoom = zoomY
	else:
		newZoom = zoomX
		#have the offset feature fix any discrepencies with the ratios
	$Camera2D.zoom = Vector2(newZoom,newZoom)
	
	configure_camera_offset(desiredHeight)
	
	#$Camera2D.configure_zoom(horizontalGridSize,verticalGridSize)
#sets initial camera placement
func configure_camera_placement():
	var xPlacement = (tileSize * (get_grid_width(heroGrid) + (tilesBetweenGrids/2)))
	var yPlacement = ((tileSize/2) + tileSize* 2) + (tileSize * (get_largest_column()/2))
	$Camera2D.position = Vector2(xPlacement,yPlacement)
#offsets camra placement basd on vertical ratios
func configure_camera_offset(desiredHeight):
	var ratio =  gridBetweenBottomRatio - topBetweenGridRatio
	if(ratio == 0):
		return
	var offsetDirection = ratio/abs(ratio)
	ratio = abs(ratio)
	var change = desiredHeight * ratio
	$Camera2D.position = Vector2($Camera2D.position.x, $Camera2D.position.y + (change * offsetDirection))
	
		
		
			
func spawn_heroes():
	var chosenSlot = null
	var validSpawnPoints = get_valid_spawn_points()
	for i in party:
		if (possibleSpawnPoints.size() != 0):
			chosenSlot = possibleSpawnPoints[randi() % possibleSpawnPoints.size() ]
			chosenSlot.create_entity(i)
			possibleSpawnPoints.erase(chosenSlot)
		else:
			if (validSpawnPoints.size() == 0):
				break
			else:
				chosenSlot = validSpawnPoints[randi() % validSpawnPoints.size() ]
				chosenSlot.create_entity(i)
				validSpawnPoints.erase(chosenSlot)
			
			
		
		
		
func get_valid_spawn_points():
	var validSpawnPoints = []
	for i in heroGrid:
		for j in i:
			
			if j is GridSlot:
				validSpawnPoints.append(j)
	return validSpawnPoints
					
		
func get_party():
	#TODO database implementation
	return ["Knight","Witch","Warrior"]
func get_largest_row():
	var heroRowSize = get_grid_width(heroGrid);
	var enemyRowSize = get_grid_width(enemyGrid);
	if(heroRowSize > enemyRowSize):
		return heroRowSize
	else:
		return enemyRowSize
func get_largest_column():
	var heroColumnSize = get_grid_height(heroGrid);
	var enemyColumnSize = get_grid_height(enemyGrid.duplicate());
	if(heroColumnSize > enemyColumnSize):
		return heroColumnSize
	else:
		return enemyColumnSize
func get_grid_width(grid):
	return grid[0].size()
func get_grid_height(grid):
	return grid.size()
	
func get_all_enemy_slots():
	return get_all_slots(enemyGrid)
func get_all_hero_slots():
	return get_all_slots(heroGrid)
func get_all_slots(chosenGrid):
	var returnSlots = []
	for row in chosenGrid:
		for slot in row:
			if slot is GridSlot and slot.entity != null and !slot.entity.dead:
				returnSlots.append(slot)
	return returnSlots
func create_targets(targetSpots,attack,targetType,depth):
	print("TARGET WAS CREATED")
	if(targetType == "Unselectable"):
		print("yes")
	var targets = []
	var num = 0
	for slot in targetSpots:
		if(!(slot is GridSlot)):
			continue;
		num +=1;
		var targetInstance = targetScene.instance()
		if(targetType != ""):
			var targetScript = load("res://Battles/Attacks/Targets/TargetScripts/" + targetType + "Target.gd")
			targetInstance.script = targetScript
		targetInstance.attack = attack
		targetInstance.gridSlot = slot
		targetInstance.type = targetType
		targetInstance.depth = depth
		targetInstance.number = num
		slot.add_child(targetInstance)
		targets.append(targetInstance)
	return targets
func create_chain_targets(targetSpot,attack,targetSlots,depth,baseTarget, orientation = null):
	
	var targets = []
	var targetType = "Chain"
	var slot = targetSpot

	var targetInstance = targetScene.instance()
	if(targetType != ""):
		var targetScript = load("res://Battles/Attacks/Targets/TargetScripts/" + targetType + "Target.gd")
		targetInstance.script = targetScript
	targetInstance.attack = attack
	targetInstance.gridSlot = slot
	targetInstance.depth = depth
	targetInstance.targetSlots = targetSlots
	targetInstance.baseTarget= baseTarget
	targetInstance.orientation = orientation
	slot.add_child(targetInstance)
	targets.append(targetInstance)
	return targets
func get_slot(slotLocation,gridType):
	
	var chosenGrid = get_grid(gridType)
	
	if(slotLocation[0] >= get_grid_width(chosenGrid) or slotLocation[0] < 0 or slotLocation[1] >= get_grid_height(chosenGrid) or  slotLocation[1] < 0):
		print("CHECKDATA")
		print(get_grid_width(chosenGrid))
		print(get_grid_height(chosenGrid))
		
		return null
	print("Successful return")
	
	var ret = chosenGrid[slotLocation[1]][slotLocation[0]]
	if(ret is GridSlot):
		return ret
	

func transfer_entity(start,end):
	var entity = start.entity
	start.remove_child(entity)
	start.entity = null
	entity.gridSlot = end
	end.add_child(entity)
	end.entity = entity
func validateLocationX(X,gridType):
	var width = get_grid_width(get_grid(gridType))
	if (X > width):
		return width
	elif (X < 0):
		return 0
	else:
		return X
func validateLocationY(Y,gridType):
	var height = get_grid_height(get_grid(gridType))
	if (Y > height):
		return height
	elif (Y < 0):
		return 0
	else:
		return Y
func get_grid(gridType):
	if gridType == "hero":
		return heroGrid
	else: #gridType == "enemy"
		return enemyGrid

func get_slot_in_row(row,num,gridType):
	var grid = get_grid(gridType)
	var slot = null
	for i in range(get_grid_width(grid)):
		slot = get_slot([i,row],gridType)
		if(is_instance_valid(slot) and is_instance_valid(slot.entity) ):
			num -= 1
			if(num <= 0):
				return slot
	return null
	



