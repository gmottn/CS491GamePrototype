extends "res://Battles/GridManager/BattleElement.gd"
signal entity_deactivated(entity)
var damagePopupScene = preload("res://Battles/Attacks/DamagePopup/DamagePopup.tscn")
var attackScene = preload("res://Battles/Attacks/Attack.tscn")
var entityAIScene = preload("res://Battles/BattleEntities/EntityAI.tscn")
var maxHp = 1000
var hp = maxHp
var maxMp = 100
var mp = maxMp
var portrait = preload("res://Battles/BattleEntities/EntitySprites/Portraits/Knight.png")
var AI = null
var strength = 5
var defense = 2
var attacks = ["TestAttack","KnockbackAttack","TestPositionAttack","TestAttack","KnockbackAttack"]
var moveSpots = [[1,0],[-1,0],[0,-1],[0,1]]
var sprite = null
var gridSlot = null
var affiliation = null
var entityName = null
var currentStatusEffects = []
var dead = false
var active = false setget set_active
var moveAttack = null

# Called when the node enters the scene tree for the first time.
func _ready():
	
	affiliation = gridSlot.affiliation
	battleManager.add_entity(self)
	load_entity_stats()
	configure_entity()
	#perform_attack("TestAttack")
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
#	pass
func create_attack(attackName,num):
	
	var attackInstance = attackScene.instance()
	var attackScript = find_attack_script(attackName)
	attackInstance.script = attackScript
	attackInstance.attackClickableNumber = num
	add_child(attackInstance)
	return attackInstance
func load_entity_stats():
	get_sprite()
func get_sprite():
	#communicate with database once implemented
	
	
	if(affiliation == "hero"):
		sprite = preload("res://Battles/BattleEntities/EntitySprites/spriteDefault.png")
	else:
		attacks = ["TestAttack","TestPositionAttack"]
		sprite = preload("res://Battles/BattleEntities/EntitySprites/spriteEnemyDefault.png")
func configure_entity():
	if(affiliation == "enemy"):
		configure_AI()
	configure_sprite()
func configure_sprite():
	$Sprite.texture = sprite
	if(affiliation == "enemy"):
		$Sprite.flip_h = true
func take_damage(damage,statusEffects):
	if(damage <= 0):
		damage = abs(damage)
	else:
		damage = damage - defense
	if(damage < 0):
		damage = 0
	hp -= damage
	print("New HP is...")
	print(hp)
	if(hp > maxHp):
		hp = maxHp
	add_status_effects(statusEffects)
	create_damage_popup(damage,statusEffects)
	check_if_dead()
func check_if_dead():
	
	if hp <= 0:
		#emit dead signal
		dead = true
		if(affiliation == "enemy"):
			battleManager.enemies.erase(self)
			gridSlot.entity = null
			queue_free()
			
func create_damage_popup(damage, statusEffects):
	gridSlot.create_damage_popup(damage, statusEffects)
func add_status_effects(statusEffects):
	pass
func selected_code():
	var num = 0
	var attackList = []
	for attack in attacks:
		num+=1
		attackList.append(create_attack(attack,num))
	num+=1
	moveAttack = create_attack("Move",num);
	if(is_instance_valid(AI)):
		AI.attacks = attackList
func _input(event):
	pass
	#if event is InputEventKey:
	#	if event.pressed:
	#		if event.scancode == KEY_A and gridSlot.affiliation == "hero":
	#			perform_attack("TestAttack")
	#		elif event.scancode == KEY_L and gridSlot.affiliation == "enemy":
	#			perform_attack("TestAttack")
	
func find_attack_script(attackName):
	#print("Attack startup works")
	if attackName == null:
		assert("Attack was not defined for me to be")
	var attackScript = load("res://Battles/Attacks/AttackScripts/" + attackName + ".gd")
	return attackScript
func set_active(value):
	active = value;
	if(!active):
		print("SIGNAL EMITTED")
		battleManager._on_enity_deactivated_triggered(self)
		if(affiliation == "hero"):
			$Sprite.self_modulate.a= 0.5
	else:
		$Sprite.self_modulate.a= 1
	if(is_instance_valid(AI)):
		AI.deactivate()
func configure_AI():
	AI = entityAIScene.instance()
	AI.attached = self
	add_child(AI)
func activate_AI():
	AI.activate()
	
