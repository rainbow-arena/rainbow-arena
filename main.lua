--[[
	Rainbow Arena, a game by LegoSpacy
]]

--[[
	Stuff to do:
		Fix collision
			Set mass of object at creation, remove CalculateMass system
		Rewrite weapons using systems and make weapons entities
			eg. so I can swap out components to change a weapon from ammo to cooldown-based
		Make camera keep reference to a target entity instead of CameraTarget being a component
		Makes maps not just square arenas - Tiled and STI?
		Some way to get entities in actual radius, not just AABB calculated from radius


		Graphics: background
		Content: weapons, powerups?
		Matches: Actual match/level logic, bot AI
		Menus: main, weapon select, colour select

		Weapons:
			Pistol
			Burst rifle
			Minigun, and triple barreled
			Shotgun
			Bomb launcher (sticky and normal)

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

	IDEAS:
		Make this a single-player game where the player goes through levels.
			Destroy all enemies/get to exit?
		Invisibility - combtatant only shown when it lights up - firing, hitting wall, heartbeat
		Circular arena

		Stages:
			Ice - no drag
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
