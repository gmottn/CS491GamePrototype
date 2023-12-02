extends Node


export var max_health : int = 200
onready var health = max_health
export var max_mp : int = 25
onready var mp = max_mp
export var strength : int = 10
export var defense : int = 25
export var agility : int = 5
export var speed : int = 5
export var luck : int = 5
export var intelligance : int = 5
export var color = Color(1,0,1,1)
export var moveSpots = [[1,0],[-1,0],[0,-1],[0,1]]
export var attacks = ["Slash", "Shield", "TripleCut", "CrossSlash"]
