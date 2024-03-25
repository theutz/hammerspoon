return {
	max_cols = 5,
	binds = {
		{ "1", "1Password" },
		{
			"b",
			{
				{ "b", "Firefox", desc = "Default" },
				{ "e", "Microsoft Edge" },
				{ "f", "Firefox" },
				{ "g", "Google Chrome" },
				{ "o", "Opera" },
				{ "s", "Safari" },
				{ "v", "Vivaldi" },
			},
			desc = "Browsers",
		},
		{ "c", "Calendar" },
		{ "d", "Dash" },
		{ "e", "Neovide" },
		{ "f", "Figma" },
		{
			"h",
			function()
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
			end,
			desc = "Hammerspoon",
		},
		{
			"m",
			{
				{ "d", "Discord" },
				{ "e", "Element" },
				{ "m", "Mail", desc = "Email" },
				{ "f", "Messenger", desc = "Facebook Messenger" },
				{ "a", "Messages", desc = "Apple Messages" },
				{ "s", "Slack" },
				{ "w", "WhatsApp" },
			},
			desc = "Messaging",
		},
		{ "l", "Timemator" },
		{
			"n",
			{
				{ "a", "Notes", desc = "Apple Notes" },
				{ "n", "Notion", desc = "Default" },
				{ "o", "Notion" },
			},
			desc = "Notes",
		},
		{ "p", "Spotify" },
		{
			"t",
			{
				{ "w", "WezTerm" },
				{ "t", "WezTerm", desc = "Default" },
				{ "i", "iTerm 2" },
				{ "a", "Terminal", desc = "Apple Terminal" },
			},
			desc = "Terminals",
		},
		{ "u", "Due" },
		{
			"v",
			{
				{ "c", "ClearVPN" },
				{ "n", "NordVPN" },
				{ "s", "Surfshark" },
			},
			desc = "VPNs",
		},
		{ "w", "Neovide" },
		{ "z", "zoom.us", desc = "Zoom" },
	},
}
