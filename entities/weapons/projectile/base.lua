local util = require("lib.self.util")

---

local wepm_shotdelay = require("entities.weapons.modules.shotdelay")
local wepm_shoteffect = require("entities.weapons.modules.shoteffect")
local wepm_projectile = require("entities.weapons.modules.projectile")
local wepm_recoil = require("entities.weapons.modules.recoil")

---

local wep_projectile_base = {}
wep_projectile_base.__index = wep_projectile_base

---

function wep_projectile_base.new(args)
	local w = {}

	---

	assert(util.table.check(args, {
		"shotdelay",

		"projectile",
		"shotvel"
	}, "wep_projectile"))

	---

	wepm_shotdelay.init(w, args.shotdelay)

	wepm_shoteffect.init(w, {
		shakedur = args.shakedur or 0.5,
		shakeamp = args.shakeamp or 1,
		shakerad = args.shakerad or 100,

		shotsound = args.shotsound or "audio/weapons/laser_shot.wav"
	})

	wepm_projectile.init(w, args.projectile, args.shotvel)

	---

	return setmetatable(w, {__index = wep_projectile_base})
end

---

function wep_projectile_base:can_fire(host, world)
	return wepm_shotdelay.can_fire(self, host, world)
end

---

function wep_projectile_base:fire_projectile(host, world)
	local proj = wepm_projectile.fire(self, host, world)

	wepm_shotdelay.on_fire(self, host, world)
	wepm_shoteffect.do_effect(self, host, world)
	wepm_recoil.apply(self, host, proj)

	host.ColorPulse = 1
end

function wep_projectile_base:fire_when_ready(host, world)
	if self:can_fire(world) then
		self:fire_projectile(host, world)
	end
end

---

function wep_projectile_base:update(host, world, dt)
	wepm_shotdelay.update(self, host, world, dt)
end

function wep_projectile_base:fire(host, world)

end

function wep_projectile_base:firing(host, world, dt)

end

function wep_projectile_base:cease(self, host, world)

end

---

return wep_projectile_base
