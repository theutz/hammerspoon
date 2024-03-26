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
	{ "t", "WezTerm", desc = "Default" },
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
	{ "r", "Godspeed", desc = "Default" },
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
	{ "m", "" },
}

local function mainVertical(primary, secondary)
	primary = hs.application.open(primary)
	secondary = hs.application.open(secondary)
	if primary and secondary then
		hs.grid.set(primary:mainWindow(), "0,0 8x12")
		hs.grid.set(secondary:mainWindow(), "8,0 4x12")
		primary:mainWindow():focus()
	end
end

local splits = {
	{
		"e",
		partial(mainVertical, "Neovide", "WezTerm"),
		desc = "Editor/Terminal",
	},
	{
		"b",
		partial(mainVertical, "Google Chrome", "Neovide"),
		desc = "Browser/Editor",
	},
	{
		"h",
		partial(mainVertical, "Neovide", "Hammerspoon"),
		desc = "Editor/Hammerspoon",
	},
}

return {
	cell = {
		width = 140,
		height = 100,
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
		{ "p", "Spotify" },
		{ "r", reminders, desc = "Reminders" },
		{ "s", splits, desc = "Splits" },
		{ "t", terminals, desc = "Terminals" },
		{ "v", vpns, desc = "VPNs" },
		{ "z", "zoom.us", desc = "Zoom" },
	},
}
