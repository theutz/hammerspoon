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
}

local messengers = {
	{ "d", "Discord" },
	{ "e", "Element" },
	{ "m", "Mail", desc = "Email" },
	{ "f", "Messenger", desc = "Facebook Messenger" },
	{ "a", "Messages", desc = "Apple Messages" },
	{ "s", "Slack" },
	{ "w", "WhatsApp" },
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

return {
	max_cols = 5,
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
		{ "t", terminals, desc = "Terminals" },
		{ "u", "Due" },
		{ "v", vpns, desc = "VPNs" },
		{ "z", "zoom.us", desc = "Zoom" },
	},
}
