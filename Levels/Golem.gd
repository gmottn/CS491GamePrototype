extends Node


export var max_health : int = 300
onready var health = max_health
export var max_mp : int = 75
onready var mp = max_mp
export var strength : int = 5
export var defense : int = 0
export var agility : int = 5
export var speed : int = 5
export var luck : int = 5
export var intelligance : int = 5
export var color = Color(0.6,0.4,0.2,1)
export var moveSpots = []
export var attacks = ["RockSmash", "Punch"]
