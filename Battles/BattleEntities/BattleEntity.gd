extends Node2D
var damagePopupScene = preload("res://Battles/Attacks/DamagePopup/DamagePopup.tscn")
var attackScene = preload("res://Battles/Attacks/Attack.tscn")
var maxHp = 1000
var hp = maxHp
var maxMp = 1000
var mp = maxMp
var strength = 5
var defense = 2
var attacks = ["TestAttack","KnockbackAttack","TestPositionAttack","Move","KnightMove",]
var sprite = null
var gridSlot = null
var affiliation = null
var entityName = null
var currentStatusEffects = []
var dead = false

# Called when the node enters the scene tree for the first time.
func _ready():
	affiliation = gridSlot.affiliation
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
func load_entity_stats():
	get_sprite()
func get_sprite():
	#communicate with database once implemented
	
	
	if(affiliation == "hero"):
		sprite = preload("res://Battles/BattleEntities/EntitySprites/spriteDefault.png")
	else:
		sprite = preload("res://Battles/BattleEntities/EntitySprites/spriteEnemyDefault.png")
func configure_entity():
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
			gridSlot.entity = null
			queue_free()
			
func create_damage_popup(damage, statusEffects):
	var damagePopupInstance = damagePopupScene.instance()
	damagePopupInstance.damage = damage
	damagePopupInstance.statusEffects = statusEffects
	gridSlot.add_child(damagePopupInstance)
func add_status_effects(statusEffects):
	pass
func selected_code():
	var num = 0
	for attack in attacks:
		num+=1
		create_attack(attack,num)
	pass
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
	
