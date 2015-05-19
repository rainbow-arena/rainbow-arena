local wepm_shotdelay = require("entities.weapons.modules.shotdelay")
local wepm_shoteffect = require("entities.weapons.modules.shoteffect")
local wepm_projectile = require("entities.weapons.modules.projectile")

---

local wep_machinegun = {}
wep_machinegun.__index = wep_machinegun

---

function wep_machinegun.new(args)
	local machinegun = {}

	args = args or {}

	---

	wepm_shotdelay.init(machinegun, arg.shotdelay or 0.2)

	wepm_shoteffect.init(machinegun, {
		shakedur = args.shakedur or 0.5,
		shakeamp = args.shakeamp or 2,
		shakerad = args.shakerad or 100,

		shotsound = args.shotsound or "audio/weapons/laser_shot.wav"
	})

	wepm_projectile.init(machinegun, args.projectile, args.projvel or 300)

	---

	return setmetatable(machinegun, {__index = wep_machinegun})
end

function wep_machinegun:update(host, world, dt)
	wepm_shotdelay.update(self, host, world, dt)
end

function wep_machinegun:fire(host, world)

end

function wep_machinegun:can_fire(host, world)
	return wepm_shotdelay.can_fire(self, host, world)
end

function wep_machinegun:firing(host, world, dt)
	if self:can_fire(world) then
		wepm_projectile.fire(self, host, world)

		wepm_shotdelay.on_fire(self, host, world)

		wepm_shoteffect.do_effect(self, host, world)
	end
end

function wep_machinegun:cease(self, host, world)

end

---

return wep_machinegun
