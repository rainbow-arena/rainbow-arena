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
	Milestones:
		- Singleplayer
			- Matches against dumb bots
				- Menus
					- Match setup
						- Combatant color/weapon select
						- Number of bots, their weapons, etc.
						- Arena
				- Scoring (kills)
				- Game over screen
			- Make bots smarter
			- Campaign (eh, maybe)?
			- Match types
				- FFA
				- Team Deathmatch
				- CTF
				- KotH?
		- Multiplayer
			- Device-local multiplayer?
			- LAN multiplayer
			- Internet multiplayer


	Stuff to do:
		Makes maps not just square arenas - Tiled and STI?
		I'd prefer not to have tile-based maps.
		Simplest arena is a circle.

		Abstract out camera stuff into camera objects.

		Multiplayer:
			Make Session object that has a World and all the data needed,
			eg. is a client or server, players, weapon choices, scores, ...

			Define how to sync each component somewhere?
			How to sync Sound, since they're a source?


	IDEAS:
		Make this a single-player game where the player goes through levels.
			Destroy all enemies/get to exit?

		Singleplayer, have to hit/collide with correct color combatant?

		Rhythm component, like Guitar Hero?
		Or just the background and visual elements react to the music.

		Gameplay replays.

		When picking your weapon, have a testing arena running
		in which you can test each weapon against combatants with no AI.

		Along with a weapon (or maybe multiple weapons), you can also pick
		a powerup.

		Reticles:
			Dynamic.
			eg. Projectile reticles are a circle that changes size
			to show spread depending on how far it is from you.
			eg. Beam laser reticle is a line with bars |-----|
			that rotates to always be perpendicular to look vector
			and shows beam width.

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

			Tractor beam, drawable shield (like BSF) - make generated electricity effect

			Implosion bomb - use shaders for cool visual effect.

			Multi-directional gun - fire forward, and 60 degrees to either side?.

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
