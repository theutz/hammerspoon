local util = require("util")

local function split(...)
	local names = table.pack(...)
	return function()
		local sizes = { "0,0 8x12", "8,0 4x12" }
		local apps = {}
		for i, name in ipairs(names) do
			apps[i] = hs.settings.get(name)
			apps[i] = hs.application.open(apps[i] or name)
			if apps[i] then
				util.withAxHotfix(function(win)
					hs.grid.set(win, sizes[i])
				end)(apps[i]:mainWindow())
			end
		end
		util.withAxHotfix(function(win)
			win:focus()
		end)(apps[1]:mainWindow())
	end
end

local splits = {
	{
		"e",
		{
			{
				"t",
				split("default_editor", "default_terminal"),
				desc = "Terminal",
			},
			{
				"h",
				split("default_editor", "Hammerspoon"),
				desc = "Hammerspoon",
			},
			{
				"b",
				split("default_editor", "default_browser"),
				desc = "Browser",
			},
		},
		desc = "Editor",
	},
	{
		"b",
		{
			{
				"t",
				split("default_browser", "default_terminal"),
				desc = "Terminal",
			},
			{
				"e",
				split("default_browser", "default_editor"),
				desc = "Editor",
			},
		},
		desc = "Browser",
	},
}

return splits
