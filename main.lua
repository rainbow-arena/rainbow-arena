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
		Add Force and Damage events, etc.
			Replace projectile force application with this.
			Replace explosion force application.
			Reduce code repetition in circle color pulsing.
		Standardise projectiles better (including use of events).
		Events: Figure out entities which don't have required components.
]]

local gs = require("lib.hump.gamestate")

local state_game = require("states.game")

function love.load()
	gs.registerEvents()

	gs.switch(state_game)
end
