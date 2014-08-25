--[[
	Rainbow Arena, a game by LegoSpacy
]]

--[[
	Stuff to do:
		Graphics: combatants, background, visual effects (like screenshake), etc.
		Content: weapons, powerups, etc.
		Matches: Actual match/level logic
		Sound: PlaySound event with position and source?

		Explosions: Explosion event with position and force,
			or explosion entity has components that specify force?

	TODO:
		Add Force and/or Damage events?
		Standardise projectiles better (including use of events).
		Events: Figure out entities which don't have required components.

		Weapons to make:
			Beam laser
			Sticky bomb launcher
			Rocket launcher
			Guided missile launcher
			Turret deployer
			Sonic (dubstep) gun
			Gravity ball launcher
]]

local gs = require("lib.hump.gamestate")

local state_game = require("states.game")

function love.load()
	gs.registerEvents()

	gs.switch(state_game)
end
