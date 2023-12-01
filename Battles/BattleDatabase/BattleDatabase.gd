extends Node
#each dictionary element is a battle screen layout
# the first matrix in a pair is the heroGrid on the left while the second is the enemyGrid on the right
#0 = empty tile, 1 = spawn point (for hero grid), 2 = unnocupiable
# place the string that is a reference to the name of the monster or hero on the location you want them to be on the grid
var battles = {
	1: [ # test battle
		[
			[1,1,0,0,0],
			[1,1,0,0,0],
			[0,0,0,0,0]
			
		],
		[
			[0,"Goblin",0,0,0],
			[0,0,"Golem",0,0],
			["Wizard",0,0,0,0]
			
		]
	],
	2:[ # test battle
		[
			[2,2,1,0,0],
			[2,2,1,0,0],
			[2,2,1,0,0],
			
		],
		[
			[0,0,"Goblin",0,0,0],
			[0,0,"Goblin",0,0,0]
			
		]
	],
	3:[ # test battle
		[
			[2,2,1,0,0],
			[0,0,1,2,2],
			[2,2,1,0,0],
			
		],
		[
			[0,0,"Goblin",0,0,0],
			[0,"Goblin","Golem","Goblin",0,0],
			[0,0,"Goblin",0,0,0]
			
		]
	],
	4:[ # test battle
		[
			[0,0,0,0],
			[2,2,0,2],
			[2,0,2,2],
			[0,0,0,0],
			
		],
		[
			[2,2,"Wizard",0,2,2],
			[2,0,2,2,0,2],
			[2,0,"Wizard",0,0,2],
			[2,0,2,2,0,2],
			[2,0,2,2,0,2]
			
		]
	],
	5:[ # test battle
		[
			[0,0,0,0],
			[0,0,0,0],
			[0,0,0,0]
			
			
		],
		[
			[0,"Wizard",0,"Wizard",0],
			[0,0,"Golem",0,0],
			
			
		]
	],
	6:[ # test battle
		[
			[0,0,0],
			[0,2,0],
			[0,0,0]
			
			
		],
		[
			["Golem"],
			[2],
			["Golem"]
			
			
		]
	],
	7: [ # test battle
		[
			[1,0,0,0,0],
			[0,0,0,0,1],
			[0,0,1,0,0]
			
		],
		[
			[0,"Goblin",0,0,0],
			[0,0,"Goblin",0,0],
			["Goblin",0,0,0,0]
			
		]
	],
	8: [ # test battle
		[
			[1,0,0,0,0],
			[0,0,0,0,1],
			[0,0,1,0,0]
			
		],
		[
			[0,"Golem",0,0,0],
			[0,0,"Golem",0,0],
			["Golem",0,0,0,0]
			
		]
	],
	9: [ # test battle
		[
			[1,0,0,0,0],
			[0,0,0,0,1],
			[0,0,1,0,0]
			
		],
		[
			[0,"Wizard",0,0,0],
			[0,0,"Wizard",0,0],
			["Wizard",0,0,0,0]
			
		]
	],
}

					
				
		
#returns the battle matrix based off of the given battle_id given
func get_battle(battle_id):
	if(battles.has(battle_id)):
		return battles[battle_id]
	else:
		return null

