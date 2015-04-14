--[[
	A weapon is a table of components.
	These components are separate from components in the entity system.

	There are some flags:
		Firing: eg. is the LMB being held down?
		AmmoReady: ammo systems modify this, firing systems check this.
		ShotReady: whether shot delay has expired. Rename this component?

	Systems:
		Firing systems check Firing, AmmoReady and ShotReady
		Ammo systems set AmmoReady as required
		Shot delay system sets ShotReady as required
]]


local vector = require("lib.hump.vector")
local util = require("lib.self.util")

local file = require("util.file")

---

local math_sin = math.sin
local math_cos = math.cos

local table_has = util.table.has

---

local WEAPON_SYSTEM_DIR = "logic/weapon"

---

local weapon_systems = {}

---

return {
	init = function(world)
		file.diriter(WEAPON_SYSTEM_DIR, function(dir, item)
			local t = love.filesystem.load(dir .. "/" .. item)()

			if t.systems then
				for _, system in ipairs(t.systems) do
					system.priority = system.priority or 0
					table.insert(weapon_systems, system)
				end
			end

			table.sort(weapon_systems, function(a, b)
				return a.priority > b.priority
			end)
		end)
	end,

	systems = {
		{
			name = "UpdateWeapon",
			requires = {"Position", "Radius", "Rotation", "Weapon"},
			update = function(entity, world, dt)
				local weapon = entity.Weapon

				for _, system in ipairs(weapon_systems) do
					if table_has(weapon, system.requires) then
						system.update(weapon, entity, world, dt)
					end
				end
			end
		}
	},

	events = {

	}
}
