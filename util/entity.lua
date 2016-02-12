local entity = {}

---

function entity.choose(ent1, ent2, condition)
	if condition(ent1) then
		return ent1, ent2
	elseif condition(ent2) then
		return ent2, ent1
	else
		return
	end
end

function entity.choosekey(ent1, ent2, key)
	return entity.choose(ent1, ent2, function(e)
		return e[key]
	end)
end

---

return entity
