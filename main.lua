--[[
	Rainbow Arena, a game by LegoSpacy
]]

--[[
	Stuff to do:
		Make camera keep reference to a target entity instead of CameraTarget being a component
		Makes maps not just square arenas - Tiled and STI?


		Graphics: background
		Content: weapons, powerups?
		Matches: Actual match/level logic, bot AI
		Menus: main, weapon select, colour select


	IDEAS:
		Make this a single-player game where the player goes through levels.
			Destroy all enemies/get to exit?

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

		Weapon ideas:
			Teleport projectile
				teleports shooter to where projectile dies/hits
				allow enemy projectiles to prematurely trigger teleport

		Game modifiers/stages:
			Invisibility - combtatant only shown when it lights up - firing, hitting wall, heartbeat
			Ice - no drag
			Everyone has the same weapon, when anyone changes weapons everyone else does too.
]]

--- Require ---
local gs = require("lib.hump.gamestate")
--- ==== ---


function love.load()
	gs.registerEvents()
	gs.switch(require("states.game"))
end
