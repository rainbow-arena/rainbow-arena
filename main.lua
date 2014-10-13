--[[
	Rainbow Arena, a game by LegoSpacy
]]

--[[
	Stuff to do:
		Graphics: background
		Content: weapons, powerups?
		Matches: Actual match/level logic, bot AI
		Menus: main, weapon select, colour select

		Weapons to make:
			Beam laser
			Guided missile launcher
			Sonic (dubstep) gun
			Gravity ball launcher
			Multi-lock missile launcher
			Firework gun - weak bomb-launching shotgun

	FIX:
		Properly parent screenshake entities for weapon
			effects to weapon holder. Currently, if the holder
			dies while firing, the effect entity stays.
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
