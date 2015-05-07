local util = {}

---

-- Prints a formatted string.
function util.printf(s, ...)
	return print(string.format(s, ...))
end

-- Like printf, but throws an error with the formatted string
-- as the error message.
function util.errorf(s, ...)
	return error(string.format(s, ...))
end

---

util.string = {}

function util.string.split(str, delim)
	-- TODO: Write this.
end

---

util.table = {}

-- Returns a deep copy of a table.
function util.table.clone(t)
	local c = setmetatable({}, getmetatable(t))
	for k, v in pairs(t) do
		if type(v) == "table" then
			c[k] = util.table.clone(v)
		else
			c[k] = v
		end
	end
	return c
end

-- Joins two or more tables together.
function util.table.join(...)
	local result = {}
	for _, tab in ipairs({...}) do
		---
		-- Deal with number keys first so we can get them in order.
		for i, v in ipairs(tab) do
			table.insert(result, v)
		end

		for k, v in pairs(tab) do
			if not tonumber(k) then
				result[k] = v
			end
		end
		---
	end
	return result
end

-- Returns a new table with the values of t as keys and vice versa.
function util.table.invert(t)
	local result = {}
	for k, v in pairs(t) do
		result[v] = k
	end
	return result
end

-- If t doesn't have a key that kv does, the key
-- and its value from kv will be added to t.
function util.table.fill(t, kv)
	for k, v in pairs(kv) do
		if t[k] == nil then
			t[k] = v
		end
	end
end

-- Checks whether t has all the keys listed in keys.
function util.table.has(t, keys)
	for _, c in ipairs(keys) do
		if not t[c] then return false end
	end
	return true
end

-- Like has, but on failure also returns a string detailing the missing fields.
function util.table.check(t, keys, msg)
	local missing = {}

	for _, c in ipairs(keys) do
		if not t[c] then
			table.insert(missing, c)
		end
	end

	if #missing > 0 then
		return false, (msg and (msg .. ": ") or "") "missing fields: " .. table.concat(missing, ", ")
	else
		return true
	end
end

-- Returns the highest numerical key of t.
function util.table.maxn(t)
	local max = -math.huge
	for k, v in pairs(t) do
		if type(k) == "number" then
			max = math.max(k, max)
		end
	end
	return (max ~= -math.huge) and max or nil
end

-- Returns the number of elements in t.
function util.table.nelem(t)
	local count = 0
	for k,v in pairs(t) do
		count = count + 1
	end
	return count
end

---

util.io = {}

-- Given a file handle, this function returns the size
-- of the file pointed to by that handle.
function util.io.filesize(file)
	local current = file:seek()
	local size = file:seek("end")
	file:seek("set", current)
	return size
end

---

util.math = {}

-- Rounds num to idp decimal places.
-- http://lua-users.org/wiki/SimpleRound
function util.math.round(num, idp)
	local mult = 10^(idp or 0)
	return math.floor(num * mult + 0.5) / mult
end

-- Returns the integer part of n.
function util.math.truncate(n)
	return math.floor(n + 0.5)
end

-- Checks whether n is within min and max, inclusive.
function util.math.range(min, n, max)
	return (n >= min) and (n <= max)
end

-- Returns n if it is within min and max, or else
-- returns min or max if n is too high or low respectively.
function util.math.clamp(min, n, max)
	return math.max(math.min(n, max), min)
end

-- Returns 1 if n is positive, -1 if n is negative or 0 if n is 0.
function util.math.sign(n)
	return (n > 0) and 1 or (n < 0) and -1 or 0
end

-- Maps n from one range to another range.
function util.math.map(n, in_min, in_max, out_min, out_max)
	return (n - in_min) * (out_max - out_min) / (in_max - in_min) + out_min
end


return util
