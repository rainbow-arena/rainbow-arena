--- Modules ---
local file = {}
--- ==== ---

--- Module functions ---
function file.diriter(dir, func)
	local items = {}

	for _, item in ipairs(love.filesystem.getDirectoryItems(dir)) do
		items[#items + 1] = item
	end

	table.sort(items)

	for _, item in ipairs(items) do
		if love.filesystem.getInfo(dir .. "/" .. item, "directory") then
			file.diriter(dir .. "/" .. item, func, mask)
		else
			func(dir, item)
		end
	end
end
--- ==== ---

return file
