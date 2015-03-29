local interpolate = {}

---

function interpolate.smooth(value, target, dt, speed)
	return value + (target - value) * (speed or INTERPOLATE_SPEED) * dt
end

---

return interpolate
