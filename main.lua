--[[
	Rainbow Arena, a game by LegoSpacy
]]

--[[
	Stuff to do:
		Rewrite weapons using systems and make weapons entities
			eg. so I can swap out components to change a weapon from ammo to cooldown-based
			Have host.Weapon, have a Weapon system that is basically a nested entity system
				that works on Weapon subcomponents.

		Make camera keep reference to a target entity instead of CameraTarget being a component
		Makes maps not just square arenas - Tiled and STI?
		Make health smoothly graphically transition.


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

		Weapons:
			Teleport projectile
				teleports shooter to where projectile dies/hits
				allow enemy projectiles to prematurely trigger teleport

		Game modifiers/stages:
			Invisibility - combtatant only shown when it lights up - firing, hitting wall, heartbeat
			Ice - no drag
			Everyone has the same weapon, when anyone changes weapons everyone else does too.
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
