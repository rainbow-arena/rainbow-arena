--- Require ---
local vector = require("lib.hump.vector")
--- ==== ---


--- Module ---
local entity = {}
--- ==== ---


--- Module functions ---
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

function entity.getmidpoint(e1, e2)
	return e1.Position + (e2.Position - e1.Position):normalized() * e1.Radius
end

---

-- From hump.class
local function include_helper(to, from, seen)
	if from == nil then
		return to
	---
	elseif vector.isvector(from) then
		return from:clone()
	---
	elseif type(from) ~= 'table' then
		return from
	elseif seen[from] then
		return seen[from]
	end

	seen[from] = to
	for k,v in pairs(from) do
		k = include_helper({}, k, seen) -- keys might also be tables
		if to[k] == nil then
			to[k] = include_helper({}, v, seen)
		end
	end
	return to
end

-- deeply copies `other' into `class'. keys in `other' that are already
-- defined in `class' are omitted
local function include(class, other)
	return include_helper(class, other, {})
end

-- returns a deep copy of `other'
local function clone(other)
	return setmetatable(include({}, other), getmetatable(other))
end

function entity.clone(e)
	return clone(e)
end
--- ==== ---


return entity
