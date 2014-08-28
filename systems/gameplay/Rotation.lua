local vector = require("lib.hump.vector")
local util = require("lib.self.util")

local pi = math.pi
local abs = math.abs
local min = math.min
local sin, cos = math.sin, math.cos
local sign = util.math.sign
local range = util.math.range

return {
	systems = {
		{
			name = "UpdateRotation",
			requires = {"Rotation", "RotationTarget", "RotationSpeed"},
			update = function(entity, world, dt)
				local current = vector.new(cos(entity.Rotation), sin(entity.Rotation))
				local target = vector.new(cos(entity.Rotation), sin(entity.Rotation))


			end
		}
	}
}
