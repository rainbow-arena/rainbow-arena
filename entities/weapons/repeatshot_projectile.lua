local util = require("lib.self.util")

local ss_proj_weapon = require("content.weapons.singleshot_projectile")

return function(cooldown, projectile_speed, projectile_prototype)
	local weapon = ss_proj_weapon(cooldown, projectile_speed, projectile_prototype)
	weapon.type = "repeat"
	return weapon
end
