local util = require("util")
local partial = hs.fnutils.partial

local hammerspoon = function()
	local app_name = "Hammerspoon"
	local win_name = "Hammerspoon Console"
	local app = hs.application.get("Hammerspoon")
	local win = app:findWindow(win_name)

	if win then
		hs.closeConsole()
		hs.window.orderedWindows()[2]:focus()
	else
		local bringToFront = true
		hs.openConsole(bringToFront)

		app = hs.application.get(app_name)
		local console = app:findWindow(win_name)

		if #hs.screen.allScreens() > 1 then
			if console:screen() == hs.screen.primaryScreen() then
				local otherScreen = hs.fnutils.find(
					hs.screen.allScreens(),
					function(screen)
						return screen ~= hs.screen.primaryScreen()
					end
				)
				console:moveToScreen(otherScreen)
			end
			hs.grid.set(console, "7,0 5x12")
		else
			hs.grid.set(console, "8,0 4x12")
		end
	end
end

local browsers = {
	{ "b", "Firefox", desc = "Default" },
	{ "e", "Microsoft Edge" },
	{ "f", "Firefox" },
	{ "g", "Google Chrome" },
	{ "o", "Opera" },
	{ "s", "Safari" },
	{ "v", "Vivaldi" },
	{ "r", "io.raindrop.macapp", desc = "Raindrop" },
}

local messengers = {
	{ "a", "Messages", desc = "Apple Messages" },
	{ "d", "Discord" },
	{ "e", "Mail", desc = "Email" },
	{ "f", "Messenger", desc = "Facebook Messenger" },
	{ "i", "Ivory" },
	{ "m", "Messages", desc = "Default" },
	{ "s", "Slack" },
	{ "w", "WhatsApp" },
	{ "x", "Element" },
	{ "t", "Telegram" },
}

local terminals = {
	{ "w", "WezTerm" },
	{ "t", hs.settings.get("default_terminal"), desc = "Default" },
	{ "i", "iTerm 2" },
	{ "a", "Terminal", desc = "Apple Terminal" },
}

local notes = {
	{ "n", "Notion", desc = "Default" },
	{ "a", "Notes", desc = "Apple Notes" },
	{ "o", "Notion" },
}

local vpns = {
	{ "c", "ClearVPN" },
	{ "n", "NordVPN" },
	{ "s", "Surfshark" },
}

local reminders = {
	{ "a", "Reminders", desc = "Apple Reminders" },
	{ "r", hs.settings.get("default_reminders"), desc = "Default" },
	{ "d", "Due" },
	{ "g", "Godspeed" },
	{
		"c",
		function()
			hs.urlevent.openURL(
				"raycast://extensions/raycast/apple-reminders/my-reminders"
			)
		end,
		desc = "Raycast Agenda",
	},
}

local music = {
	{ "s", "Spotify" },
	{ "m", "Music", desc = "Apple Music" },
}

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

return {
	cell = {
		width = 140,
		height = 120,
	},
	table = {
		cols = 5,
	},
	binds = {
		{ "1", "1Password" },
		{ "b", browsers, desc = "Browsers" },
		{ "c", "Calendar" },
		{ "d", "Dash" },
		{ "e", "Neovide" },
		{ "f", "Figma" },
		{ "h", hammerspoon, desc = "Hammerspoon" },
		{ "m", messengers, desc = "Messaging" },
		{ "l", "Timemator" },
		{ "n", notes, desc = "Notes" },
		{ "p", music, desc = "Music" },
		{ "r", reminders, desc = "Reminders" },
		{ "s", splits, desc = "Splits" },
		{ "t", terminals, desc = "Terminals" },
		{ "v", vpns, desc = "VPNs" },
		{ "z", "zoom.us", desc = "Zoom" },
	},
}
