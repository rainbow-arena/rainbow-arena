local file = {}

---

function file.diriter(dir, func)
	for _, item in ipairs(love.filesystem.getDirectoryItems(dir)) do
		if love.filesystem.isDirectory(dir .. "/" .. item) then
			file.diriter(dir .. "/" .. item, func, mask)
		else
			func(dir, item)
		end
	end
end

---

return file
