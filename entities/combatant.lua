local class = require("lib.hump.class")
local vector = require("lib.hump.vector")

local circle = require("util.circle")

---

-- TODO: Allow passing raw template, defaults are filled and others are not touched.
-- .new() function, nest these for miniturret.

local e_combatant = class{}

function e_combatant:init(arg)
	self.Name = arg.name
	self.Team = arg.team

	self.Radius = arg.radius or 30
	self.Mass = arg.mass or circle.area(self.Radius)
	self.Color = arg.color or {255, 255, 255}

	self.Position = arg.position and arg.position:clone() or vector.new(0, 0)
	self.Velocity = arg.velocity and arg.velocity:clone() or vector.new(0, 0)
	self.Acceleration = arg.acceleration and arg.acceleration:clone() or vector.new(0, 0)

	self.MoveAcceleration = arg.move_acceleration
	self.Drag = arg.drag

	self.CollisionPhysics = true

	self.ArenaBounded = true

	self.Rotation = arg.rotation or 0
	self.RotationSpeed = arg.rotation_speed or 4

	self.Health = arg.health
	self.MaxHealth = arg.health
	self.DeathExplosion = true

	self.Weapon = arg.weapon

	if arg.player then
		self.Player = true
		self.CameraTarget = true
	end
end

---

return e_combatant
