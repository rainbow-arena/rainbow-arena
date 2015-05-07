local class = require("lib.hump.class")

---

local wepm_shotdelay = require("entities.weapons.modules.shotdelay")
local wepm_shoteffect = require("entities.weapons.modules.shoteffect")
local wepm_projectile = require("entities.weapons.modules.projectile")

---

local wep_machinegun = class{}

---

function wep_machinegun:init(args)
	args = args or {}

	---

	wepm_shotdelay.init(wep_machinegun, arg.shotdelay or 0.2)

	wepm_shoteffect.init(wep_machinegun, {
		shakedur = args.shakedur or 0.5,
		shakeamp = args.shakeamp or 2,
		shakerad = args.shakerad or 100,

		shotsound = args.shotsound or "audio/weapons/laser_shot.wav"
	})

	wepm_projectile.init(wepm_machinegun, args.projectile, args.projvel or 100)
end

function wep_machinegun:update(host, world, dt)
	wepm_shotdelay.update(wep_machinegun, host, world, dt)
end

function wep_machinegun:fire(host, world)

end

function wep_machinegun:can_fire(host, world)
	return wepm_shotdelay.can_fire(wep_machinegun, host, world)
end

function wep_machinegun:firing(host, world, dt)
	if self:can_fire(world) then
		wepm_projectile.fire(wep_machinegun, host, world)

		wepm_shotdelay.on_fire(wep_machinegun, host, world)

		wepm_shoteffect.do_effect(wep_machinegun, host, world)
	end
end

function wep_machinegun:cease(self, host, world)

end

---

return wep_machinegun
