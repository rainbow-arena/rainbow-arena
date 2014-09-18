--[[
	Rainbow Arena, a game by LegoSpacy
]]

--[[
	Stuff to do:
		Graphics: background
		Content: weapons, powerups?
		Matches: Actual match/level logic, bot AI

		TODO:
			Make player rotation limited by a turn rate.

		Weapons to make:
			Beam laser
			Sticky bomb launcher
			Rocket launcher
			Guided missile launcher
			Turret deployer
			Sonic (dubstep) gun
			Gravity ball launcher
			Multi-lock missile launcher
			Firework gun - weak bomb-launching shotgun
]]

local gs = require("lib.hump.gamestate")

local state_test = require("states.test")

---

SOUND_POSITION_SCALE = 256

---

function love.load()
	gs.registerEvents()

	gs.switch(state_test)
end
