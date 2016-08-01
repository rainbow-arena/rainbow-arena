--[[
	Rainbow Arena, a game by Mirrexagon.

	---

	All parts of this project made by me are released into the public domain
	via CC0 (https://creativecommons.org/publicdomain/zero/1.0). See COPYING
	for the license text.

	Sound effects made by me with Bfxr (http://www.bfxr.net) and Audacity
	(http://www.audacityteam.org).

	Music made by me; see http://www.mirrexagon.com/music

	---

	Note that parts NOT made by me remain the property of their respective
	authors; these parts include:
		- lib/hump is HUMP by vrld (https://github.com/vrld/hump)
		- lib/tiny.lua is tiny-ecs by bakpakin (https://github.com/bakpakin/tiny-ecs)
]]

--[[
	Stuff to do:
		Makes maps not just square arenas - Tiled and STI?
		Abstract out camera stuff into camera objects.


		Graphics: background
		Content: weapons, powerups?
		Matches: Actual match/level logic, bot AI
		Menus: main, weapon select, colour select


	IDEAS:
		Make this a single-player game where the player goes through levels.
			Destroy all enemies/get to exit?

		Weapon ideas:
			All weapons should be Mass Effect heat style.
			Have offense, defense and support weapons?
				eg. Support weapon could be telekinetic beam;
				can't kill on its own, but helps others kill target.

			Teleport projectile
				teleports shooter to where projectile dies/hits
				allow enemy projectiles to prematurely trigger teleport

			Make triple-barrelledness easy to add to projectile weapons.
			Other weapon mods?

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

			Tractor beam, drawable shield (like BSF) - make generated electricity effect

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
