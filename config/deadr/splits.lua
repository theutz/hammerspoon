local util = require("util")
local partial = hs.fnutils.partial

local function split(...)
	local names = table.pack(...)
	return function()
		local sizes = { "0,0 8x12", "8,0 4x12" }
		local apps = {}
		for i, name in ipairs(names) do
			apps[i] = hs.settings.get(name)
			apps[i] = hs.application.open(apps[i] or name)
			if apps[i] == nil then
				local button, default = hs.dialog.textPrompt(
					name,
					string.format("What should the default value be?", name),
					"",
					"Save",
					"Cancel"
				)
				if button == "Save" then
					hs.settings.set(name, default)
					apps[i] = hs.application.open(default)
				end
			end
		end
		for i, name in ipairs(names) do
			if apps[i] then
				util.withAxHotfix(function(win)
					win:moveToScreen(hs.screen:primaryScreen())
					hs.timer.doAfter(0.1, function()
						hs.grid.set(win, sizes[i])
					end)
				end)(apps[i]:mainWindow())
			end
		end
		util.withAxHotfix(function(win)
			win:focus()
		end)(apps[1]:mainWindow())
	end
end

local se = partial(split, "default_editor") --[[@as function]]
local sb = partial(split, "default_browser") --[[@as function]]

local splits = {
	{
		"e",
		{
			{ "t", se("default_terminal"), desc = "Terminal" },
			{ "h", se("Hammerspoon"), desc = "Hammerspoon" },
			{ "b", se("default_browser"), desc = "Browser" },
		},
		desc = "Editor",
	},
	{
		"b",
		{
			{ "t", sb("default_terminal"), desc = "Terminal" },
			{ "e", sb("default_editor"), desc = "Editor" },
			{ "m", sb("default_email"), desc = "Email" },
			{ "c", sb("default_calendar"), desc = "Calendar" },
			{ "s", sb("Slack"), desc = "Slack" },
		},
		desc = "Browser",
	},
}

return splits
