local class = require("lib.hump.class")
local vector = require("lib.hump.vector")

---

local e_combatant = class{}

function e_combatant:init(arg)
	assert(arg.position, "Need a position to create combatant!")

	self.Name = arg.name
	self.Team = arg.team

	self.Radius = arg.radius or 30
	self.Color = arg.color or {255, 255, 255}

	self.Position = arg.position:clone()
	self.Velocity = arg.velocity and arg.velocity:clone() or vector.new(0, 0)
	self.Acceleration = arg.acceleration and arg.acceleration:clone() or vector.new(0, 0)

	self.MoveAcceleration = arg.move_acceleration
	self.Drag = arg.drag

	self.CollisionPhysics = true

	self.Rotation = arg.rotation or 0
	self.RotationSpeed = arg.rotation_speed or 2

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
